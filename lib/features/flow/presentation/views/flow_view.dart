import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/flow_provider.dart';

class FlowView extends ConsumerWidget {
  const FlowView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flowList = ref.watch(flowListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flow'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: flowList.when(
        data: (items) => items.isEmpty
            ? const Center(
                child: Text(
                  'No flow found',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('ID: ${item.id}'),
                    leading: const Icon(Icons.folder),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(flowListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new flow item
          ref.read(flowListProvider.notifier).addSampleFlow();
        },
        tooltip: 'Add Flow',
        child: const Icon(Icons.add),
      ),
    );
  }
}
