import '../models/index.dart';

abstract class IIndexRepository {
  Future<List<Index>> getAllIndexs();
  Future<Index?> getIndexById(String id);
  Future<void> addIndex(Index item);
  Future<void> updateIndex(Index item);
  Future<void> deleteIndex(String id);
}

class IndexRepository implements IIndexRepository {
  // In-memory storage for demo purposes
  // Replace with your actual data source (API, Database, etc.)
  final List<Index> _items = [];

  @override
  Future<List<Index>> getAllIndexs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return a copy of the list
    return List.from(_items);
  }

  @override
  Future<Index?> getIndexById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addIndex(Index item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _items.add(item);
  }

  @override
  Future<void> updateIndex(Index item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final index = _items.indexWhere((existingItem) => existingItem.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteIndex(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    _items.removeWhere((item) => item.id == id);
  }
}
