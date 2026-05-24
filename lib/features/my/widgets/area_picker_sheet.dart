import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/area_models.dart';

/// 宽屏（平板 / Web）下底部弹层内容最大宽度
const double kAreaPickerMaxWidth = 600;

/// 省 / 市 / 区 三级地区选择（对标抖音编辑主页）
Future<AreaPickResult?> showAreaPickerSheet(
  BuildContext context, {
  required List<AppAreaNode> provinces,
  int? initialAreaId,
}) {
  return showModalBottomSheet<AreaPickResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kAreaPickerMaxWidth),
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: _AreaPickerSheet(
              provinces: provinces,
              initialAreaId: initialAreaId,
            ),
          ),
        ),
      ),
    ),
  );
}

class _AreaPickerSheet extends StatefulWidget {
  const _AreaPickerSheet({
    required this.provinces,
    this.initialAreaId,
  });

  final List<AppAreaNode> provinces;
  final int? initialAreaId;

  @override
  State<_AreaPickerSheet> createState() => _AreaPickerSheetState();
}

class _AreaPickerSheetState extends State<_AreaPickerSheet> {
  late int _provinceIndex;
  late int _cityIndex;
  late int _districtIndex;

  FixedExtentScrollController? _provinceCtrl;
  FixedExtentScrollController? _cityCtrl;
  FixedExtentScrollController? _districtCtrl;

  @override
  void initState() {
    super.initState();
    _provinceIndex = 0;
    _cityIndex = 0;
    _districtIndex = 0;

    if (widget.initialAreaId != null) {
      final path = findAreaPath(widget.provinces, widget.initialAreaId!);
      if (path != null && path.isNotEmpty) {
        _provinceIndex = widget.provinces.indexWhere((p) => p.id == path[0].id);
        if (_provinceIndex < 0) _provinceIndex = 0;
        final cities = _citiesForProvince(_provinceIndex);
        if (path.length > 1 && cities.isNotEmpty) {
          _cityIndex = cities.indexWhere((c) => c.id == path[1].id);
          if (_cityIndex < 0) _cityIndex = 0;
          final districts = _districtsFor(_provinceIndex, _cityIndex);
          if (path.length > 2 && districts.isNotEmpty) {
            _districtIndex = districts.indexWhere((d) => d.id == path[2].id);
            if (_districtIndex < 0) _districtIndex = 0;
          }
        }
      }
    }

    _provinceCtrl = FixedExtentScrollController(initialItem: _provinceIndex);
    _cityCtrl = FixedExtentScrollController(initialItem: _cityIndex);
    _districtCtrl = FixedExtentScrollController(initialItem: _districtIndex);
  }

  @override
  void dispose() {
    _provinceCtrl?.dispose();
    _cityCtrl?.dispose();
    _districtCtrl?.dispose();
    super.dispose();
  }

  List<AppAreaNode> _citiesForProvince(int provinceIndex) {
    if (widget.provinces.isEmpty) return const [];
    final p = widget.provinces[provinceIndex.clamp(0, widget.provinces.length - 1)];
    return p.children;
  }

  List<AppAreaNode> _districtsFor(int provinceIndex, int cityIndex) {
    final cities = _citiesForProvince(provinceIndex);
    if (cities.isEmpty) return const [];
    final c = cities[cityIndex.clamp(0, cities.length - 1)];
    return c.children;
  }

  void _onProvinceChanged(int index) {
    setState(() {
      _provinceIndex = index;
      _cityIndex = 0;
      _districtIndex = 0;
    });
    _cityCtrl?.jumpToItem(0);
    _districtCtrl?.jumpToItem(0);
  }

  void _onCityChanged(int index) {
    setState(() {
      _cityIndex = index;
      _districtIndex = 0;
    });
    _districtCtrl?.jumpToItem(0);
  }

  AreaPickResult? _buildResult() {
    if (widget.provinces.isEmpty) return null;
    final province = widget.provinces[_provinceIndex];
    final path = <AppAreaNode>[province];
    final cities = _citiesForProvince(_provinceIndex);
    if (cities.isNotEmpty) {
      final city = cities[_cityIndex.clamp(0, cities.length - 1)];
      path.add(city);
      final districts = _districtsFor(_provinceIndex, _cityIndex);
      if (districts.isNotEmpty) {
        path.add(districts[_districtIndex.clamp(0, districts.length - 1)]);
      }
    }
    final leaf = path.last;
    return AreaPickResult(
      areaId: leaf.id,
      label: formatAreaLabel(path),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required List<AppAreaNode> items,
    required ValueChanged<int> onSelected,
  }) {
    if (items.isEmpty) {
      return const Center(child: Text('—'));
    }
    return CupertinoPicker(
      scrollController: controller,
      itemExtent: 36,
      onSelectedItemChanged: onSelected,
      children: items
          .map((e) => Center(
                child: Text(
                  e.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cities = _citiesForProvince(_provinceIndex);
    final districts = _districtsFor(_provinceIndex, _cityIndex);

    return SafeArea(
      child: SizedBox(
        height: 320,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    final result = _buildResult();
                    Navigator.pop(context, result);
                  },
                  child: const Text('确定'),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _wheel(
                      controller: _provinceCtrl!,
                      items: widget.provinces,
                      onSelected: _onProvinceChanged,
                    ),
                  ),
                  Expanded(
                    child: _wheel(
                      controller: _cityCtrl!,
                      items: cities,
                      onSelected: _onCityChanged,
                    ),
                  ),
                  Expanded(
                    child: _wheel(
                      controller: _districtCtrl!,
                      items: districts,
                      onSelected: (i) => setState(() => _districtIndex = i),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
