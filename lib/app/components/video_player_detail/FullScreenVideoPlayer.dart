import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:video_player/video_player.dart';

import 'FullVideoEntity.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  const FullScreenVideoPlayer({super.key});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer>
    with SingleTickerProviderStateMixin {
  bool showContro = true;
  double volume = 0;
  late Duration videoPoision;
  final FullVideoEntity? fullVideoEntity = Get.arguments as FullVideoEntity?;
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = fullVideoEntity!.controller!
      ..addListener(videoPoisionListener);
    // --- Configure System UI for Fullscreen ---
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    volume = controller.value.volume;
  }

  void videoPoisionListener() {
    setState(() {
      videoPoision = fullVideoEntity!.controller!.value.position;
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    controller.removeListener(videoPoisionListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: '${fullVideoEntity!.heroTag}',
        child: Scaffold(
          body: Stack(children: <Widget>[
            Container(
              color: Colors.black,
            ),
            if (controller.value.isInitialized) VideoPlayer(controller),
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
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  });
                },
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            if (showContro) overLay(controller),
            if (!controller.value.isPlaying)
              Center(
                  child: IconButton(
                color: Colors.white.withAlpha(150),
                icon: Icon(
                  Icons.play_circle_filled,
                ),
                onPressed: () => {
                  setState(() {
                    controller.play();
                  })
                },
                iconSize: 80,
              )),
          ]),
        ));
  }

  //覆盖页
  Widget overLay(VideoPlayerController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            '',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Spacer(),
        botomBar(controller),
      ],
    );
  }

//进度条和控制栏
  Widget botomBar(VideoPlayerController controller) {
    final currentPosition = controller.value.position;
    final duration = controller.value.duration;
    final isPlaying = controller.value.isPlaying;
    // 获取当前音量，避免未初始化问题
    final currentVolume =
        controller.value.isInitialized ? controller.value.volume : 0.0;

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              color: Colors.white,
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  controller.value.isPlaying
                      ? controller.pause()
                      : controller.play();
                });
              },
            ),
            Text(
              '${formartDate(controller.value.position)} / ${formartDate(controller.value.duration)}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              width: 10,
            ),
            Spacer(),
            // 音量按钮
            IconButton(
              onPressed: () {
                setState(() {
                  // 切换静音状态
                  final newVolume =
                      currentVolume > 0 ? 0.0 : (volume > 0 ? volume : 0.5);
                  volume = newVolume; // 更新本地 volume 变量
                  controller.setVolume(newVolume);
                });
              },
              icon: Icon(
                getVolume(currentVolume), // 使用当前音量判断图标
                color: Colors.white,
                size: 25,
              ),
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2.0, // 可选：调整轨道高度
              ),
              child: Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                onChanged: (double newVolume) {
                  setState(() {
                    volume = newVolume;
                    controller.setVolume(newVolume);
                  });
                },
                value: currentVolume,
                // 使用当前音量
                min: 0.0,
                max: 1.0,
              ),
            ),
            //全屏按钮
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.crop_free,
                color: Colors.white,
              ),
            ),
          ],
        ),
        VideoProgressIndicator(
          controller,
          allowScrubbing: true,
          padding: EdgeInsets.all(10),
        ),
      ],
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
