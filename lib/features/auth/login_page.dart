import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/app_config_providers.dart';
import '../../providers/auth_providers.dart';
import '../../router/app_routes.dart';
import 'package:qqai/config/theme/app_typography.dart';

/// 登录页随 Material 亮/暗色切换的外观
class _LoginPageColors {
  _LoginPageColors._(this.isDark);
  final bool isDark;

  factory _LoginPageColors.of(BuildContext context) {
    return _LoginPageColors._(Theme.of(context).brightness == Brightness.dark);
  }

  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isDark
            ? const [Color(0xFF141E30), Color(0xFF243B55)]
            : const [Color(0xFFD8E1EB), Color(0xFFF2F5F9)],
      );

  Color get bodyText => isDark ? Colors.white : const Color(0xFF15202B);
  Color get secondaryText => isDark ? Colors.white70 : const Color(0xFF4A5568);
  Color get hintStyle => isDark ? Colors.white70 : const Color(0xFF6B7280);
  Color get iconSecondary => isDark ? Colors.white70 : const Color(0xFF5C6570);
  Color get fieldFill =>
      isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF5F7FA);
  Color get borderSubtle =>
      isDark ? Colors.white.withValues(alpha: 0.15) : const Color(0x33000000);
  Color get cardBg =>
      isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.88);
  Color get cardBorder => isDark
      ? Colors.white.withValues(alpha: 0.15)
      : Colors.black.withValues(alpha: 0.06);
  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: isDark ? const Color(0x66000000) : const Color(0x14000000),
          blurRadius: 24,
          offset: const Offset(0, 16),
        ),
      ];
  Color get pillFill =>
      isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.75);
  Color get pillBorder => isDark
      ? Colors.white.withValues(alpha: 0.12)
      : Colors.black.withValues(alpha: 0.06);
  Color get inactiveTab => isDark ? Colors.white54 : const Color(0xFF7A8698);
  Color get sliderTrackBg => isDark ? Colors.white24 : const Color(0xFFCFD8E0);
  Color get verifyIconInactive => isDark ? Colors.white54 : const Color(0xFF9CA3AF);
  Color get logoShadowCyan => const Color(0xFF00D9F5).withValues(alpha: 0.45);
  Color get logoShadowDark => Colors.black.withValues(alpha: isDark ? 0.35 : 0.18);
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _idCardController = TextEditingController();
  bool _isRegisterMode = false;
  bool _loginByQqId = true;
  bool _isLoading = false;
  double _sliderValue = 0;
  bool _sliderVerified = false;

  static final _mobileRe = RegExp(r'^1\d{10}$');
  static final _qqIdRe = RegExp(r'^\d+$');
  static final _idCardRe = RegExp(r'^\d{15}$|^\d{17}[\dXx]$');

  @override
  void dispose() {
    _accountController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _idCardController.dispose();
    super.dispose();
  }

  void _setAuthMode(bool register) {
    if (_isRegisterMode == register) return;
    setState(() {
      _isRegisterMode = register;
      _loginByQqId = !register;
      _sliderValue = 0;
      _sliderVerified = false;
    });
  }

  void _setLoginAccountMode(bool byQqId) {
    if (_loginByQqId == byQqId) return;
    setState(() {
      _loginByQqId = byQqId;
      _accountController.clear();
    });
  }

  void _enterAsGuest() {
    context.go(Routes.HOME);
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
          mobile: _accountController.text.trim(),
          password: _passwordController.text,
          username: _nicknameController.text.trim(),
          idCard: _idCardController.text.trim(),
        );
      } else if (_loginByQqId) {
        await authNotifier.login(
          qqId: int.parse(_accountController.text.trim()),
          password: _passwordController.text,
        );
      } else {
        await authNotifier.login(
          mobile: _accountController.text.trim(),
          password: _passwordController.text,
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

  InputDecoration _loginFieldDecoration(
    _LoginPageColors c, {
    required String label,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: context.typo.inputHint.copyWith(color: c.hintStyle),
      prefixIcon: Icon(prefixIcon, color: c.iconSecondary),
      filled: true,
      fillColor: c.fieldFill,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c.borderSubtle),
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
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _LoginPageColors.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: c.backgroundGradient),
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
                      Image.asset(
                        'imgs/qqai_logo.png',
                        width: 96,
                        height: 96,
                        fit: BoxFit.contain,
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
                          color: c.bodyText,
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
                          color: c.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                  // Glass card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: c.cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: c.cardBorder),
                      boxShadow: c.cardShadow,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: c.pillFill,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: c.pillBorder),
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
                                                : c.inactiveTab,
                                            fontWeight:
                                                !_isRegisterMode ? FontWeight.w700 : FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(width: 1, height: 28, color: c.borderSubtle),
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
                                                : c.inactiveTab,
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
                          if (!_isRegisterMode) ...[
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: c.pillFill,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: c.pillBorder),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _setLoginAccountMode(false),
                                        borderRadius: const BorderRadius.horizontal(
                                          left: Radius.circular(12),
                                        ),
                                        child: Tooltip(
                                          message: '手机号',
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Icon(
                                              Icons.phone_android,
                                              size: 22,
                                              color: !_loginByQqId
                                                  ? const Color(0xFF00D9F5)
                                                  : c.inactiveTab,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(width: 1, height: 22, color: c.borderSubtle),
                                  Expanded(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () => _setLoginAccountMode(true),
                                        borderRadius: const BorderRadius.horizontal(
                                          right: Radius.circular(12),
                                        ),
                                        child: Tooltip(
                                          message: '千千号',
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Icon(
                                              Icons.account_circle,
                                              size: 22,
                                              color: _loginByQqId
                                                  ? const Color(0xFF00D9F5)
                                                  : c.inactiveTab,
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
                          ],
                          TextFormField(
                            controller: _accountController,
                            style: context.typo.body.copyWith(color: c.bodyText),
                            decoration: _loginFieldDecoration(
                              c,
                              label: _isRegisterMode
                                  ? '手机号'
                                  : (_loginByQqId ? '千千号' : '手机号'),
                              prefixIcon: _isRegisterMode || !_loginByQqId
                                  ? Icons.phone_android
                                  : Icons.tag,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              final v = value?.trim() ?? '';
                              if (v.isEmpty) {
                                return _isRegisterMode || !_loginByQqId
                                    ? '请输入手机号'
                                    : '请输入千千号';
                              }
                              if (_isRegisterMode || !_loginByQqId) {
                                if (!_mobileRe.hasMatch(v)) {
                                  return '请输入 11 位有效手机号';
                                }
                              } else {
                                if (!_qqIdRe.hasMatch(v)) {
                                  return '千千号只能包含数字';
                                }
                                if (int.tryParse(v) == null || int.parse(v) <= 0) {
                                  return '请输入有效的千千号';
                                }
                              }
                              return null;
                            },
                          ),
                          if (_isRegisterMode) ...[
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nicknameController,
                              style: context.typo.body.copyWith(color: c.bodyText),
                              decoration: _loginFieldDecoration(
                                c,
                                label: '用户名',
                                prefixIcon: Icons.badge_outlined,
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
                              style: context.typo.body.copyWith(color: c.bodyText),
                              decoration: _loginFieldDecoration(
                                c,
                                label: '身份证号',
                                prefixIcon: Icons.credit_card,
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
                            style: context.typo.body.copyWith(color: c.bodyText),
                            decoration: _loginFieldDecoration(
                              c,
                              label:'密码',
                              prefixIcon: Icons.lock,
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
                              color: c.secondaryText,
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
                                    inactiveTrackColor: c.sliderTrackBg,
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
                                  color: _sliderVerified ? const Color(0xFF00F5A0) : c.verifyIconInactive,
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
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _isLoading ? null : _enterAsGuest,
                            style: TextButton.styleFrom(
                              foregroundColor: c.secondaryText,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              '游客',
                              style: context.typo.button.copyWith(
                                color: c.secondaryText,
                                letterSpacing: 0.5,
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
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: IconButton(
                tooltip: c.isDark ? '切换到白天' : '切换到夜间',
                icon: Icon(
                  c.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: c.bodyText.withValues(alpha: 0.82),
                ),
                onPressed: () => ref
                    .read(appThemeModeProvider.notifier)
                    .toggleForPlatform(
                      MediaQuery.platformBrightnessOf(context),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

