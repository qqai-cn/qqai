import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoProgressBar extends StatefulWidget {
  final VideoPlayerController controller;

  const CustomVideoProgressBar({Key? key, required this.controller})
      : super(key: key);

  @override
  _CustomVideoProgressBarState createState() => _CustomVideoProgressBarState();
}

class _CustomVideoProgressBarState extends State<CustomVideoProgressBar> {
  double _progress = 0.0;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    if (_isDragging || !widget.controller.value.isInitialized) return;
    final positionMs =
        widget.controller.value.position.inMilliseconds.toDouble();
    if (!positionMs.isFinite) return;
    setState(() {
      _progress = positionMs;
    });
  }

  void _onDragStart(double value) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onDragEnd(double value) {
    if (!value.isFinite || value < 0) return;
    setState(() {
      _isDragging = false;
    });
    if (!widget.controller.value.isInitialized) return;
    final durationMs = widget.controller.value.duration.inMilliseconds;
    if (durationMs <= 0) return;
    final targetMs = value.round().clamp(0, durationMs);
    widget.controller.seekTo(Duration(milliseconds: targetMs));
  }

  @override
  Widget build(BuildContext context) {
    final rawDuration = widget.controller.value.isInitialized
        ? widget.controller.value.duration.inMilliseconds.toDouble()
        : 0.0;
    final duration = rawDuration.isFinite && rawDuration > 0 ? rawDuration : 1.0;
    final bufferedEnd = widget.controller.value.buffered.isNotEmpty
        ? widget.controller.value.buffered.last.end.inMilliseconds.toDouble()
        : 0.0;

    return Column(
      children: [
        // 显示缓冲进度
        // LinearProgressIndicator(
        //   value: bufferedEnd / duration,
        //   backgroundColor: Colors.grey[300],
        //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        // ),
        // 进度条

        Text(formatDuration((_progress / 1000).toInt()) +
            '/' +
            formatDuration((duration / 1000).toInt())),
        Slider(
          value: _progress.clamp(0.0, duration),
          min: 0.0,
          max: duration,
          inactiveColor: Colors.grey,
          onChangeStart: _onDragStart,
          onChanged: (value) {
            setState(() {
              _progress = value;
            });
          },
          onChangeEnd: _onDragEnd,
        ),
      ],
    );
  }

  String formatDuration(int seconds) {
    // 计算小时、分钟和秒
    int hours = seconds ~/ 3600; // 1 小时 = 3600 秒
    int minutes = (seconds % 3600) ~/ 60; // 1 分钟 = 60 秒
    int remainingSeconds = seconds % 60;

    // 格式化时间为 HH:MM:SS
    String hoursStr = hours.toString().padLeft(2, '0'); // 补零
    String minutesStr = minutes.toString().padLeft(2, '0'); // 补零
    String secondsStr = remainingSeconds.toString().padLeft(2, '0'); // 补零

    return '$hoursStr:$minutesStr:$secondsStr';
  }
}
