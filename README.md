# qqai

qqai

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# qqai


// 1. 只读依赖
final configProvider = Provider(...);

// 2. 简单 UI 状态
final searchQueryProvider = StateProvider.autoDispose(...);

// 3. 异步业务逻辑（主力！）
final userProvider = AsyncNotifierProvider<UserNotifier, User>(...);

// 4. 同步复杂状态
final formProvider = NotifierProvider<FormNotifier, FormState>(...);

80% 的场景用 AsyncNotifier
UI 开关用 StateProvider
其他用 Provider
页面级状态加 .autoDispose


编写带注解的类
dart
编辑
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_model.freezed.dart';

@freezed
class MyModel with _$MyModel {
  const factory MyModel({String? name, int? age}) = _MyModel;
}
# 首次或修改后运行
dart run build_runner build

# 开发时监听文件变化（推荐）
dart run build_runner watch