// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todolist_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoListNotifier)
const todoListProvider = TodoListNotifierProvider._();

final class TodoListNotifierProvider
    extends $NotifierProvider<TodoListNotifier, TodoListState> {
  const TodoListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListNotifierHash();

  @$internal
  @override
  TodoListNotifier create() => TodoListNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoListState>(value),
    );
  }
}

String _$todoListNotifierHash() => r'285c95db547e1cd7b53e474eb722111aba91bd2e';

abstract class _$TodoListNotifier extends $Notifier<TodoListState> {
  TodoListState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<TodoListState, TodoListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TodoListState, TodoListState>,
              TodoListState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
