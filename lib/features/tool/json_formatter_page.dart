import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 与物理行号对齐的一段可折叠 JSON 区间（起止行闭区间）。
class _JsonFoldRegion {
  _JsonFoldRegion({required this.startLine, required this.endLine});

  final int startLine;
  final int endLine;
  bool expanded = true;
}

class _VisibleFoldRow {
  _VisibleFoldRow({
    required this.displayLineNumber,
    required this.text,
    this.region,
    required this.isCollapsedSummary,
  });

  final int displayLineNumber;
  final String text;
  final _JsonFoldRegion? region;
  final bool isCollapsedSummary;
}

class JsonFormatterPage extends StatefulWidget {
  const JsonFormatterPage({super.key});

  @override
  State<JsonFormatterPage> createState() => _JsonFormatterPageState();
}

class _JsonFormatterPageState extends State<JsonFormatterPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _editorController = TextEditingController();
  final FocusNode _editorFocus = FocusNode();
  late final ScrollController _editorScrollController;
  late final ScrollController _gutterScrollController;
  late final AnimationController _bgScanController;
  bool _scrollSyncLock = false;

  static const double _editorFontSize = 14;
  static const double _editorLineHeight = 1.5;
  static const double _editorPadTop = 14;
  static const double _editorPadBottom = 14;
  static const double _editorPadRight = 14;
  static const double _editorPadLeftAfterGutter = 8;
  static const double _gutterWidth = 48;
  static const int _minEditorVisualLines = 10;

  String? _errorText;
  int? _errorOffset;
  bool _isBusy = false;
  dynamic _parsedJson;
  bool _showTreeView = false;
  bool _expandAll = false;
  int _indentSize = 2;
  final List<String> _foldPhysicalLines = [];
  final List<_JsonFoldRegion> _foldRegions = [];

  @override
  void initState() {
    super.initState();
    _bgScanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
    _editorScrollController = ScrollController();
    _gutterScrollController = ScrollController();
    _editorScrollController.addListener(_syncGutterScroll);
    _gutterScrollController.addListener(_syncEditorScroll);
    _editorController.addListener(_onEditorChanged);
  }

  double get _linePixelHeight => _editorFontSize * _editorLineHeight;

  void _syncGutterScroll() {
    if (_scrollSyncLock) return;
    if (!_gutterScrollController.hasClients || !_editorScrollController.hasClients) {
      return;
    }
    final t = _editorScrollController.offset;
    final g = _gutterScrollController.offset;
    if ((t - g).abs() < 0.5) return;
    _scrollSyncLock = true;
    _gutterScrollController.jumpTo(
      t.clamp(0.0, _gutterScrollController.position.maxScrollExtent),
    );
    _scrollSyncLock = false;
  }

  void _syncEditorScroll() {
    if (_scrollSyncLock) return;
    if (!_gutterScrollController.hasClients || !_editorScrollController.hasClients) {
      return;
    }
    final t = _editorScrollController.offset;
    final g = _gutterScrollController.offset;
    if ((t - g).abs() < 0.5) return;
    _scrollSyncLock = true;
    _editorScrollController.jumpTo(
      g.clamp(0.0, _editorScrollController.position.maxScrollExtent),
    );
    _scrollSyncLock = false;
  }

  void _onEditorChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _bgScanController.dispose();
    _editorScrollController.removeListener(_syncGutterScroll);
    _gutterScrollController.removeListener(_syncEditorScroll);
    _editorScrollController.dispose();
    _gutterScrollController.dispose();
    _editorController.removeListener(_onEditorChanged);
    _editorController.dispose();
    _editorFocus.dispose();
    super.dispose();
  }

  void _insertAtSelection(String insert) {
    final value = _editorController.value;
    final text = value.text;
    var sel = value.selection;
    if (!sel.isValid) {
      sel = TextSelection.collapsed(offset: text.length);
    }
    final start = sel.start.clamp(0, text.length);
    final end = sel.end.clamp(0, text.length);
    final a = start < end ? start : end;
    final b = start < end ? end : start;
    final newText = text.replaceRange(a, b, insert);
    _editorController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: a + insert.length),
    );
  }

  KeyEventResult _onEditorKey(FocusNode _, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.tab) {
      if (HardwareKeyboard.instance.isShiftPressed) {
        return KeyEventResult.ignored;
      }
      _insertAtSelection(_indentStr);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  String get _indentStr => ' ' * _indentSize;

  (int line, int col) _lineColFromOffset(String text, int offset) {
    if (text.isEmpty) return (1, 1);
    var o = offset.clamp(0, text.length);
    if (o > 0 && o == text.length && text[o - 1] == '\n') {
      o = text.length - 1;
    }
    var line = 1;
    var lineStart = 0;
    for (var i = 0; i < o; i++) {
      if (text[i] == '\n') {
        line++;
        lineStart = i + 1;
      }
    }
    final col = o - lineStart + 1;
    return (line, col);
  }

  void _jumpToError() {
    final off = _errorOffset;
    if (off == null) return;
    final len = _editorController.text.length;
    final clamped = off.clamp(0, len);
    _editorFocus.requestFocus();
    _editorController.selection = TextSelection.collapsed(offset: clamped);
  }

  int _lineCount(String text) {
    if (text.isEmpty) return 1;
    return '\n'.allMatches(text).length + 1;
  }

  void _showSnack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A2A45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _clear() {
    setState(() {
      _editorController.clear();
      _errorText = null;
      _errorOffset = null;
      _parsedJson = null;
      _showTreeView = false;
      _foldPhysicalLines.clear();
      _foldRegions.clear();
    });
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    if (text.isEmpty) {
      _showSnack('剪贴板没有可用文本');
      return;
    }
    setState(() {
      _editorController.text = text;
      _errorText = null;
      _errorOffset = null;
    });
  }

  Future<void> _copyResult() async {
    final text =
        _showTreeView && _foldPhysicalLines.isNotEmpty
            ? _foldPhysicalLines.join('\n')
            : _editorController.text.trim();
    if (text.isEmpty) {
      _showSnack('没有可复制内容');
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    _showSnack('已复制到剪贴板');
  }

  Future<void> _transformJson({required bool pretty}) async {
    final raw = _editorController.text;
    if (raw.trim().isEmpty) {
      _showSnack('请先输入 JSON 内容');
      return;
    }

    setState(() {
      _isBusy = true;
      _errorText = null;
      _errorOffset = null;
    });

    try {
      final dynamic decoded = jsonDecode(raw);
      final String result =
          pretty
              ? JsonEncoder.withIndent(_indentStr).convert(decoded)
              : jsonEncode(decoded);
      setState(() {
        _editorController.text = result;
        _parsedJson = decoded;
        _showTreeView = false;
        _errorOffset = null;
      });
      _showSnack(pretty ? '格式化完成' : '压缩完成');
    } on FormatException catch (e) {
      final off = e.offset;
      final text = _editorController.text;
      String msg = e.message;
      int? jumpOffset;
      if (off != null && off >= 0 && off <= text.length) {
        final (ln, col) = _lineColFromOffset(text, off);
        msg = '第 $ln 行，第 $col 列：${e.message}';
        jumpOffset = off;
      }
      setState(() {
        _errorText = 'JSON 解析失败：$msg';
        _errorOffset = jumpOffset;
        _parsedJson = null;
      });
      _showSnack('JSON 格式有误，请检查后重试');
    } catch (e) {
      setState(() {
        _errorText = 'JSON 解析失败：$e';
        _errorOffset = null;
        _parsedJson = null;
      });
      _showSnack('JSON 格式有误，请检查后重试');
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  void _toggleTreeView() {
    if (!_showTreeView) {
      final raw = _editorController.text;
      if (raw.trim().isEmpty) {
        _showSnack('请先输入 JSON 内容');
        return;
      }
      try {
        _parsedJson = jsonDecode(raw);
      } catch (_) {
        _showSnack('当前内容不是合法 JSON，无法进入折叠模式');
        return;
      }
    }
    setState(() {
      final entering = !_showTreeView;
      _showTreeView = entering;
      if (_showTreeView) {
        _expandAll = true;
        _emitFoldDocument();
      }
    });
  }

  void _setExpandAll(bool value) {
    if (!_showTreeView) return;
    setState(() {
      _expandAll = value;
      for (final r in _foldRegions) {
        if (r.endLine > r.startLine) {
          r.expanded = value;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final editorText = _editorController.text;

    return Scaffold(
      backgroundColor: const Color(0xFF050B1B),
      appBar: AppBar(
        title: const Text('JSON 格式化'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: const Color(0xFFE7F0FF),
        iconTheme: const IconThemeData(color: Color(0xFF8EEFFF)),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF050B1B),
              Color(0xFF0B1630),
              Color(0xFF102447),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedBuilder(
                          animation: _bgScanController,
                          builder: (context, child) {
                            final t = _bgScanController.value;
                            final y = -0.45 + 1.9 * t;
                            return Align(
                              alignment: Alignment(0, y),
                              child: Container(
                                height: 140,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x0000E5FF),
                                      Color(0x1400E5FF),
                                      Color(0x0000E5FF),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xCC101A2D),
                          border: Border.all(color: const Color(0x5500E5FF)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x3000E5FF),
                              blurRadius: 18,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JSON Neural Studio',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF8EEFFF),
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '单面板工作流：在同一编辑区粘贴、格式化、压缩，并支持代码折叠查看。',
                              style: TextStyle(
                                height: 1.5,
                                color: Color(0xFF7C91B5),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          FilledButton.icon(
                            onPressed: _isBusy
                                ? null
                                : () => _transformJson(pretty: true),
                            icon: _isBusy
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.auto_fix_high),
                            label: const Text('格式化'),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF00C6FF),
                              foregroundColor: Colors.white,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: _isBusy
                                ? null
                                : () => _transformJson(pretty: false),
                            icon: const Icon(Icons.compress),
                            label: const Text('压缩'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8EEFFF),
                              side: const BorderSide(color: Color(0x5500E5FF)),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: _pasteFromClipboard,
                            icon: const Icon(Icons.content_paste),
                            label: const Text('粘贴'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8EEFFF),
                              side: const BorderSide(color: Color(0x5500E5FF)),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: _copyResult,
                            icon: const Icon(Icons.copy),
                            label: const Text('复制'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8EEFFF),
                              side: const BorderSide(color: Color(0x5500E5FF)),
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: _toggleTreeView,
                            icon: Icon(
                              _showTreeView ? Icons.unfold_less : Icons.code,
                            ),
                            label: Text(
                              _showTreeView ? '文本模式' : '折叠模式',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF8EEFFF),
                              side: const BorderSide(color: Color(0x5500E5FF)),
                            ),
                          ),
                          if (_showTreeView) ...[
                            OutlinedButton(
                              onPressed: () => _setExpandAll(true),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF8EEFFF),
                                side: const BorderSide(color: Color(0x5500E5FF)),
                              ),
                              child: const Text('全部展开'),
                            ),
                            OutlinedButton(
                              onPressed: () => _setExpandAll(false),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF8EEFFF),
                                side: const BorderSide(color: Color(0x5500E5FF)),
                              ),
                              child: const Text('全部收起'),
                            ),
                          ],
                          OutlinedButton.icon(
                            onPressed: _clear,
                            icon: const Icon(Icons.clear),
                            label: const Text('清空'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFFFB4B4),
                              side: const BorderSide(color: Color(0x55FF6B6B)),
                            ),
                          ),
                          const SizedBox(width: 4),
                          SegmentedButton<int>(
                            segments: const [
                              ButtonSegment<int>(
                                value: 2,
                                label: Text('缩进 2'),
                              ),
                              ButtonSegment<int>(
                                value: 4,
                                label: Text('缩进 4'),
                              ),
                            ],
                            selected: {_indentSize},
                            onSelectionChanged: (s) {
                              setState(() {
                                _indentSize = s.first;
                                if (_showTreeView && _parsedJson != null) {
                                  _emitFoldDocument();
                                }
                              });
                            },
                            style: SegmentedButton.styleFrom(
                              backgroundColor: const Color(0xFF152846),
                              foregroundColor: const Color(0xFF8EEFFF),
                              selectedForegroundColor: Colors.white,
                              selectedBackgroundColor: const Color(0xFF00C6FF),
                              side: const BorderSide(color: Color(0x5500E5FF)),
                            ),
                          ),
                        ],
                      ),
                      if (_errorText != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0x40251A1A),
                            border: Border.all(color: const Color(0x88FF6B6B)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFFF8A8A),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _errorText!,
                                  style: const TextStyle(
                                    color: Color(0xFFFFD6D6),
                                    height: 1.45,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              if (_errorOffset != null)
                                TextButton(
                                  onPressed: _jumpToError,
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF6BFFDE),
                                  ),
                                  child: const Text('跳到错误'),
                                ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 14),
                      _buildEditorCard(
                        title: '编辑区',
                        hint: '在这里粘贴 JSON 内容...',
                        controller: _editorController,
                        focusNode: _editorFocus,
                        readOnly: _showTreeView,
                        body: _showTreeView ? _buildTreeView() : null,
                        trailing: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _metricChip(
                              label: '总行数',
                              value: _lineCount(editorText).toString(),
                            ),
                            _metricChip(
                              label: '字符数',
                              value: editorText.length.toString(),
                            ),
                            _metricChip(
                              label: '模式',
                              value: _showTreeView ? '折叠' : '文本',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditorCard({
    required String title,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool readOnly,
    required Widget trailing,
    Widget? body,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xCC101A2D),
        border: Border.all(color: const Color(0x5500E5FF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2800E5FF),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF8EEFFF),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(child: trailing),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (body != null)
                body
              else
                _buildEditorWithLineGutter(
                  hint: hint,
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                ),
              _buildStatusBar(controller),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditorWithLineGutter({
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool readOnly,
  }) {
    final lines = _lineCount(controller.text);
    final lineH = _linePixelHeight;
    final contentH = _editorPadTop + lines * lineH + _editorPadBottom;
    final minViewportH =
        _editorPadTop + _minEditorVisualLines * lineH + _editorPadBottom;
    final gutterContentHeight = math.max(contentH, minViewportH);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0E1528),
          border: Border.all(color: const Color(0x5500E5FF)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _gutterWidth,
              child: ColoredBox(
                color: const Color(0xFF152846),
                child: SingleChildScrollView(
                  controller: _gutterScrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: gutterContentHeight),
                    child: Padding(
                      padding: const EdgeInsets.only(top: _editorPadTop),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(
                          lines,
                          (i) => SizedBox(
                            height: lineH,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    height: _editorLineHeight,
                                    color: const Color(0xFF7C9BB8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: gutterContentHeight,
                child: Focus(
                  onKeyEvent: _onEditorKey,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    readOnly: readOnly,
                    scrollController: _editorScrollController,
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    style: const TextStyle(
                      fontSize: _editorFontSize,
                      height: _editorLineHeight,
                      fontFamily: 'monospace',
                      color: Color(0xFFE7F0FF),
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: const TextStyle(color: Color(0xFF6E86B2)),
                      isDense: true,
                      border: InputBorder.none,
                      filled: true,
                      fillColor: const Color(0xFF0E1528),
                      contentPadding: const EdgeInsets.fromLTRB(
                        _editorPadLeftAfterGutter,
                        _editorPadTop,
                        _editorPadRight,
                        _editorPadBottom,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(TextEditingController controller) {
    final text = controller.text;
    final sel = controller.selection;
    final len = text.length;
    var anchor = sel.extentOffset;
    if (anchor < 0 || anchor > len) {
      anchor = len;
    }
    final (line, col) = _lineColFromOffset(text, anchor);
    final selLen = (sel.isValid && !sel.isCollapsed)
        ? (sel.end - sel.start).abs()
        : 0;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1328),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x5500E5FF)),
      ),
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 12,
          color: Color(0xFF9EC5E8),
          height: 1.3,
        ),
        child: Wrap(
          spacing: 16,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('行 $line，列 $col'),
            Text('选区 $selLen 字符'),
            Text('共 ${_lineCount(text)} 行 · ${text.length} 字符'),
            Text('缩进 $_indentSize'),
            Text(_showTreeView ? '折叠视图' : '文本视图'),
          ],
        ),
      ),
    );
  }

  bool _isLineInsideCollapsedFold(int line) {
    for (final r in _foldRegions) {
      if (!r.expanded && line > r.startLine && line < r.endLine) {
        return true;
      }
    }
    return false;
  }

  _JsonFoldRegion? _collapsedRegionStartingAt(int line) {
    for (final r in _foldRegions) {
      if (!r.expanded && r.startLine == line && r.endLine > r.startLine) {
        return r;
      }
    }
    return null;
  }

  _JsonFoldRegion? _foldHeadRegionAt(int line) {
    for (final r in _foldRegions) {
      if (r.startLine == line && r.endLine > r.startLine) {
        return r;
      }
    }
    return null;
  }

  List<_VisibleFoldRow> _computeVisibleFoldRows() {
    final lines = _foldPhysicalLines;
    final out = <_VisibleFoldRow>[];
    var i = 0;
    while (i < lines.length) {
      if (_isLineInsideCollapsedFold(i)) {
        i++;
        continue;
      }
      final collapsed = _collapsedRegionStartingAt(i);
      if (collapsed != null) {
        final summary = '${lines[i]} … ${lines[collapsed.endLine].trimRight()}';
        out.add(
          _VisibleFoldRow(
            displayLineNumber: i + 1,
            text: summary,
            region: collapsed,
            isCollapsedSummary: true,
          ),
        );
        i = collapsed.endLine + 1;
        continue;
      }
      final head = _foldHeadRegionAt(i);
      out.add(
        _VisibleFoldRow(
          displayLineNumber: i + 1,
          text: lines[i],
          region: head,
          isCollapsedSummary: false,
        ),
      );
      i++;
    }
    return out;
  }

  void _emitFoldDocument() {
    final v = _parsedJson;
    if (v == null) {
      setState(() {
        _foldPhysicalLines.clear();
        _foldRegions.clear();
      });
      return;
    }

    final lines = <String>[];
    final regions = <_JsonFoldRegion>[];
    final stack = <int>[];

    String ind(int depth) => _indentStr * depth;

    void push() => stack.add(lines.length);

    void pop() {
      if (stack.isEmpty) return;
      final s = stack.removeLast();
      final e = lines.length - 1;
      if (e > s) {
        regions.add(_JsonFoldRegion(startLine: s, endLine: e));
      }
    }

    late void Function(Map<dynamic, dynamic>, int) writeMapEntries;

    void writeListEntries(List<dynamic> list, int depth) {
      for (var i = 0; i < list.length; i++) {
        final comma = i < list.length - 1 ? ',' : '';
        final item = list[i];
        if (item is Map) {
          if (item.isEmpty) {
            lines.add('${ind(depth)}{}$comma');
          } else {
            push();
            lines.add('${ind(depth)}{');
            writeMapEntries(item, depth + 1);
            lines.add('${ind(depth)}}$comma');
            pop();
          }
        } else if (item is List) {
          if (item.isEmpty) {
            lines.add('${ind(depth)}[]$comma');
          } else {
            push();
            lines.add('${ind(depth)}[');
            writeListEntries(item, depth + 1);
            lines.add('${ind(depth)}]$comma');
            pop();
          }
        } else {
          lines.add('${ind(depth)}${jsonEncode(item)}$comma');
        }
      }
    }

    writeMapEntries = (Map<dynamic, dynamic> m, int depth) {
      final entries = m.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final e = entries[i];
        final comma = i < entries.length - 1 ? ',' : '';
        final k = jsonEncode(e.key);
        final val = e.value;
        if (val is Map) {
          final vm = val;
          if (vm.isEmpty) {
            lines.add('${ind(depth)}$k: {}$comma');
          } else {
            push();
            lines.add('${ind(depth)}$k: {');
            writeMapEntries(vm, depth + 1);
            lines.add('${ind(depth)}}$comma');
            pop();
          }
        } else if (val is List) {
          final vl = val;
          if (vl.isEmpty) {
            lines.add('${ind(depth)}$k: []$comma');
          } else {
            push();
            lines.add('${ind(depth)}$k: [');
            writeListEntries(vl, depth + 1);
            lines.add('${ind(depth)}]$comma');
            pop();
          }
        } else {
          lines.add('${ind(depth)}$k: ${jsonEncode(val)}$comma');
        }
      }
    };

    if (v is Map) {
      final m = v;
      if (m.isEmpty) {
        lines.add('{}');
      } else {
        push();
        lines.add('{');
        writeMapEntries(m, 1);
        lines.add('}');
        pop();
      }
    } else if (v is List) {
      final list = v;
      if (list.isEmpty) {
        lines.add('[]');
      } else {
        push();
        lines.add('[');
        writeListEntries(list, 1);
        lines.add(']');
        pop();
      }
    } else {
      lines.add(jsonEncode(v));
    }

    setState(() {
      _foldPhysicalLines
        ..clear()
        ..addAll(lines);
      _foldRegions
        ..clear()
        ..addAll(regions);
      for (final r in _foldRegions) {
        r.expanded = _expandAll;
      }
    });
  }

  static final RegExp _jsonKeyColon = RegExp(r'"(?:\\.|[^"\\])*"\s*:');

  List<InlineSpan> _highlightJsonLine(String line) {
    const base = TextStyle(fontFamily: 'monospace', fontSize: 13.5, height: 1.45);
    TextStyle c(Color col) => base.copyWith(color: col);
    const def = Color(0xFFD4D4D4);
    const keyC = Color(0xFF9CDCFE);

    final spans = <InlineSpan>[];
    var at = 0;
    for (final m in _jsonKeyColon.allMatches(line)) {
      if (m.start > at) {
        spans.addAll(_highlightJsonValues(line.substring(at, m.start)));
      }
      spans.add(TextSpan(text: m.group(0), style: c(keyC)));
      at = m.end;
    }
    if (at < line.length) {
      spans.addAll(_highlightJsonValues(line.substring(at)));
    }
    if (spans.isEmpty) {
      return [TextSpan(text: line, style: c(def))];
    }
    return spans;
  }

  List<InlineSpan> _highlightJsonValues(String s) {
    const base = TextStyle(fontFamily: 'monospace', fontSize: 13.5, height: 1.45);
    TextStyle c(Color col) => base.copyWith(color: col);
    const def = Color(0xFFD4D4D4);
    const strC = Color(0xFFCE9178);
    const numC = Color(0xFFB5CEA8);
    const kwC = Color(0xFF569CD6);

    final spans = <InlineSpan>[];
    var i = 0;
    bool isDigit(String x) {
      if (x.isEmpty) return false;
      final u = x.codeUnitAt(0);
      return u >= 48 && u <= 57;
    }

    while (i < s.length) {
      final ch = s[i];
      if (ch == ' ' || ch == '\t') {
        var j = i + 1;
        while (j < s.length && (s[j] == ' ' || s[j] == '\t')) {
          j++;
        }
        spans.add(TextSpan(text: s.substring(i, j), style: c(def)));
        i = j;
        continue;
      }
      if (ch == '"') {
        var j = i + 1;
        while (j < s.length) {
          if (s[j] == '\\' && j + 1 < s.length) {
            j += 2;
            continue;
          }
          if (s[j] == '"') {
            j++;
            break;
          }
          j++;
        }
        spans.add(TextSpan(text: s.substring(i, j), style: c(strC)));
        i = j;
        continue;
      }
      if (ch == '-' || isDigit(ch)) {
        var j = i + 1;
        while (j < s.length) {
          final x = s[j];
          if (isDigit(x) || x == '.' || x == 'e' || x == 'E' || x == '+' || x == '-') {
            j++;
            continue;
          }
          break;
        }
        spans.add(TextSpan(text: s.substring(i, j), style: c(numC)));
        i = j;
        continue;
      }
      if (s.startsWith('true', i) ||
          s.startsWith('false', i) ||
          s.startsWith('null', i)) {
        final kw =
            s.startsWith('true', i)
                ? 'true'
                : s.startsWith('false', i)
                ? 'false'
                : 'null';
        spans.add(TextSpan(text: kw, style: c(kwC)));
        i += kw.length;
        continue;
      }
      spans.add(TextSpan(text: ch, style: c(def)));
      i++;
    }
    return spans;
  }

  Widget _buildFoldRow(_VisibleFoldRow row) {
    final region = row.region;
    final showChevron = region != null && region.endLine > region.startLine;
    final expanded = region?.expanded ?? true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              row.isCollapsedSummary
                  ? const Color(0xFF252526)
                  : Colors.transparent,
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child:
                      showChevron
                          ? IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 22,
                              minHeight: 22,
                            ),
                            icon: Icon(
                              expanded ? Icons.expand_more : Icons.chevron_right,
                              size: 18,
                              color: const Color(0xFFC5C5C5),
                            ),
                            onPressed: () {
                              final r = row.region!;
                              setState(() {
                                r.expanded = !r.expanded;
                              });
                            },
                          )
                          : const SizedBox.shrink(),
                ),
                Expanded(
                  child: Text(
                    '${row.displayLineNumber}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      height: 1.45,
                      color: Color(0xFF858585),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SelectableText.rich(
              TextSpan(children: _highlightJsonLine(row.text)),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildTreeView() {
    if (_parsedJson == null) {
    return Container(
      constraints: const BoxConstraints(minHeight: 260),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF152846),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x5500E5FF)),
      ),
      child: const Text(
        '请先输入合法 JSON，再切换折叠模式',
        style: TextStyle(color: Color(0xFF7C91B5), fontSize: 14),
      ),
    );
    }

    if (_foldPhysicalLines.isEmpty) {
      return const SizedBox.shrink();
    }

    final rows = _computeVisibleFoldRows();
    final h = math.min(520.0, MediaQuery.sizeOf(context).height * 0.5);

    return Container(
      constraints: BoxConstraints(minHeight: 260, maxHeight: h),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x6600E5FF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2200E5FF),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        itemCount: rows.length,
        itemBuilder: (context, index) => _buildFoldRow(rows[index]),
      ),
    );
  }

  Widget _metricChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xAA0A1328),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x5500E5FF)),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF8EEFFF),
        ),
      ),
    );
  }
}
