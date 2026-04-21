import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models/ip_bean_entity.dart';

class IpToolPage extends StatefulWidget {
  const IpToolPage({super.key});

  @override
  State<IpToolPage> createState() => _IpToolPageState();
}

class _IpToolPageState extends State<IpToolPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final AnimationController _scanController;

  bool _loading = false;
  bool _pulseGlow = false;

  String ip = '';
  String country = '';
  String region = '';
  String province = '';
  String city = '';
  String isp = '';

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _initData();
  }

  Future<void> _initData() async {
    await _fetchIp('local', silent: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchIp(String text, {bool silent = false}) async {
    try {
      if (!silent) {
        setState(() => _loading = true);
      }
      final dio = Dio();
      final response =
          await dio.post('https://qqai.cn/api/ip', data: {'ip': text});
      final ipBeanEntity = IpBeanEntity.fromJson(response.data);
      final ipBeanData = ipBeanEntity.data;
      if (ipBeanData == null) {
        if (!silent && mounted) {
          _showSnack('查询失败!');
        }
        return;
      }
      if (!mounted) return;
      setState(() {
        ip = ipBeanData.ip ?? text;
        country = ipBeanData.country ?? '';
        region = ipBeanData.region ?? '';
        province = ipBeanData.province ?? '';
        city = ipBeanData.city ?? '';
        isp = ipBeanData.isp ?? '';
        _controller.text = ip;
        _pulseGlow = true;
      });
      Future<void>.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;
        setState(() => _pulseGlow = false);
      });
    } catch (_) {
      if (!silent && mounted) {
        _showSnack('网络异常，请稍后重试');
      }
    } finally {
      if (!silent && mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1A2A45),
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
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0x3300E5FF)),
              ),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF8CA8D8),
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
                style: const TextStyle(
                  color: Color(0xFFE7F0FF),
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onQuery() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      _showSnack('请输入正确的 IP!');
      return;
    }
    await _fetchIp(text, silent: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B1B),
      appBar: AppBar(
        title: const Text('IP 查询'),
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
        child: SafeArea(
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
                            final y = -0.35 + 1.7 * t;
                            return Align(
                              alignment: Alignment(0, y),
                              child: Container(
                                height: 86,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0x0000E5FF),
                                      Color(0x2000E5FF),
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
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 260),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: const Color(0xCC101A2D),
                        border: Border.all(
                          color: _pulseGlow
                              ? const Color(0xFF6BFFDE)
                              : const Color(0x5500E5FF),
                          width: _pulseGlow ? 1.6 : 1.2,
                        ),
                        boxShadow: [
                          const BoxShadow(
                            color: Color(0x3000E5FF),
                            blurRadius: 24,
                            spreadRadius: 1,
                            offset: Offset(0, 8),
                          ),
                          if (_pulseGlow)
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
                          const Text(
                            'Geo-IP Intelligence',
                            style: TextStyle(
                              color: Color(0xFF8EEFFF),
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '解析 IP 归属地、运营商等基础信息',
                            style: TextStyle(
                              color: Color(0xFF7C91B5),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  keyboardType: TextInputType.text,
                                  style: const TextStyle(
                                    color: Color(0xFFE7F0FF),
                                    fontSize: 16,
                                    fontFamily: 'monospace',
                                  ),
                                  decoration: InputDecoration(
                                    labelText: '请输入 IP 或 local',
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF8CA8D8),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.public,
                                      color: Color(0xFF53E5FF),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Color(0xFF8CA8D8),
                                      ),
                                      onPressed: _controller.clear,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xAA0A1328),
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
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              FilledButton.icon(
                                onPressed: _loading ? null : _onQuery,
                                icon: _loading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.search),
                                label: Text(_loading ? '查询中' : '查询'),
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
                          _infoRow('IP', ip),
                          _infoRow('国家', country),
                          _infoRow('大区', region),
                          _infoRow('省份', province),
                          _infoRow('城市', city),
                          _infoRow('运营商', isp),
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
    );
  }
}
