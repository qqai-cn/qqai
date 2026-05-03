import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/util/web_blob_helpers.dart';

/// 在线图片格式转换
class ImageFormatConvertPage extends StatefulWidget {
  const ImageFormatConvertPage({super.key});

  @override
  State<ImageFormatConvertPage> createState() => _ImageFormatConvertPageState();
}

class _ImageFormatConvertPageState extends State<ImageFormatConvertPage> {
  static const _teal = Color(0xFFC62828);
  static const _tealLight = Color(0xFFEF5350);

  final ImagePicker _picker = ImagePicker();

  Uint8List? _rawBytes;
  String? _pickedName;
  img.Image? _decoded;
  String? _targetExt;
  Uint8List? _convertedBytes;
  String? _convertedFileName;
  bool _busy = false;

  String get _displayName {
    if (_pickedName != null && _pickedName!.isNotEmpty) return _pickedName!;
    if (_rawBytes != null) return '已选择图片（无文件名）';
    return "先 '上传图片'";
  }

  String _sizeKbText() {
    if (_rawBytes == null) return '上传后显示';
    return (_rawBytes!.length / 1024).toStringAsFixed(2);
  }

  String _typeText() {
    if (_pickedName == null) return '上传后显示';
    final n = _pickedName!.toLowerCase();
    final dot = n.lastIndexOf('.');
    if (dot < 0) return '未知';
    return n.substring(dot);
  }

  String _pixelText() {
    if (_decoded == null) return '上传后显示';
    return '${_decoded!.width} × ${_decoded!.height} px';
  }

  String _colorSpaceText() {
    if (_decoded == null) return '上传后显示';
    final d = _decoded!;
    final pal = d.hasPalette ? '，调色板' : '';
    return '${d.format.name}$pal，${d.numChannels} 通道';
  }

  String _framesText() {
    if (_decoded == null) return '上传后显示';
    final name = (_pickedName ?? '').toLowerCase();
    if (!name.endsWith('.gif')) return '—（仅 GIF）';
    return '${_decoded!.numFrames}';
  }

  bool _isPlaceholderValue(String s) {
    return s == '上传后显示' || s == '—（仅 GIF）';
  }

