// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_session.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CartSession)
const cartSessionProvider = CartSessionProvider._();

final class CartSessionProvider
    extends $NotifierProvider<CartSession, List<CartLine>> {
  const CartSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartSessionHash();

  @$internal
  @override
  CartSession create() => CartSession();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CartLine> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CartLine>>(value),
    );
  }
}

String _$cartSessionHash() => r'b0d41554afba3a54d1ecaa5ddf77f87189a31763';

abstract class _$CartSession extends $Notifier<List<CartLine>> {
  List<CartLine> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<CartLine>, List<CartLine>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CartLine>, List<CartLine>>,
              List<CartLine>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
