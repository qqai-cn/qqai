import '../models/flow.dart';

abstract class IFlowRepository {
  Future<List<Flow>> getAllFlows();
  Future<Flow?> getFlowById(String id);
  Future<void> addFlow(Flow item);
  Future<void> updateFlow(Flow item);
  Future<void> deleteFlow(String id);
}

class FlowRepository implements IFlowRepository {
  // In-memory storage for demo purposes
  // Replace with your actual data source (API, Database, etc.)
  final List<Flow> _items = [];

  @override
  Future<List<Flow>> getAllFlows() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return a copy of the list
    return List.from(_items);
  }

  @override
  Future<Flow?> getFlowById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addFlow(Flow item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _items.add(item);
  }

  @override
  Future<void> updateFlow(Flow item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _items.indexWhere((existingItem) => existingItem.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteFlow(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _items.removeWhere((item) => item.id == id);
  }
}
