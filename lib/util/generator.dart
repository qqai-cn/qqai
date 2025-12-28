// generate_riverpod_feature.dart
// 用法示例: dart run lib/util/generator.dart todo_list --dir=lib/features

import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('用法: dart run generate_riverpod_feature.dart <feature_name> [--dir=路径] [--force]');
    exit(1);
  }

  final feature = args[0].trim();
  if (feature.length < 3) {
    print('特征名太短，至少 3 个字符');
    exit(1);
  }

  String baseDir = 'lib/features';
  bool force = false;

  for (final arg in args.skip(1)) {
    if (arg.startsWith('--dir=')) baseDir = arg.substring(6);
    if (arg == '--force') force = true;
  }

  final n = _Name(feature);
  final cleanName = n.clean;
  final featureDirPath = '$baseDir/$cleanName';
  final dir = Directory(featureDirPath);

  if (dir.existsSync()) {
    if (!force) {
      print('目录已存在: $featureDirPath （加 --force 强制覆盖）');
      exit(1);
    }
    dir.deleteSync(recursive: true);
    print('已删除旧目录: $featureDirPath');
  }

  dir.createSync(recursive: true);
  print('生成 feature: $featureDirPath');

  _write('$featureDirPath/data/models/${cleanName}_model.dart', _modelTemplate(n));
  _write('$featureDirPath/data/repos/${cleanName}_repo.dart', _repoTemplate(n));
  _write('$featureDirPath/providers/${cleanName}_providers.dart', _providersTemplate(n));
  _write('$featureDirPath/pages/${cleanName}_page.dart', _pageTemplate(n));

  print('\n生成完成！');
  print('下一步：dart run build_runner build --delete-conflicting-outputs');
  print('页面中使用：ref.watch(${n.clean}Provider)');
}

void _write(String path, String content) {
  Directory(path).parent.createSync(recursive: true);
  File(path).writeAsStringSync(content.trimLeft());
  print('  └─ $path');
}

// ──────────────────────────────────────────────────────────────
// 模板（已统一使用 generator 生成的小写 provider 名称）
// ──────────────────────────────────────────────────────────────

String _modelTemplate(_Name n) => '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${n.clean}_model.freezed.dart';
part '${n.clean}_model.g.dart';

@freezed
sealed class ${n.pascal}Model with _\$${n.pascal}Model {
  const factory ${n.pascal}Model({
    required String id,
    required String title,
    @Default(false) bool isDone,
    // 根据需求添加更多字段
  }) = _${n.pascal}Model;

  factory ${n.pascal}Model.fromJson(Map<String, dynamic> json) =>
      _\$${n.pascal}ModelFromJson(json);
}
''';

String _repoTemplate(_Name n) => '''
import '../models/${n.clean}_model.dart';

abstract class I${n.pascal}Repository {
  Future<List<${n.pascal}Model>> getAll${n.pascal}s();
  Future<${n.pascal}Model?> get${n.pascal}ById(String id);
  Future<void> add${n.pascal}(${n.pascal}Model item);
  Future<void> update${n.pascal}(${n.pascal}Model item);
  Future<void> delete${n.pascal}(String id);
}

class ${n.pascal}Repository implements I${n.pascal}Repository {
  final List<${n.pascal}Model> _items = [];

  @override
  Future<List<${n.pascal}Model>> getAll${n.pascal}s() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<${n.pascal}Model?> get${n.pascal}ById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> add${n.pascal}(${n.pascal}Model item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> update${n.pascal}(${n.pascal}Model item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> delete${n.pascal}(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}
''';

String _providersTemplate(_Name n) => '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../data/repos/${n.clean}_repo.dart';
import '../data/models/${n.clean}_model.dart';

part '${n.clean}_providers.freezed.dart';  
part '${n.clean}_providers.g.dart';

@freezed
sealed class ${n.pascal}State with _\$${n.pascal}State {
  const factory ${n.pascal}State({
    @Default(AsyncLoading()) AsyncValue<List<${n.pascal}Model>> items,
    String? error,
  }) = _${n.pascal}State;
}

@riverpod
class ${n.pascal}Notifier extends _\$${n.pascal}Notifier {
  late final I${n.pascal}Repository _repo;

  @override
  ${n.pascal}State build() {
    _repo = ref.read(${n.clean}RepositoryProvider);
    return const ${n.pascal}State();
  }

  Future<void> load() async {
    ${n.camel}State = ${n.camel}State.copyWith(items: const AsyncLoading(), error: null);
    try {
      final items = await _repo.getAll${n.pascal}s();
      ${n.camel}State = ${n.camel}State.copyWith(items: AsyncData(items));
    } catch (e, st) {
      ${n.camel}State = ${n.camel}State.copyWith(items: AsyncError(e, st), error: e.toString());
    }
  }

  Future<void> add(String title) async {
    if (title.trim().isEmpty) return;
    final newItem = ${n.pascal}Model(
      id: const Uuid().v4(),
      title: title,
      isDone: false,
    );
    try {
      await _repo.add${n.pascal}(newItem);
      await load();
    } catch (e) {
      ${n.camel}State = ${n.camel}State.copyWith(error: '添加失败: \$e');
    }
  }

  Future<void> toggle(String id) async {
    final item = await _repo.get${n.pascal}ById(id);
    if (item == null) return;
    final updated = item.copyWith(isDone: !item.isDone);
    try {
      await _repo.update${n.pascal}(updated);
      await load();
    } catch (e) {
      ${n.camel}State = ${n.camel}State.copyWith(error: '更新失败: \$e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.delete${n.pascal}(id);
      await load();
    } catch (e) {
      ${n.camel}State = ${n.camel}State.copyWith(error: '删除失败: \$e');
    }
  }
}

final ${n.clean}RepositoryProvider = Provider<I${n.pascal}Repository>(
  (ref) => ${n.pascal}Repository(),
);
''';

String _pageTemplate(_Name n) => '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/${n.clean}_providers.dart';

class ${n.pascal}Page extends ConsumerStatefulWidget {
  const ${n.pascal}Page({super.key});

  @override
  ConsumerState<${n.pascal}Page> createState() => _${n.pascal}PageState();
}

class _${n.pascal}PageState extends ConsumerState<${n.pascal}Page> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ${n.camel}State = ref.watch(${n.camel}Provider);
    final ${n.camel}Notifier = ref.read(${n.camel}Provider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('${n.pascal}')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: '输入新任务'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      ${n.camel}Notifier.add(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ${n.camel}State.items.when(
              data: (items) => ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return ListTile(
                    leading: Checkbox(
                      value: item.isDone,
                      onChanged: (_) => ${n.camel}Notifier.toggle(item.id),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        decoration: item.isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => ${n.camel}Notifier.delete(item.id),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('错误: \$err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ${n.camel}Notifier.load,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
''';

class _Name {
  final String raw;
  _Name(this.raw);

  static List<String> _split(String input) =>
      input.split(RegExp(r'[_ -]+')).where((s) => s.isNotEmpty).toList();

  String get clean => raw.toLowerCase().replaceAll(RegExp(r'[_ -]'), '');

  String get camel {
    final parts = _split(raw);
    if (parts.isEmpty) return '';
    return parts[0].toLowerCase() +
        parts.skip(1).map((s) => s[0].toUpperCase() + s.substring(1).toLowerCase()).join();
  }

  String get pascal => _split(raw)
      .map((s) => s[0].toUpperCase() + s.substring(1).toLowerCase())
      .join();
}