// 用法示例：
// 1) 从文件生成
// dart run lib/util/json_to_model.dart BlogItem --json-file=mock/message.json --out=lib/features/blog/domain/blog_item.dart
//
// 2) 从字符串生成（注意 shell 转义）
// dart run lib/util/json_to_model.dart BlogItem --json='{"id":1,"title":"hi"}'
//
// 生成后运行：
// dart run build_runner build --delete-conflicting-outputs

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln(
      '用法: dart run lib/util/json_to_model.dart <ClassName> '
      '[--json-file=path | --json=<json>] '
      '[--out=path]',
    );
    exit(1);
  }

  final className = _pascal(args[0].trim());
  if (className.isEmpty) {
    stderr.writeln('ClassName 不能为空');
    exit(1);
  }

  String? jsonFile;
  String? jsonInline;
  String? outPath;

  for (final arg in args.skip(1)) {
    if (arg.startsWith('--json-file=')) jsonFile = arg.substring(11);
    if (arg.startsWith('--json=')) jsonInline = arg.substring(7);
    if (arg.startsWith('--out=')) outPath = arg.substring(6);
  }

  if ((jsonFile == null || jsonFile.isEmpty) &&
      (jsonInline == null || jsonInline.isEmpty)) {
    stderr.writeln('必须提供 --json-file 或 --json');
    exit(1);
  }

  // 容错：用户有时会写成 --json-file==mock/a.json，导致 path 以 "=" 开头
  jsonFile = jsonFile?.trim();
  if (jsonFile != null && jsonFile.startsWith('=')) {
    jsonFile = jsonFile.replaceFirst(RegExp(r'^=+'), '');
  }

  final jsonStr = (jsonFile != null && jsonFile.isNotEmpty)
      ? File(jsonFile).readAsStringSync()
      : jsonInline!;

  dynamic decoded;
  try {
    decoded = jsonDecode(jsonStr);
  } catch (e) {
    stderr.writeln('JSON 解析失败: $e');
    exit(1);
  }

  final fileName = _snake(className);
  final partBase = fileName;

  final gen = _FreezedGenerator(rootName: className);
  final code = gen.generate(decoded, partBase: partBase);

  if (outPath != null && outPath.isNotEmpty) {
    final f = File(outPath);
    f.parent.createSync(recursive: true);
    f.writeAsStringSync(code);
    stdout.writeln('已生成: $outPath');
  } else {
    stdout.writeln(code);
  }

  stdout.writeln(
    '\n下一步：\n dart run build_runner build --delete-conflicting-outputs',
  );
  if (decoded is List) {
    stdout.writeln('提示：你的 JSON 顶层是数组，已为数组元素生成 $className 模型。');
  }
}

class _FreezedGenerator {
  _FreezedGenerator({required this.rootName});

  final String rootName;

  // 记录已生成的类名，避免重复
  final Set<String> _generated = <String>{};
  // rawName -> safeName（保证同一个“概念类名”每次拿到的都是同一个最终类名）
  final Map<String, String> _nameMap = <String, String>{};
  final List<_ModelSpec> _models = <_ModelSpec>[];

  String generate(dynamic json, {required String partBase}) {
    // 顶层数组：尽量合并多个元素推断（避免只看第一个导致字段缺失）
    dynamic rootJson = json;
    if (json is List) {
      if (json.isEmpty) {
        rootJson = <String, dynamic>{};
      } else {
        final first = json.first;
        if (first is Map) {
          final maps = json.whereType<Map>().toList();
          rootJson = _mergeMapsForInference(maps);
        } else {
          rootJson = first;
        }
      }
    }

    if (rootJson is! Map) {
      // 顶层不是 object：生成一个包装字段 value
      rootJson = <String, dynamic>{'value': rootJson};
    }

    _buildModel(rootName, rootJson);

    final buf = StringBuffer();
    buf.writeln("import 'package:freezed_annotation/freezed_annotation.dart';");
    buf.writeln();
    buf.writeln("part '$partBase.freezed.dart';");
    buf.writeln("part '$partBase.g.dart';");
    buf.writeln();

    for (final m in _models) {
      buf.writeln('@freezed');
      buf.writeln('sealed class ${m.name} with _\$${m.name} {');
      buf.writeln('  const factory ${m.name}({');
      for (final f in m.fields) {
        final req = f.isRequired ? 'required ' : '';
        buf.writeln('    $req${f.type} ${f.name},');
      }
      buf.writeln('  }) = _${m.name};');
      buf.writeln();
      buf.writeln(
        '  factory ${m.name}.fromJson(Map<String, dynamic> json) => _\$${m.name}FromJson(json);',
      );
      buf.writeln('}');
      buf.writeln();
    }

    return buf.toString();
  }

