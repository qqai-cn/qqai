import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';
import 'package:qqai/util/web_blob_helpers.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeToolPage extends StatefulWidget {
  const QrCodeToolPage({super.key});

  @override
  State<QrCodeToolPage> createState() => _QrCodeToolPageState();
}

class _QrCodeToolPageState extends State<QrCodeToolPage> {
  static const int _maxLen = 300;

  final TextEditingController _controller = TextEditingController();
  String _qrData = '';
  int _activeStyle = 1; // 0: 动态(预留), 1: 直角, 2: 圆角

  String get _effectiveData => _qrData.isEmpty ? 'https://example.com' : _qrData;

  QrEyeStyle get _eyeStyle => QrEyeStyle(
    eyeShape: _activeStyle == 2 ? QrEyeShape.circle : QrEyeShape.square,
    color: _activeStyle == 0 ? const Color(0xFF3F7EDB) : Colors.black,
  );

  QrDataModuleStyle get _moduleStyle => QrDataModuleStyle(
    dataModuleShape: _activeStyle == 1 ? QrDataModuleShape.square : QrDataModuleShape.circle,
    color: _activeStyle == 0 ? const Color(0xFF3F7EDB) : Colors.black,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generate() {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入要生成二维码的内容')),
      );
      return;
    }
    setState(() {
      _qrData = text;
    });
  }

  Future<void> _download() async {
    final painter = QrPainter(
      data: _effectiveData,
      version: QrVersions.auto,
      eyeStyle: _eyeStyle,
      dataModuleStyle: _moduleStyle,
    );
    final byteData = await painter.toImageData(1024, format: ui.ImageByteFormat.png);
    if (byteData == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('二维码导出失败')));
      }
      return;
    }
    final bytes = Uint8List.view(byteData.buffer);
    final ts = DateTime.now().millisecondsSinceEpoch;
    downloadUint8ListAsFile(
      bytes,
      'qrcode_$ts.png',
      mimeType: 'image/png',
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = GoodsPageStyle.border(context);

    return Scaffold(
      backgroundColor: GoodsPageStyle.pageBg(context),
      appBar: AppBar(
        title: const Text('二维码生成'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: GoodsPageStyle.cardBg(context),
            border: Border.all(color: borderColor),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 900;
              final left = _buildLeftPanel();
              final right = _buildRightPanel();
              if (isNarrow) {
                return Column(
                  children: [
                    left,
                    Divider(height: 1, color: borderColor),
                    right,
                  ],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: left),
                  Container(width: 1, height: 620, color: borderColor),
                  SizedBox(width: 460, child: right),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLeftPanel() {
    final count = _controller.text.characters.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '二维码生成',
            style: context.typo.sectionTitle.copyWith(
              fontSize: 32 / 2,
              fontWeight: FontWeight.w600,
              color: GoodsPageStyle.text(context),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLength: _maxLen,
            minLines: 4,
            maxLines: 4,
            style: TextStyle(color: AppActionColors.strong(context)),
            decoration: InputDecoration(
              hintText: '请输入内容，支持文本、网址和电子邮箱，限300个字。',
              counterText: '',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: GoodsPageStyle.border(context)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: GoodsPageStyle.border(context)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3578E5)),
              ),
              filled: true,
              fillColor: GoodsPageStyle.imageBg(context),
            ),
            onChanged: (_) => setState(() {}),
          ),
          Text(
            '已输入数字：$count/$_maxLen',
            style: context.typo.caption.copyWith(
              color: GoodsPageStyle.sub(context),
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _generate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F7EDB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
              ),
              icon: const Icon(Icons.settings, size: 16),
              label: const Text('生成二维码'),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '1.输入要生成二维码的内容，可以是数字、字母、链接等内容。\n'
            '2.点击“生成二维码”，右侧二维码会立马生成。\n'
            '3.右侧菜单可以美化二维码，包括样式切换等。\n'
            '4.对自己理想的二维码点击“保存二维码”即可下载二维码到您本地。',
            style: context.typo.body.copyWith(
              color: GoodsPageStyle.sub(context),
              height: 1.6,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel() {
    final radius = switch (_activeStyle) {
      2 => 20.0,
      _ => 0.0,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Container(
              width: 300,
              height: 300,
              color: Colors.white,
              alignment: Alignment.center,
              child: QrImageView(
                data: _effectiveData,
                size: 280,
                backgroundColor: Colors.white,
                version: QrVersions.auto,
                eyeStyle: _eyeStyle,
                dataModuleStyle: _moduleStyle,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: GoodsPageStyle.border(context)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _styleTab('动态', 0),
              _styleTab('直角', 1),
              _styleTab('圆角', 2),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: GoodsPageStyle.border(context)),
              color: GoodsPageStyle.imageBg(context),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '颜色设置  嵌入Logo  嵌入文字  图案样式  其它设置',
                  style: context.typo.caption.copyWith(
                    color: GoodsPageStyle.sub(context),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '前景色  黑色       背景色  白色',
                  style: context.typo.caption.copyWith(
                    fontSize: 13,
                    color: GoodsPageStyle.text(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '渐变色  关闭       渐变方式  反斜线',
                  style: context.typo.caption.copyWith(
                    fontSize: 13,
                    color: GoodsPageStyle.text(context),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _controller.clear();
                    _qrData = '';
                    _activeStyle = 1;
                  });
                },
                child: Text(
                  '清除设置',
                  style: context.typo.bodyStrong.copyWith(
                    color: const Color(0xFFE85A4F),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _download,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F7EDB),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.download, size: 16),
                label: const Text('保存二维码'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _styleTab(String text, int index) {
    final active = _activeStyle == index;
    return InkWell(
      onTap: () => setState(() => _activeStyle = index),
      child: Text(
        text,
        style: context.typo.body.copyWith(
          color: active
              ? const Color(0xFF3F7EDB)
              : GoodsPageStyle.sub(context),
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          decoration: active ? TextDecoration.underline : TextDecoration.none,
          decorationColor: const Color(0xFF3F7EDB),
        ),
      ),
    );
  }
}
