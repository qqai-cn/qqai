import 'package:web/web.dart' as web;

/// Pushes a same-URL history entry so the next browser/gesture back is consumed
/// locally (e.g. closing an in-page overlay) without leaving the current route.
void pushBrowserHistoryOverlay() {
  final href = web.window.location.href;
  web.window.history.pushState(null, '', href);
}
