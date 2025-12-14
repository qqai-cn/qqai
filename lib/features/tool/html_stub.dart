// Stub file for dart:html when running on non-web platforms
// This file provides empty implementations to avoid import errors

class Blob {
  Blob(List<dynamic> data);
}

class Url {
  static String createObjectUrlFromBlob(Blob blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  AnchorElement({String? href});
  void setAttribute(String name, String value) {}
  void click() {}
}