  String _buildModel(String name, Map json) {
    final safeName = _uniqueClassName(name);
    if (_generated.contains(safeName)) return safeName;
    _generated.add(safeName);

    final fields = <_FieldSpec>[];

    // key 排序：输出稳定
    final keys = json.keys.map((e) => e.toString()).toList()..sort();
    for (final key in keys) {
      final value = json[key];
      final fieldName = _safeFieldName(key);
      final type = _inferType(
        parentClass: safeName,
        fieldName: fieldName,
        value: value,
      );

      // 对 JSON 生成的模型：字段默认可空更安全（JSON 经常缺字段/给 null）
      // 如需严格 required，可后续在业务模型里手动收紧。
      const isRequired = false;

      fields.add(
        _FieldSpec(
          name: fieldName,
          type: type.asNullable,
          isRequired: isRequired,
        ),
      );
    }

    _models.add(_ModelSpec(name: safeName, fields: fields));
    return safeName;
  }

  _DartType _inferType({
    required String parentClass,
    required String fieldName,
    required dynamic value,
  }) {
    if (value == null) return const _DartType('Object?');
    if (value is bool) return const _DartType('bool');
    if (value is int) return const _DartType('int');
    if (value is double) return const _DartType('double');
    if (value is num) return const _DartType('num');
    if (value is String) return const _DartType('String');

    if (value is Map) {
      final nestedName = _pascal('$parentClass ${_pascal(fieldName)}');
      final nestedSafeName = _buildModel(nestedName, value);
      return _DartType(nestedSafeName);
    }

    if (value is List) {
      if (value.isEmpty) return const _DartType('List<dynamic>');

      // 过滤 null 后推断
      final nonNull = value.where((e) => e != null).toList();
      if (nonNull.isEmpty) return const _DartType('List<dynamic>');

      // 全是对象 -> 生成 Item 类
      final allMap = nonNull.every((e) => e is Map);
      if (allMap) {
        final itemName = _itemClassName(
          parentClass: parentClass,
          fieldName: fieldName,
        );
        final maps = nonNull.whereType<Map>().toList();
        final merged = _mergeMapsForInference(maps);
        final itemSafeName = _buildModel(itemName, merged);
        return _DartType('List<$itemSafeName>');
      }

      // 全是同一种标量
      final first = nonNull.first;
      final sameRuntime = nonNull.every(
        (e) => e.runtimeType == first.runtimeType,
      );
      if (sameRuntime) {
        final elemType = _inferType(
          parentClass: parentClass,
          fieldName: fieldName,
          value: first,
        );
        return _DartType('List<${elemType.nonNullable}>');
      }

      return const _DartType('List<dynamic>');
    }

    return const _DartType('dynamic');
  }

  /// 生成列表元素类名的规则（可按需求扩展）：
  /// - 常见的 `Data.list` / `Data.items`：用 `${RootName}Item`（例：BlogPageData.list -> BlogPageItem）
  /// - 否则：保持原先规则 `${ParentClass}${FieldName}Item`
  String _itemClassName({
    required String parentClass,
    required String fieldName,
  }) {
    const commonListNames = {'list', 'items', 'records'};
    final isCommonList = commonListNames.contains(fieldName);
    final isDataContainer =
        parentClass == '${rootName}Data' || parentClass.endsWith('Data');
    if (isCommonList && isDataContainer) {
      return '${rootName}Item';
    }
    return _pascal('$parentClass ${_pascal(fieldName)}Item');
  }

