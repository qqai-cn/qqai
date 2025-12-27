import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/flow.dart';
import '../data/repositories/flow_repository.dart';

// Repository provider
final flowRepositoryProvider = Provider<FlowRepository>((ref) {
  return FlowRepository();
});

// State provider for the list of flow
final flowListProvider = AsyncNotifierProvider<FlowListNotifier, List<Flow>>(() {
  return FlowListNotifier();
});

class FlowListNotifier extends AsyncNotifier<List<Flow>> {
  @override
  Future<List<Flow>> build() async {
    final repository = ref.read(flowRepositoryProvider);
    return await repository.getAllFlows();
  }

  Future<void> addFlow(Flow item) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(flowRepositoryProvider);
      await repository.addFlow(item);
      
      // Refresh the list
      state = AsyncValue.data([...?state.value, item]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateFlow(Flow item) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(flowRepositoryProvider);
      await repository.updateFlow(item);
      
      // Update the list
      final currentList = state.value ?? [];
      final updatedList = currentList.map((existingItem) {
        return existingItem.id == item.id ? item : existingItem;
      }).toList();
      
      state = AsyncValue.data(updatedList);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteFlow(String id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(flowRepositoryProvider);
      await repository.deleteFlow(id);
      
      // Remove from list
      final currentList = state.value ?? [];
      final updatedList = currentList.where((item) => item.id != id).toList();
      
      state = AsyncValue.data(updatedList);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(flowRepositoryProvider);
      final items = await repository.getAllFlows();
      state = AsyncValue.data(items);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Helper method to add sample data
  Future<void> addSampleFlow() async {
    final sampleItem = Flow(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'Sample Flow ${DateTime.now().millisecondsSinceEpoch}',
      description: 'This is a sample flow item',
      createdAt: DateTime.now(),
    );
    
    await addFlow(sampleItem);
  }
}
