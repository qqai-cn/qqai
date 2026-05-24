class AppAreaNode {
  const AppAreaNode({
    required this.id,
    required this.name,
    this.children = const [],
  });

  final int id;
  final String name;
  final List<AppAreaNode> children;

  factory AppAreaNode.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] as List<dynamic>?;
    return AppAreaNode(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String? ?? '',
      children: rawChildren
              ?.map((e) => AppAreaNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class AreaPickResult {
  const AreaPickResult({required this.areaId, required this.label});

  final int areaId;
  final String label;
}

/// 在地区树中查找 [areaId] 对应的路径（省 → 市 → 区）
List<AppAreaNode>? findAreaPath(List<AppAreaNode> roots, int areaId) {
  for (final root in roots) {
    final path = _findPathFromNode(root, areaId, []);
    if (path != null) return path;
  }
  return null;
}

List<AppAreaNode>? _findPathFromNode(
  AppAreaNode node,
  int areaId,
  List<AppAreaNode> prefix,
) {
  final current = [...prefix, node];
  if (node.id == areaId) return current;
  for (final child in node.children) {
    final found = _findPathFromNode(child, areaId, current);
    if (found != null) return found;
  }
  return null;
}

String formatAreaLabel(List<AppAreaNode> path, {bool includeChina = true}) {
  if (path.isEmpty) return '';
  final names = path.map((e) => e.name).where((n) => n.isNotEmpty);
  if (includeChina) {
    return '中国 · ${names.join(' · ')}';
  }
  return names.join(' · ');
}

/// 将后端返回的空格分隔地址转为展示用「 · 」分隔
String formatAddressForDisplay(String? address, {String empty = '未设置'}) {
  if (address == null || address.trim().isEmpty) return empty;
  final trimmed = address.trim();
  if (trimmed.contains('·')) return trimmed;
  return trimmed.replaceAll(RegExp(r'\s+'), ' · ');
}
