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
    extends $NotifierProvider<CartSession, CartSessionData> {
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
  Override overrideWithValue(CartSessionData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CartSessionData>(value),
    );
  }
}

String _$cartSessionHash() => r'3df0608bbe2c5ab3b86318ccbf9fb42c58818445';

abstract class _$CartSession extends $Notifier<CartSessionData> {
  CartSessionData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<CartSessionData, CartSessionData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CartSessionData, CartSessionData>,
              CartSessionData,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
