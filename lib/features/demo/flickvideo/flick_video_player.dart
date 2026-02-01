import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qqai/features/demo/flickvideo/short_video_player/homepage/short_video_homepage.dart';
import 'package:qqai/features/demo/flickvideo/web_video_player/web_video_player.dart';

import 'animation_player/animation_player.dart';
import 'custom_orientation_player/custom_orientation_player.dart';
import 'default_player/default_player.dart';
import 'feed_player/feed_player.dart';
import 'landscape_player/landscape_player.dart';

class FlickVideoPlayer extends StatefulWidget {
  const FlickVideoPlayer({Key? key}) : super(key: key);

  @override
  _FlickVideoPlayer createState() => _FlickVideoPlayer();
}

class _FlickVideoPlayer extends State<FlickVideoPlayer> {
  final List<Map<String, dynamic>> samples = [
    {'name': 'Default player', 'widget': DefaultPlayer()},
    {'name': 'Animation player', 'widget': Expanded(child: AnimationPlayer())},
    {'name': 'Feed player', 'widget': Expanded(child: FeedPlayer())},
    {'name': 'Custom orientation player', 'widget': CustomOrientationPlayer()},
    {'name': 'Landscape player', 'widget': LandscapePlayer()},
    {
      'name': 'Short Video Player',
      'widget': Expanded(child: ShortVideoHomePage()),
    },
  ];

  int selectedIndex = 0;

  changeSample(int index) {
    if (samples[index]['widget'] is LandscapePlayer) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => LandscapePlayer()));
    } else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return kIsWeb ? _buildWebView() : _buildMobileView();
    return kIsWeb ? _buildMobileView() : _buildMobileView();
  }

  Widget _buildWebView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          WebVideoPlayer(),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Flick video player',
                style: TextStyle(
                  color: Color.fromRGBO(100, 109, 236, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(child: samples[selectedIndex]['widget']),
        Container(
          height: 80,
          decoration: BoxDecoration(color: Colors.white),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: samples.asMap().keys.map((index) {
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    changeSample(index);
                  },
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        samples.asMap()[index]?['name'],
                        style: TextStyle(
                          color: index == selectedIndex
                              ? Color.fromRGBO(100, 109, 236, 1)
                              : Color.fromRGBO(173, 176, 183, 1),
                          fontWeight: index == selectedIndex
                              ? FontWeight.bold
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
