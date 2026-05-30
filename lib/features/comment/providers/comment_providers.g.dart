// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommentNotifier)
const commentProvider = CommentNotifierProvider._();

final class CommentNotifierProvider
    extends $NotifierProvider<CommentNotifier, CommentState> {
  const CommentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'commentProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$commentNotifierHash();

  @$internal
  @override
  CommentNotifier create() => CommentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommentState>(value),
    );
  }
}

String _$commentNotifierHash() => r'd40c0f8b20f996886f36c1771d36ba5d28dd925e';

abstract class _$CommentNotifier extends $Notifier<CommentState> {
  CommentState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CommentState, CommentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CommentState, CommentState>,
              CommentState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
