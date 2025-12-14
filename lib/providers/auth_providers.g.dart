// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthNotifier)
const authProvider = AuthNotifierProvider._();

final class AuthNotifierProvider
    extends $NotifierProvider<AuthNotifier, AuthState> {
  const AuthNotifierProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authNotifierHash();

  @$internal
  @override
  AuthNotifier create() => AuthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authNotifierHash() => r'87ae40ca3cb5cd6db54009143771b58697d95bdc';

abstract class _$AuthNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AuthState, AuthState>, AuthState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
