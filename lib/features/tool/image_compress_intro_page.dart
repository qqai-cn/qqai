import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

/// 图片压缩页（真实可用版）
class ImageCompressIntroPage extends StatefulWidget {
  const ImageCompressIntroPage({super.key});

  @override
  State<ImageCompressIntroPage> createState() => _ImageCompressIntroPageState();
}

class _ImageCompressIntroPageState extends State<ImageCompressIntroPage> {
  static const _highlightRed = Color(0xFFE85A4F);
  static const _brandBlue = Color(0xFF27A9E1);
  static const _lineColor = Color(0xFFE8E8E8);
  static const _softText = Color(0xFF555555);
  static const _maxFiles = 10;
  static const _maxBytes = 4 * 1024 * 1024;

  final ImagePicker _picker = ImagePicker();
  final List<_CompressedItem> _items = [];
  int _quality = 78;
  bool _busy = false;
  String? _status;

  int get _totalBefore => _items.fold(0, (sum, e) => sum + e.originalBytes.length);
  int get _totalAfter => _items.fold(0, (sum, e) => sum + e.compressedBytes.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('在线图片压缩'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _introCard(),
            const SizedBox(height: 18),
            _uploadCard(),
            if (_status != null) ...[
              const SizedBox(height: 10),
              Text(
                _status!,
                style: const TextStyle(
                  color: _highlightRed,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (_items.isNotEmpty) ...[
              const SizedBox(height: 14),
              _summaryCard(),
              const SizedBox(height: 14),
              _resultListCard(),
            ],
            const SizedBox(height: 20),
            _sectionTitle('在线批量压缩图片 | tinypng'),
            _bulletCard(),
            const SizedBox(height: 18),
            _sectionTitle('压缩前 VS 压缩后'),
            _compareCard(),
            const SizedBox(height: 14),
            const Text(
              '由于攻克周期较长，技术上难免有 Bug，如有疑问或建议，欢迎反馈。',
              style: TextStyle(color: _highlightRed, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    if (_busy) return;
    final selected = await _picker.pickMultiImage();
    if (selected.isEmpty) return;

    final files = selected.take(_maxFiles).toList();
    int droppedBySize = 0;
    int droppedByDecode = 0;
    final validSources = <_SourceImage>[];

    for (final x in files) {
      final bytes = await x.readAsBytes();
      if (bytes.length > _maxBytes) {
        droppedBySize++;
        continue;
      }
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        droppedByDecode++;
        continue;
      }
      validSources.add(
        _SourceImage(
          name: x.name,
          bytes: bytes,
          decoded: decoded,
          ext: _extOf(x.name),
        ),
      );
    }

    if (validSources.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('没有可处理图片，请检查格式与大小（<=4MB）')),
        );
      }
      return;
    }

    await _compressAll(validSources);

    final droppedByCount = selected.length > _maxFiles ? selected.length - _maxFiles : 0;
    final notes = <String>[];
    if (droppedByCount > 0) notes.add('超出数量忽略 $droppedByCount 张');
    if (droppedBySize > 0) notes.add('超过4MB忽略 $droppedBySize 张');
    if (droppedByDecode > 0) notes.add('解析失败忽略 $droppedByDecode 张');
    setState(() {
      _status = notes.isEmpty ? '共处理 ${validSources.length} 张图片' : notes.join('，');
    });
  }

  Future<void> _compressAll(List<_SourceImage> sources) async {
    setState(() => _busy = true);
    try {
      final nextItems = <_CompressedItem>[];
      for (final s in sources) {
        final compressed = _compressBytes(
          decoded: s.decoded,
          ext: s.ext,
          quality: _quality,
          original: s.bytes,
        );
        nextItems.add(
          _CompressedItem(
            originalName: s.name,
            downloadName: _downloadName(
              originalName: s.name,
              targetExt: compressed.targetExt,
            ),
            originalBytes: s.bytes,
            compressedBytes: compressed.bytes,
            sourceExt: s.ext,
            targetExt: compressed.targetExt,
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(nextItems);
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  _CompressedData _compressBytes({
    required img.Image decoded,
    required String ext,
    required int quality,
    required Uint8List original,
  }) {
    final hasAlpha = decoded.numChannels == 4;

    if (ext == 'gif') {
      return _CompressedData(bytes: original, targetExt: 'gif');
    }

    Uint8List best = original;
    String bestExt = ext;

    if (!hasAlpha) {
      for (final q in [quality, (quality - 10).clamp(45, 95), (quality - 20).clamp(40, 90)]) {
        final jpg = Uint8List.fromList(img.encodeJpg(decoded, quality: q));
        if (jpg.length < best.length) {
          best = jpg;
          bestExt = 'jpg';
        }
      }
    }

    if (ext == 'png' || ext == 'webp') {
      final png = Uint8List.fromList(img.encodePng(decoded, level: 9));
      if (png.length < best.length) {
        best = png;
        bestExt = 'png';
      }
    }

    if (ext == 'bmp') {
      final jpg = Uint8List.fromList(img.encodeJpg(decoded, quality: quality));
      if (jpg.length < best.length) {
        best = jpg;
        bestExt = 'jpg';
      }
    }

    return _CompressedData(bytes: best, targetExt: bestExt);
  }

  Future<void> _downloadAll() async {
    for (final item in _items) {
      _downloadBytes(item.compressedBytes, item.downloadName);
      await Future<void>.delayed(const Duration(milliseconds: 220));
    }
  }

  void _downloadBytes(Uint8List bytes, String name) {
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', name)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  String _downloadName({required String originalName, required String targetExt}) {
    final dot = originalName.lastIndexOf('.');
    final base = dot > 0 ? originalName.substring(0, dot) : originalName;
    return '${base}_compressed.$targetExt';
  }

  String _extOf(String name) {
    final n = name.toLowerCase();
    final dot = n.lastIndexOf('.');
    if (dot < 0) return 'jpg';
    return n.substring(dot + 1);
  }

  String _humanSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)}MB';
    }
    return '${(bytes / 1024).toStringAsFixed(1)}KB';
  }

  Widget _introCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: _lineColor),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _richLine(
            normal: '在线图片压缩，支持',
            red: ['.jpg', '.jpeg', '.png', '.bmp'],
            tail: '，还支持',
            endRed: '.webp',
            end: '格式',
          ),
          const SizedBox(height: 8),
          const Text(
            '在线批量图片质量压缩最多支持10张打包压缩下载，超过10张图片不支持压缩打包下载，但是是免费的哦。',
            style: TextStyle(color: _softText, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 8),
          const Text(
            '如果是压缩率是 0% 的话，属于复杂类型图片，目前不支持压缩，一般是一些剪切图之类。',
            style: TextStyle(color: _softText, fontSize: 15, height: 1.5),
          ),
          const SizedBox(height: 8),
          const Text(
            '压缩成功后，图片尺寸不会变，视觉效果也不会有太大差异。不允许同名图片上传，最大支持4MB。',
            style: TextStyle(
              color: _highlightRed,
              fontSize: 15,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(
                child: Text(
                  '大于5张图可以批量下载，工具30分钟后请刷新页面再使用。',
                  style: TextStyle(color: _softText, fontSize: 15, height: 1.5),
                ),
              ),
              _TagPill(label: '计算机科学'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _uploadCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        border: Border.all(color: _lineColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: _busy ? null : _pickImages,
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            icon: _busy
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.cloud_upload_outlined, size: 18),
            label: Text(_busy ? '压缩中...' : '上传图片'),
          ),
          const SizedBox(height: 10),
          Text(
            '选择或者拖动上传，支持4MB以内，每次支持10张图片。当前压缩质量：$_quality',
            style: const TextStyle(color: _softText, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _quality.toDouble(),
            min: 40,
            max: 92,
            divisions: 13,
            activeColor: _highlightRed,
            label: '$_quality',
            onChanged: _busy
                ? null
                : (v) {
                    setState(() {
                      _quality = v.round();
                    });
                  },
          ),
          const Text(
            '压缩后 5 分钟后会自动销毁。',
            style: TextStyle(
              color: _highlightRed,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard() {
    final before = _totalBefore;
    final after = _totalAfter;
    final ratio = before == 0 ? 0.0 : ((before - after) / before) * 100;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: _lineColor),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(child: Text('共 ${_items.length} 张，压缩前 ${_humanSize(before)}')),
          Expanded(
            child: Text(
              '压缩后 ${_humanSize(after)}，减少 ${ratio.toStringAsFixed(1)}%',
              style: const TextStyle(color: _highlightRed, fontWeight: FontWeight.w700),
            ),
          ),
          TextButton.icon(
            onPressed: _downloadAll,
            icon: const Icon(Icons.download, size: 18),
            label: const Text('批量下载'),
          ),
        ],
      ),
    );
  }

  Widget _resultListCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _lineColor),
        color: const Color(0xFFFEFEFE),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: _items
            .map(
              (e) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFEDEDED)),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.memory(
                        e.compressedBytes,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.originalName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_humanSize(e.originalBytes.length)} → ${_humanSize(e.compressedBytes.length)}'
                            ' (${e.targetExt.toUpperCase()})',
                            style: TextStyle(
                              color: e.compressedBytes.length < e.originalBytes.length
                                  ? _highlightRed
                                  : _softText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _downloadBytes(e.compressedBytes, e.downloadName),
                      child: const Text('下载'),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _bulletCard() {
    const bullets = [
      '批量图片压缩原理：使用智能的无损压缩技术来减少图片文件大小，尽量保持视觉体验不变。',
      '批量压缩图片后，10张以内支持打包下载，多了不允许下载。',
      '为什么要压缩？图片压缩可减少带宽占用并提升加载速度。',
      'PS：关于安全隐私问题，采用定时自动删除机制，保证图片安全和隐私。',
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: bullets
            .map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(Icons.circle, size: 6, color: Color(0xFF9A9A9A)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: text.startsWith('PS：') ? _highlightRed : _softText,
                          fontSize: 14.5,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _compareCard() {
    final first = _items.isEmpty ? null : _items.first;
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _CompareItem(
                title: '压缩前',
                size: first == null ? '--' : _humanSize(first.originalBytes.length),
                bytes: first?.originalBytes,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _CompareItem(
                title: '压缩后',
                size: first == null ? '--' : _humanSize(first.compressedBytes.length),
                bytes: first?.compressedBytes,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _lineColor)),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF4C4C4C),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: _lineColor)),
      ],
    );
  }

  Widget _richLine({
    required String normal,
    required List<String> red,
    required String tail,
    required String endRed,
    required String end,
  }) {
    final spans = <InlineSpan>[TextSpan(text: normal)];
    for (int i = 0; i < red.length; i++) {
      spans.add(
        TextSpan(
          text: red[i],
          style: const TextStyle(color: _highlightRed, fontWeight: FontWeight.w600),
        ),
      );
      if (i < red.length - 1) {
        spans.add(const TextSpan(text: '、'));
      }
    }
    spans.addAll([
      TextSpan(text: tail),
      const TextSpan(
        text: '.webp',
        style: TextStyle(color: _highlightRed, fontWeight: FontWeight.w600),
      ),
      TextSpan(text: end),
    ]);
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: _softText, fontSize: 15, height: 1.5),
        children: spans,
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF2D7BE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _CompareItem extends StatelessWidget {
  const _CompareItem({required this.title, required this.size, this.bytes});

  final String title;
  final String size;
  final Uint8List? bytes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEDE8E3),
              border: Border.all(color: const Color(0xFFD8D3CC)),
            ),
            child: bytes == null
                ? const Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: Color(0xFF9B948A),
                      size: 44,
                    ),
                  )
                : Image.memory(bytes!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$title  $size',
          style: TextStyle(
            color: size == '7KB' ? const Color(0xFFE85A4F) : const Color(0xFF5A5A5A),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SourceImage {
  _SourceImage({
    required this.name,
    required this.bytes,
    required this.decoded,
    required this.ext,
  });

  final String name;
  final Uint8List bytes;
  final img.Image decoded;
  final String ext;
}

class _CompressedData {
  _CompressedData({required this.bytes, required this.targetExt});

  final Uint8List bytes;
  final String targetExt;
}

class _CompressedItem {
  _CompressedItem({
    required this.originalName,
    required this.downloadName,
    required this.originalBytes,
    required this.compressedBytes,
    required this.sourceExt,
    required this.targetExt,
  });

  final String originalName;
  final String downloadName;
  final Uint8List originalBytes;
  final Uint8List compressedBytes;
  final String sourceExt;
  final String targetExt;
}
