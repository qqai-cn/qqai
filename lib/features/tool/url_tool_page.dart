import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qqai/config/theme/app_typography.dart';

class UrlToolPage extends StatefulWidget {
  const UrlToolPage({super.key});

  @override
  State<UrlToolPage> createState() => _UrlToolPageState();
}

class _UrlToolPageState extends State<UrlToolPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B1B),
      appBar: AppBar(
        title: const Text('URL 编码 / 解码'),
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
      body: Column(
        children: [
          Expanded(
            child: Container(
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
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AnimatedBuilder(
                                animation: _scanController,
                                builder: (context, child) {
                                  final t = _scanController.value;
                                  final y = -0.35 + 1.7 * t;
                                  return Align(
                                    alignment: Alignment(0, y),
                                    child: Container(
                                      height: 80,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0x0000E5FF),
                                            Color(0x1800E5FF),
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
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: const Color(0xCC101A2D),
                              border: Border.all(
                                color: const Color(0x5500E5FF),
                                width: 1.2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x3000E5FF),
                                  blurRadius: 24,
                                  spreadRadius: 1,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'URI Codec Matrix',
                                  style: context.typo.heroTitle.copyWith(
                                    color: Color(0xFF8EEFFF),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '粘贴文本，一键 UrlEncode / UrlDecode',
                                  style: context.typo.caption.copyWith(
                                    color: Color(0xFF7C91B5),
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    maxLines: null,
                                    expands: true,
                                    textAlignVertical: TextAlignVertical.top,
                                    style: context.typo.mono.copyWith(color: const Color(0xFFE7F0FF), fontSize: 15, height: 1.45),
                                    decoration: InputDecoration(
                                      alignLabelWithHint: true,
                                      hintText: '转换的内容粘贴在这里',
                                      hintStyle: context.typo.inputHint.copyWith(color: const Color(0xFF6E86B2)),
                                      filled: true,
                                      fillColor: const Color(0xAA0A1328),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0x5500E5FF),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0x5500E5FF),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF00E5FF),
                                          width: 1.4,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(14),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  alignment: WrapAlignment.end,
                                  children: [
                                    FilledButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _controller.text =
                                              Uri.encodeFull(_controller.text);
                                        });
                                      },
                                      icon: const Icon(Icons.lock_outline),
                                      label: const Text('UrlEncode'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFF00C6FF),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                    FilledButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _controller.text =
                                              Uri.decodeFull(_controller.text);
                                        });
                                      },
                                      icon: const Icon(Icons.lock_open_outlined),
                                      label: const Text('UrlDecode'),
                                      style: FilledButton.styleFrom(
                                        backgroundColor: const Color(0xFF00C6FF),
                                        foregroundColor: Colors.white,
                                      ),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        setState(_controller.clear);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('清空'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF8EEFFF),
                                        side: const BorderSide(
                                          color: Color(0x5500E5FF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
