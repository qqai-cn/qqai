import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import '../../router/app_routes.dart';
import 'package:qqai/config/theme/app_typography.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _idCardController = TextEditingController();
  bool _isRegisterMode = false;
  bool _isLoading = false;
  double _sliderValue = 0;
  bool _sliderVerified = false;

  static final _mobileRe = RegExp(r'^1\d{10}$');
  static final _idCardRe = RegExp(r'^\d{15}$|^\d{17}[\dXx]$');

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _idCardController.dispose();
    super.dispose();
  }

  void _setAuthMode(bool register) {
    if (_isRegisterMode == register) return;
    setState(() {
      _isRegisterMode = register;
      _sliderValue = 0;
      _sliderVerified = false;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_sliderVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先完成滑块验证')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authNotifier = ref.read(authProvider.notifier);
    try {
      if (_isRegisterMode) {
        await authNotifier.register(
          mobile: _mobileController.text.trim(),
          password: _passwordController.text,
          username: _nicknameController.text.trim(),
          idCard: _idCardController.text.trim(),
        );
      } else {
        await authNotifier.login(
          _mobileController.text.trim(),
          _passwordController.text,
        );
      }

      if (mounted) {
        context.go(Routes.HOME);
      }
    } catch (e) {
      if (!mounted) return;
      final prefix = _isRegisterMode ? '注册失败' : '登录失败';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$prefix: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF141E30),
              Color(0xFF243B55),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                  // Logo / Title（品牌图：imgs/qqai_logo.png）
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00D9F5).withValues(alpha: 0.45),
                              blurRadius: 28,
                              spreadRadius: 2,
                              offset: const Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'imgs/qqai_logo.png',
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 96,
                              height: 96,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFF00F5A0),
                                    Color(0xFF00D9F5),
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFFB71C1C),
                            Color(0xFFE53935),
                            Color(0xFFFF8A80),
                          ],
                        ).createShader(bounds),
                        child: Text(
                          '千千AI',
                          style: context.typo.heroTitle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isRegisterMode ? '创建账号' : '欢迎回来',
                        style: context.typo.sectionTitle.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isRegisterMode
                            ? '注册'
                            : '登录你的智能助手账户',
                        textAlign: TextAlign.center,
                        style: context.typo.pageSubtitle.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                  // Glass card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.15),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 24,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.12)),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _setAuthMode(false),
                                      borderRadius: const BorderRadius.horizontal(
                                        left: Radius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Text(
                                          '登录',
                                          textAlign: TextAlign.center,
                                          style: context.typo.body.copyWith(
                                            color: !_isRegisterMode
                                                ? const Color(0xFF00D9F5)
                                                : Colors.white54,
                                            fontWeight:
                                                !_isRegisterMode ? FontWeight.w700 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(width: 1, height: 28, color: Colors.white24),
                                Expanded(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _setAuthMode(true),
                                      borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(16),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        child: Text(
                                          '注册',
                                          textAlign: TextAlign.center,
                                          style: context.typo.body.copyWith(
                                            color: _isRegisterMode
                                                ? const Color(0xFF00D9F5)
                                                : Colors.white54,
                                            fontWeight:
                                                _isRegisterMode ? FontWeight.w700 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _mobileController,
                            style: context.typo.body.copyWith(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: '手机号',
                              labelStyle: context.typo.inputHint.copyWith(color: Colors.white70),
                              prefixIcon: const Icon(Icons.person, color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.03),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00D9F5),
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              final v = value?.trim() ?? '';
                              if (v.isEmpty) {
                                return '请输入手机号';
                              }
                              if (!_mobileRe.hasMatch(v)) {
                                return '请输入 11 位有效手机号';
                              }
                              return null;
                            },
                          ),
                          if (_isRegisterMode) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nicknameController,
                              style: context.typo.body.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: '用户名',
                                labelStyle: context.typo.inputHint.copyWith(color: Colors.white70),
                                prefixIcon: const Icon(Icons.badge_outlined, color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.03),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF00D9F5),
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                final v = value?.trim() ?? '';
                                if (v.isEmpty) return '请输入用户名';
                                if (v.length > 32) return '用户名不超过 32 字';
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _idCardController,
                              style: context.typo.body.copyWith(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: '身份证号',
                                labelStyle: context.typo.inputHint.copyWith(color: Colors.white70),
                                prefixIcon: const Icon(Icons.credit_card, color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.03),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide(
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF00D9F5),
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                final v = value?.trim() ?? '';
                                if (v.isEmpty) return '请输入身份证号';
                                if (!_idCardRe.hasMatch(v)) {
                                  return '请输入 15 或 18 位合法身份证号';
                                }
                                return null;
                              },
                            ),
                          ],
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            style: context.typo.body.copyWith(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: _isRegisterMode ? '密码' : '密码 123456',
                              labelStyle: context.typo.inputHint.copyWith(color: Colors.white70),
                              prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.03),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00D9F5),
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '请输入密码';
                              }
                              if (value.length < 6) {
                                return '密码至少 6 位';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            '请拖动滑块完成验证',
                            style: context.typo.pageSubtitle.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 6,
                                    activeTrackColor: const Color(0xFF00D9F5),
                                    inactiveTrackColor: Colors.white24,
                                    thumbColor: const Color(0xFF00F5A0),
                                    overlayColor: const Color(0x3300D9F5),
                                  ),
                                  child: Slider(
                                    value: _sliderValue,
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    label: _sliderVerified ? '已验证' : _sliderValue.toInt().toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        _sliderValue = value;
                                        if (value >= 100) {
                                          _sliderVerified = true;
                                        } else {
                                          _sliderVerified = false;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: Icon(
                                  _sliderVerified ? Icons.check_circle : Icons.radio_button_unchecked,
                                  key: ValueKey(_sliderVerified),
                                  color: _sliderVerified ? const Color(0xFF00F5A0) : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00D9F5),
                                foregroundColor: Colors.black,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _isLoading
                                    ? const SizedBox(
                                        key: ValueKey('loading'),
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                        ),
                                      )
                                    : Text(
                                        key: ValueKey('text'),
                                        _isRegisterMode ? '注册' : '登录',
                                        style: context.typo.button.copyWith(
                                          color: Colors.black,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

