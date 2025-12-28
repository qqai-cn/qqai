import '../models/flow_model.dart';

abstract class IFlowRepository {
  Future<List<FlowModel>> getAllFlows();
  Future<FlowModel?> getFlowById(String id);
  Future<void> addFlow(FlowModel item);
  Future<void> updateFlow(FlowModel item);
  Future<void> deleteFlow(String id);
}

class FlowRepository implements IFlowRepository {
  final List<FlowModel> _items = [];

  @override
  Future<List<FlowModel>> getAllFlows() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_items);
  }

  @override
  Future<FlowModel?> getFlowById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> addFlow(FlowModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.add(item);
  }

  @override
  Future<void> updateFlow(FlowModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _items.indexWhere((existing) => existing.id == item.id);
    if (index != -1) _items[index] = item;
  }

  @override
  Future<void> deleteFlow(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((item) => item.id == id);
  }
}