  Future<void> _pickImage() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x == null) return;
    final bytes = await x.readAsBytes();
    final decoded = img.decodeImage(bytes);
    setState(() {
      _rawBytes = bytes;
      _pickedName = x.name;
      _decoded = decoded;
      _convertedBytes = null;
      _convertedFileName = null;
    });
    if (decoded == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('无法解析该图片，请换一张试试'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<Uint8List?> _encodeWebp(img.Image image) async {
    return encodeWebpViaBrowserCanvas(image);
  }

  Future<Uint8List?> _encodeTo(img.Image source, String ext) async {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return img.encodeJpg(source, quality: 92);
      case 'png':
        return img.encodePng(source);
      case 'gif':
        return img.encodeGif(
          source,
          singleFrame: !source.hasAnimation,
        );
      case 'bmp':
        return img.encodeBmp(source);
      case 'webp':
        return _encodeWebp(source);
      default:
        return null;
    }
  }

  img.Image _imageForStaticTarget(img.Image decoded) {
    if (!decoded.hasAnimation) return decoded;
    return decoded.getFrame(0);
  }

  Future<void> _convert() async {
    if (_rawBytes == null || _decoded == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('请先上传图片'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    if (_targetExt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('请选择要转换的格式'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final img.Image toEncode =
          _targetExt == 'gif' ? _decoded! : _imageForStaticTarget(_decoded!);
      final out = await _encodeTo(toEncode, _targetExt!);
      if (!mounted) return;
      if (out == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('转换失败'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      final base = _baseNameWithoutExt(_pickedName ?? 'image');
      final extOut = switch (_targetExt!) {
        'jpg' => 'jpg',
        'jpeg' => 'jpeg',
        'gif' => 'gif',
        'png' => 'png',
        'bmp' => 'bmp',
        'webp' => 'webp',
        _ => _targetExt!,
      };
      final name = '$base.$extOut';
      setState(() {
        _convertedBytes = out;
        _convertedFileName = name;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('图片转换成功'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('转换出错: $e'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _baseNameWithoutExt(String name) {
    final dot = name.lastIndexOf('.');
    if (dot <= 0) return name;
    return name.substring(0, dot);
  }

  void _downloadConverted() {
    final bytes = _convertedBytes;
    final name = _convertedFileName;
    if (bytes == null || name == null) return;
    downloadUint8ListAsFile(bytes, name);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text('图片格式转换'),
        centerTitle: true,
        // elevation: 0,
        // flexibleSpace: Container(
        //   decoration: const BoxDecoration(
        //     gradient: LinearGradient(
        //       colors: [_teal, _tealLight],
        //       begin: Alignment.centerLeft,
        //       end: Alignment.centerRight,
        //     ),
        //   ),
        // ),
        // backgroundColor: Colors.transparent,
        // foregroundColor: Colors.white,
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _teal.withValues(alpha: 0.08),
              cs.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final pad = constraints.maxWidth < 400 ? 16.0 : 24.0;
              final maxW = constraints.maxWidth < 560
                  ? constraints.maxWidth - pad * 2
                  : 640.0;
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(pad, pad, pad, pad + 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxW.clamp(0, 640)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _supportedFormatsBanner(theme),
                        const SizedBox(height: 20),
                        _mainFormCard(theme, constraints.maxWidth),
                        const SizedBox(height: 20),
                        _stepsCard(theme),
                        const SizedBox(height: 20),
                        _propertyCard(theme),
                        if (_convertedBytes != null) ...[
                          const SizedBox(height: 20),
                          _resultCard(theme),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _supportedFormatsBanner(ThemeData theme) {
    const formats = ['.jpg', '.jpeg', '.gif', '.png', '.bmp', '.webp'];
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.65),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _teal.withValues(alpha: 0.15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.image_outlined, size: 20, color: _teal.withValues(alpha: 0.9)),
                const SizedBox(width: 8),
                Text(
                  '支持格式',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '在线图片格式转换支持以下格式互转：',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: formats
                  .map(
                    (f) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _teal.withValues(alpha: 0.35)),
                        boxShadow: [
                          BoxShadow(
                            color: _teal.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        f,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _teal,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainFormCard(ThemeData theme, double screenWidth) {
    final narrow = screenWidth < 520;

    final uploadBtn = FilledButton.icon(
      onPressed: _busy ? null : _pickImage,
      style: FilledButton.styleFrom(
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.cloud_upload_outlined, size: 22),
      label: const Text('上传图片'),
    );

    final formatField = DropdownButtonFormField<String>(
      value: _targetExt,
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface,
        hintText: '选择要转换的格式',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _tealLight, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      borderRadius: BorderRadius.circular(12),
      items: [
        DropdownMenuItem(value: 'jpg', child: Text('JPG (.jpg)')),
        DropdownMenuItem(value: 'jpeg', child: Text('JPEG (.jpeg)')),
        DropdownMenuItem(value: 'gif', child: Text('GIF (.gif)')),
        DropdownMenuItem(value: 'png', child: Text('PNG (.png)')),
        DropdownMenuItem(value: 'bmp', child: Text('BMP (.bmp)')),
        DropdownMenuItem(value: 'webp', child: Text('WebP (.webp)')),
      ],
      onChanged: _busy ? null : (v) => setState(() => _targetExt = v),
    );

    final filePreview = InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        labelText: '待转图片',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.35)),
        ),
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
      ),
      child: Text(
        _displayName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: _rawBytes == null
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.onSurface,
        ),
      ),
    );

    final convertBtn = SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: _busy ? null : _convert,
        style: FilledButton.styleFrom(
          backgroundColor: _teal,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _busy
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text('立即转换', style: context.typo.button.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );

    return Card(
      elevation: 2,
      shadowColor: _teal.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _teal.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.transform, color: _teal.withValues(alpha: 0.95), size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '转换操作',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '转换图片',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            if (narrow) ...[
              uploadBtn,
              const SizedBox(height: 12),
              formatField,
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  uploadBtn,
                  const SizedBox(width: 16),
                  Expanded(child: formatField),
                ],
              ),
            const SizedBox(height: 18),
            filePreview,
            const SizedBox(height: 18),
            convertBtn,
          ],
        ),
      ),
    );
  }

  Widget _stepsCard(ThemeData theme) {
    const steps = [
      '上传您需要转换的图片',
      '选择您要转换的图片格式',
      '点击「立即转换」，稍等片刻后会提示转换成功',
    ];
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_list_numbered, size: 22, color: _teal.withValues(alpha: 0.85)),
                const SizedBox(width: 8),
                Text(
                  '使用步骤',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...List.generate(steps.length, (i) {
              return Padding(
                padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 10 : 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [_teal, _tealLight]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${i + 1}',
                        style: context.typo.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [_teal, _tealLight]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '4',
                    style: context.typo.label.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.45,
                        color: theme.colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(text: '点击图片预览，或使用'),
                        TextSpan(
                          text: '「下载图片」',
                          style: context.typo.bodyStrong.copyWith(color: const Color(0xFFE53935), fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: '保存到本地'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _propertyCard(ThemeData theme) {
    final headerStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface,
    );
    final cellStyle = theme.textTheme.bodyMedium?.copyWith(height: 1.35);
    final muted = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    Widget headerCell(String t) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        color: _teal.withValues(alpha: 0.1),
        alignment: Alignment.centerLeft,
        child: Text(t, style: headerStyle),
      );
    }

    Widget bodyCell(String t, {bool emphasize = false}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            t,
            style: emphasize
                ? cellStyle?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _teal,
                  )
                : cellStyle,
          ),
        ),
      );
    }

    Widget descCell(String t) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(t, style: cellStyle?.copyWith(color: muted, fontSize: 13)),
        ),
      );
    }

    final rows = [
      ('图片大小', _sizeKbText(), '文件大小（KB）'),
      ('图片类型', _typeText(), '扩展名，如 .jpg、.png'),
      ('图片像素', _pixelText(), '宽 × 高（px）'),
      ('彩色空间', _colorSpaceText(), '像素格式与通道'),
      ('图片帧数', _framesText(), 'GIF 动图帧数'),
    ];

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 22, color: _teal.withValues(alpha: 0.85)),
                const SizedBox(width: 8),
                Text(
                  '图片属性',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(1.05),
              1: FlexColumnWidth(1.15),
              2: FlexColumnWidth(1.4),
            },
            border: TableBorder(
              horizontalInside: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
              top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.25)),
              bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.25)),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(color: _teal.withValues(alpha: 0.06)),
                children: [
                  headerCell('属性'),
                  headerCell('值'),
                  headerCell('说明'),
                ],
              ),
              ...rows.map((r) {
                return TableRow(
                  children: [
                    bodyCell(r.$1),
                    bodyCell(
                      r.$2,
                      emphasize: !_isPlaceholderValue(r.$2) && r.$2 != '未知',
                    ),
                    descCell(r.$3),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _resultCard(ThemeData theme) {
    return Card(
      elevation: 2,
      shadowColor: _teal.withValues(alpha: 0.18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle_outline, color: _tealLight, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '转换结果',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (_convertedFileName != null)
                  Flexible(
                    child: Text(
                      _convertedFileName!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '点击下方图片或按钮即可下载',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 14),
            Material(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _downloadConverted,
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.memory(
                      _convertedBytes!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _downloadConverted,
              style: FilledButton.styleFrom(
                backgroundColor: _teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.download_outlined),
              label: Text('下载图片', style: context.typo.button.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
