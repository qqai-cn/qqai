import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateToolPage extends StatefulWidget {
  const DateToolPage({super.key});

  @override
  State<DateToolPage> createState() => _DateToolPage();
}

class _DateToolPage extends State<DateToolPage>
    with SingleTickerProviderStateMixin {
  late int currentTimeStamp;
  late String currentTime;
  bool _pulseGlow = false;
  late final AnimationController _scanController;

  // 时间格式，1: 毫秒；2: 秒
  int secondTypeSelect = 1;

  // 日期格式，1: 日期+时间；2: 仅日期
  int dateTypeSelect = 1;
  late TextEditingController timestampController;
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
    currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    timestampController = TextEditingController(text: '$currentTimeStamp');
    currentTime = timestampToDateStr(currentTimeStamp);
    dateController = TextEditingController(text: currentTime);
  }

  @override
  void dispose() {
    _scanController.dispose();
    timestampController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050B1B),
      appBar: AppBar(
        title: const Text('时间工具'),
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
            colors: [Color(0xFF050B1B), Color(0xFF0B1630), Color(0xFF102447)],
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
                      color: const Color(0xCC101A2D),
                      borderRadius: BorderRadius.circular(18),
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
                            blurRadius: 30,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Temporal Intelligence Console',
                          style: TextStyle(
                            color: Color(0xFF8EEFFF),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '时间戳 / 日期 智能转换工具',
                          style: TextStyle(
                            color: Color(0xFF7C91B5),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildNowPanel(),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            FilledButton.icon(
                              onPressed: _refreshNow,
                              icon: const Icon(Icons.refresh),
                              label: const Text('刷新当前时间'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF00C6FF),
                                foregroundColor: Colors.white,
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _convertToDate,
                              icon: const Icon(Icons.schedule),
                              label: const Text('时间戳 -> 日期'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF8EEFFF),
                                side:
                                    const BorderSide(color: Color(0x5500E5FF)),
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: _convertToTimestamp,
                              icon: const Icon(Icons.tag),
                              label: const Text('日期 -> 时间戳'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF8EEFFF),
                                side:
                                    const BorderSide(color: Color(0x5500E5FF)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _buildTimestampInput(),
                        const SizedBox(height: 14),
                        _buildDateInput(),
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

  Widget _buildNowPanel() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xAA0A1328),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x3300E5FF)),
      ),
      child: SelectableText.rich(
        TextSpan(
          style: const TextStyle(fontSize: 15, color: Color(0xFF99B0D8)),
          children: [
            const TextSpan(
              text: '当前时间戳（毫秒）：',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF8CA8D8),
              ),
            ),
            TextSpan(
              text: '$currentTimeStamp',
              style: const TextStyle(
                color: Color(0xFF6BFFDE),
                fontFamily: 'monospace',
              ),
            ),
            const TextSpan(text: '\n当前时间：'),
            TextSpan(
              text: currentTime,
              style: const TextStyle(
                color: Color(0xFF6BFFDE),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: timestampController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Color(0xFFE7F0FF),
              fontSize: 16,
              fontFamily: 'monospace',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(secondTypeSelect == 1 ? 13 : 10),
            ],
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Color(0xFF8CA8D8)),
              labelText: '请输入时间戳',
              prefixIcon:
                  const Icon(Icons.timer_outlined, color: Color(0xFF53E5FF)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF8CA8D8)),
                onPressed: timestampController.clear,
              ),
              counterStyle: const TextStyle(color: Color(0xFF7C91B5)),
              filled: true,
              fillColor: const Color(0xAA0A1328),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x5500E5FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<int>(
            dropdownColor: const Color(0xFF152846),
            initialValue: secondTypeSelect,
            decoration: InputDecoration(
              labelText: '单位',
              labelStyle: const TextStyle(color: Color(0xFF8CA8D8)),
              filled: true,
              fillColor: const Color(0xAA0A1328),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x5500E5FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.4),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text('毫秒', style: TextStyle(color: Color(0xFFE7F0FF))),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text('秒', style: TextStyle(color: Color(0xFFE7F0FF))),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                secondTypeSelect = value;
                secondChange();
                dateChange();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: dateController,
            keyboardType: TextInputType.datetime,
            style: const TextStyle(
              color: Color(0xFFE7F0FF),
              fontSize: 16,
              fontFamily: 'monospace',
            ),
            maxLength: dateTypeSelect == 1 ? 19 : 10,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Color(0xFF8CA8D8)),
              hintStyle: const TextStyle(color: Color(0xFF6E86B2)),
              labelText: dateTypeSelect == 1 ? '请输入日期时间' : '请输入日期',
              hintText:
                  dateTypeSelect == 1 ? '例如 2026-04-21 13:20:00' : '例如 2026-04-21',
              prefixIcon:
                  const Icon(Icons.event_outlined, color: Color(0xFF53E5FF)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF8CA8D8)),
                onPressed: dateController.clear,
              ),
              counterStyle: const TextStyle(color: Color(0xFF7C91B5)),
              filled: true,
              fillColor: const Color(0xAA0A1328),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x5500E5FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<int>(
            dropdownColor: const Color(0xFF152846),
            initialValue: dateTypeSelect,
            decoration: InputDecoration(
              labelText: '格式',
              labelStyle: const TextStyle(color: Color(0xFF8CA8D8)),
              filled: true,
              fillColor: const Color(0xAA0A1328),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x5500E5FF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00E5FF), width: 1.4),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 1,
                child: Text('日期时间', style: TextStyle(color: Color(0xFFE7F0FF))),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text('仅日期', style: TextStyle(color: Color(0xFFE7F0FF))),
              ),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                dateTypeSelect = value;
                dateChange();
              });
            },
          ),
        ),
      ],
    );
  }

  void _refreshNow() {
    setState(() {
      secondChange();
      dateChange();
      _pulseGlow = true;
    });
    _dismissPulseLater();
  }

  void _convertToDate() {
    final input = int.tryParse(timestampController.text.trim());
    if (input == null) {
      _showError('请输入正确的数字时间戳');
      return;
    }
    setState(() {
      final normalized = secondTypeSelect == 2 ? input * 1000 : input;
      currentTimeStamp = normalized;
      dateController.text =
          timestampToDateStr(currentTimeStamp, onlyNeedDate: dateTypeSelect == 2);
      currentTime = dateController.text;
      _pulseGlow = true;
    });
    _dismissPulseLater();
  }

  void _convertToTimestamp() {
    final raw = dateController.text.trim();
    if (raw.isEmpty) {
      _showError('请输入日期或时间');
      return;
    }

    final parseText = dateTypeSelect == 2 && raw.length == 10 ? '$raw 00:00:00' : raw;
    final dt = DateTime.tryParse(parseText);
    if (dt == null) {
      _showError('日期格式错误，请使用 YYYY-MM-DD 或 YYYY-MM-DD HH:MM:SS');
      return;
    }

    setState(() {
      final ms = dt.millisecondsSinceEpoch;
      currentTimeStamp = secondTypeSelect == 1 ? ms : (ms / 1000).truncate();
      timestampController.text = '$currentTimeStamp';
      currentTime = timestampToDateStr(ms, onlyNeedDate: dateTypeSelect == 2);
      _pulseGlow = true;
    });
    _dismissPulseLater();
  }

  void _dismissPulseLater() {
    Future<void>.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _pulseGlow = false;
      });
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1A2A45),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static String timestampToDateStr(int timestamp, {onlyNeedDate = false}) {
    final dataTime = timestampToDate(timestamp);
    var dateTime = dataTime.toString();

    // 去掉时间后面的 .000
    dateTime = dateTime.substring(0, dateTime.length - 4);
    if (onlyNeedDate) {
      final dataList = dateTime.split(' ');
      dateTime = dataList[0];
    }
    return dateTime;
  }

  static DateTime timestampToDate(int timestamp) {
    var dateTime = DateTime.now();

    // 如果是十三位时间戳返回这个
    if (timestamp.toString().length == 13) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    } else if (timestamp.toString().length == 16) {
      // 如果是十六位时间戳
      dateTime = DateTime.fromMicrosecondsSinceEpoch(timestamp);
    } else if (timestamp.toString().length == 10) {
      dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    }
    return dateTime;
  }

  void secondChange() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (secondTypeSelect == 1) {
      currentTimeStamp = now;
    } else {
      currentTimeStamp = (now / 1000).truncate();
    }
    timestampController.text = '$currentTimeStamp';
  }

  void dateChange() {
    if (dateTypeSelect == 1) {
      currentTime = timestampToDateStr(currentTimeStamp, onlyNeedDate: false);
    } else {
      currentTime = timestampToDateStr(currentTimeStamp, onlyNeedDate: true);
    }
    dateController.text = currentTime;
  }
}
