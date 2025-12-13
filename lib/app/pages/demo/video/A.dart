import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 原始图片
              Image.asset('imgs/defbak.png', width: 200),

              // 倒影部分
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationX(3.14159), // 180° 翻转
                child: Opacity(
                  opacity: 0.5,
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.transparent],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset('imgs/defbak.png', width: 200),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
