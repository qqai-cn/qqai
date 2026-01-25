import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../../router/app_routes.dart';
import 'FullVideoEntity.dart';

class MyVideo extends StatefulWidget {
  MyVideo({required this.id,required this.url, this.title, this.color, this.categary});

  final int id;
  final String url;
  final String? title;
  final Color? color;
  final int? categary;

  @override
  _MyVideo createState() => _MyVideo();
}

class _MyVideo extends State<MyVideo> {
  late VideoPlayerController _controller;
  double volume = 0;
  bool showContro = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url ?? ''))
      ..initialize().then((_) {
        setState(() {
          _controller.setVolume(volume);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Hero(
        tag: 'fullVideo-${widget.categary}-${widget.id}',
        child: Stack(
          children: [
            Container(color: Colors.black),
            if (_controller.value.isInitialized) VideoPlayer(_controller),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (d) {
                  setState(() {
                    showContro = !showContro;
                  });
                },
                onDoubleTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            if (showContro)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0, // 紧贴底部
                child: botomBar(), // botomBar 现在有了明确的垂直定位
              ),
            if (!_controller.value.isPlaying)
              Center(
                child: IconButton(
                  color: Colors.white.withAlpha(150),
                  icon: Icon(Icons.play_circle_filled),
                  onPressed: () => {
                    setState(() {
                      _controller.play();
                    }),
                  },
                  iconSize: 80,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  //进度条和控制栏
  Widget botomBar() {
    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;
    final isPlaying = _controller.value.isPlaying;
    // 获取当前音量，避免未初始化问题
    final currentVolume = _controller.value.isInitialized
        ? _controller.value.volume
        : 0.0;
    return Material(
      type: MaterialType.transparency,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                color: Colors.white,
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  setState(() {
                    isPlaying ? _controller.pause() : _controller.play();
                  });
                },
              ),
              Text(
                '${formartDate(currentPosition)} / ${formartDate(duration)}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(width: 10),
              Spacer(),
              // 音量按钮
              IconButton(
                onPressed: () {
                  setState(() {
                    // 切换静音状态
                    final newVolume = currentVolume > 0
                        ? 0.0
                        : (volume > 0 ? volume : 0.5);
                    volume = newVolume; // 更新本地 volume 变量
                    _controller.setVolume(newVolume);
                  });
                },
                icon: Icon(
                  getVolume(currentVolume), // 使用当前音量判断图标
                  color: Colors.white,
                  size: 25,
                ),
              ),
              Expanded(
                // <--- 关键修改
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 2.0, // 可选：调整轨道高度
                  ),
                  child: Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    onChanged: (double newVolume) {
                      setState(() {
                        volume = newVolume;
                        _controller.setVolume(newVolume);
                      });
                    },
                    value: currentVolume,
                    // 使用当前音量
                    min: 0.0,
                    max: 1.0,
                  ),
                ),
              ),
              //全屏按钮
              IconButton(
                onPressed: () {
                  FullVideoEntity fullVideoEntity = FullVideoEntity().copyWith(
                    controller: _controller,
                    id: widget.id,
                    heroTag: 'fullVideo-${widget.categary}-${widget.id}',
                  );
                  context.push(Routes.fullVideoUrl, extra: fullVideoEntity);
                },
                icon: Icon(Icons.crop_free, color: Colors.white),
              ),
            ],
          ),
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }

  String formartDate(Duration date) {
    final sec = date.inSeconds % 60;
    final realSec = sec < 10 ? '0$sec' : sec;
    final min = date.inMinutes < 10 ? '0${date.inMinutes}' : date.inMinutes;
    final hour = date.inHours > 0 ? '${date.inHours}:' : '';
    return '$hour$min:$realSec';
  }

  IconData getVolume(double volume) {
    if (volume == 0) {
      return Icons.volume_off;
    } else if (volume > 0 && volume <= 0.33) {
      return Icons.volume_mute;
    } else if (volume > 0.33 && volume <= 0.6) {
      return Icons.volume_down;
    } else {
      return Icons.volume_up;
    }
  }
}
