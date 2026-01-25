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
# 执行自动创建
flutter_clean_architecture_generator

// 用法示例:
dart run lib/util/generator.dart share --dir=lib/features


错误写法,正确写法
build() 里调用 ref.watch(xxx) + 异步方法,build() 里 ref.read + await
build() 里调用另一个会 watch 的方法,把异步逻辑直接写在 build() 里，或用 ref.read
build() 里操作 state = xxx,只在 build() 外操作 state


jsontomodel
从 JSON 文件生成到指定输出文件：
dart run lib/util/json_to_model.dart SharePageModel --json-file=mock/blog_page.json --out=lib/features/share/data/models/share_page_model.dart
从 JSON 字符串生成（输出到终端）：
dart run lib/util/json_to_model.dart Test --json='{"id":1,"title":"hi"}'
