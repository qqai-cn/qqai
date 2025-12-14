import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerHourWeatherView extends ConsumerWidget {
  const PerHourWeatherView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Card(
        child: Row(
          children: [
            Column(
              children: const [
                Text('1'),
                Text('1'),
              ],
            )
          ],
        ),
      ),
    );
  }
}