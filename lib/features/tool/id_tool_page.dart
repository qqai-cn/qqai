import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qqai/config/theme/app_typography.dart';
import 'package:qqai/constant/api_constant.dart';

import '../data/models/idCard_bean_entity.dart';

class IdToolPage extends StatefulWidget {
  const IdToolPage({super.key});

  @override
  State<IdToolPage> createState() => _IdToolPage();
}

class _IdToolPage extends State<IdToolPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  bool _successPulse = false;
  late final AnimationController _scanController;

  String id = '';
  String address = '';
  String birthday = '';
  String shengxiao = '';
  String age = '';
  String ababdan = '';

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _scanController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _queryIdCard() async {
    final text = _controller.text.trim();
    if (text.isEmpty || text.length != 18) {
      _showSnack('请输入正确的身份证号码!');
      return;
    }

    try {
      setState(() {
        _loading = true;
      });

      final dio = Dio();
      final response = await dio.post(ApiConstant.API_ID, data: {'id': text});
      final idBeanEntity = IdCardBeanEntity.fromJson(response.data);
      if (idBeanEntity.data == null) {
        _showSnack('查询失败!');
        return;
      }

      final idBeanData = idBeanEntity.data!;
      final ageTmp = idBeanData.age ?? 0;
      final sex = idBeanData.sex == 1 ? '男' : '女';
      final abandoned = idBeanData.abandoned ?? false;

      setState(() {
        id = text;
        address = idBeanData.address ?? '';
        birthday = idBeanData.birthday ?? '';
        shengxiao = idBeanData.chineseZodiac ?? '';
        age = '$sex $ageTmp周岁';
        ababdan = abandoned ? '是' : '否';
        _successPulse = true;
      });
      Timer(const Duration(milliseconds: 650), () {
        if (!mounted) return;
        setState(() {
          _successPulse = false;
        });
      });
    } catch (_) {
      _showSnack('查询失败，请稍后再试');
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0x1A00E5FF), Color(0x1400FF95)],
        ),
        border: Border.all(color: const Color(0x3300E5FF)),
      ),
      child: Row(
        children: [
          Container(
            width: 108,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0x3300E5FF)),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: context.typo.label.copyWith(
                color: const Color(0xFF8CA8D8),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: SelectableText(
                value.isEmpty ? '--' : value,
                style: context.typo.mono.copyWith(
                  color: const Color(0xFFE7F0FF),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060C1C),
      appBar: AppBar(
        title: const Text('身份证号码'),
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
              Color(0xFF060C1C),
              Color(0xFF0A1328),
              Color(0xFF0D1D38),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: SingleChildScrollView(
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
                          final y = -0.2 + 1.4 * t;
                          return Align(
                            alignment: Alignment(0, y * 2 - 1),
                            child: Container(
                              height: 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    const Color(0x0000E5FF),
                                    const Color(0x2200E5FF),
                                    const Color(0x0000E5FF),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: const Color(0xCC101A2D),
                      border: Border.all(
                        color: _successPulse
                            ? const Color(0xFF6BFFDE)
                            : const Color(0x5000E5FF),
                        width: _successPulse ? 1.6 : 1.2,
                      ),
                      boxShadow: [
                        const BoxShadow(
                          color: Color(0x3000E5FF),
                          blurRadius: 24,
                          spreadRadius: 1,
                          offset: Offset(0, 8),
                        ),
                        if (_successPulse)
                          const BoxShadow(
                            color: Color(0x556BFFDE),
                            blurRadius: 32,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Identity Intelligence Scan',
                          style: context.typo.heroTitle.copyWith(
                            color: const Color(0xFF8EEFFF),
                            fontSize: 22,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '输入身份证号码，解析基础身份信息',
                          style: context.typo.caption.copyWith(
                            color: const Color(0xFF7C91B5),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: context.typo.mono.copyWith(
                                  color: const Color(0xFFE7F0FF),
                                  fontSize: 16,
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 18,
                                decoration: InputDecoration(
                                  counterStyle: context.typo.caption.copyWith(
                                    color: const Color(0xFF7C91B5),
                                  ),
                                  labelText: '请输入身份证号码',
                                  labelStyle: context.typo.label.copyWith(
                                    color: const Color(0xFF8CA8D8),
                                  ),
                                  prefixIcon:
                                      const Icon(Icons.badge_outlined, color: Color(0xFF53E5FF)),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.close, color: Color(0xFF8CA8D8)),
                                    onPressed: _controller.clear,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xAA0A1328),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        const BorderSide(color: Color(0x5500E5FF)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        const BorderSide(color: Color(0xFF00E5FF), width: 1.4),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: _loading ? null : _queryIdCard,
                              icon: _loading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.verified_user_outlined),
                              label: Text(_loading ? '校验中' : '验证'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF00C6FF),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 18,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _infoRow('证件号码', id),
                        _infoRow('正常使用', ababdan),
                        _infoRow('发证地区', address),
                        _infoRow('出生日期', birthday),
                        _infoRow('生肖', shengxiao),
                        _infoRow('性别年龄', age),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