  String _uniqueClassName(String rawName) {
    final existing = _nameMap[rawName];
    if (existing != null) return existing;

    // 让类名只包含字母数字
    var name = rawName.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '');
    name = _pascal(name);
    if (name.isEmpty) name = 'Model';

    final used = <String>{..._generated, ..._nameMap.values};
    if (!used.contains(name)) {
      _nameMap[rawName] = name;
      return name;
    }
    var i = 2;
    while (used.contains('$name$i')) {
      i++;
    }
    final picked = '$name$i';
    _nameMap[rawName] = picked;
    return picked;
  }
}

Map<String, dynamic> _mergeMapsForInference(List<Map> maps) {
  final out = <String, dynamic>{};
  if (maps.isEmpty) return out;

  // Union all keys, stable order is handled in _buildModel.
  for (final m in maps) {
    for (final entry in m.entries) {
      final k = entry.key.toString();
      final v = entry.value;
      // Prefer first non-null sample; otherwise keep null.
      if (!out.containsKey(k) || out[k] == null) {
        out[k] = v;
      }
    }
  }
  return out;
}

class _ModelSpec {
  _ModelSpec({required this.name, required this.fields});
  final String name;
  final List<_FieldSpec> fields;
}

class _FieldSpec {
  _FieldSpec({
    required this.name,
    required this.type,
    required this.isRequired,
  });
  final String name;
  final String type;
  final bool isRequired;
}

class _DartType {
  const _DartType(this._raw);
  final String _raw;

  String get nonNullable => _raw.replaceAll('?', '');
  String get asNullable {
    if (_raw.endsWith('?')) return _raw;
    // List<T> / Map<K,V> 也可以加 ?
    return '$_raw?';
  }
}

String _safeFieldName(String raw) {
  var s = raw.trim();
  if (s.isEmpty) return 'field';

  // 如果 key 本身已经是驼峰（不含分隔符，且包含大写字母），就不要把中间的大写变小写。
  // 例如：blogType / creatorName / updateTime 应保持不变（只保证首字母小写）。
  final hasSeparators = s.contains(RegExp(r'[_-\s]'));
  final looksLikeIdentifier = RegExp(r'^[A-Za-z][A-Za-z0-9]*$').hasMatch(s);
  final hasInnerUpper =
      s.length > 1 && RegExp(r'[A-Z]').hasMatch(s.substring(1));
  if (!hasSeparators && looksLikeIdentifier && hasInnerUpper) {
    s = s[0].toLowerCase() + s.substring(1);
  } else {
    s = s.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    s = s.replaceAll(RegExp(r'_+'), '_');
    if (RegExp(r'^[0-9]').hasMatch(s)) s = 'f_$s';
    s = _camel(s);
  }

  // 关键字简单处理
  const keywords = {
    'class',
    'enum',
    'extends',
    'with',
    'switch',
    'case',
    'default',
    'new',
    'const',
    'final',
    'var',
    'int',
    'double',
    'bool',
    'String',
    'dynamic',
    'return',
    'void',
    'true',
    'false',
    'null',
  };
  if (keywords.contains(s)) s = '${s}Value';
  return s;
}

String _camel(String input) {
  final parts = input
      .split(RegExp(r'[_ -]+'))
      .where((s) => s.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '';
  final head = parts.first.toLowerCase();
  final tail = parts
      .skip(1)
      .map((s) => s[0].toUpperCase() + s.substring(1).toLowerCase())
      .join();
  return '$head$tail';
}

String _pascal(String input) {
  final parts = input
      .split(RegExp(r'[_ -]+'))
      .where((s) => s.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '';
  return parts.map((s) => s[0].toUpperCase() + s.substring(1)).join();
}

String _snake(String input) {
  // BlogItem -> blog_item
  final buf = StringBuffer();
  for (var i = 0; i < input.length; i++) {
    final ch = input[i];
    final isUpper = ch.toUpperCase() == ch && ch.toLowerCase() != ch;
    if (i > 0 && isUpper) buf.write('_');
    buf.write(ch.toLowerCase());
  }
  return buf.toString().replaceAll(RegExp(r'__+'), '_');
}
