// Copyright (C) 2025 Potix Corporation. All Rights Reserved
// History: 2025/4/2 3:52 PM
// Author: jumperchen<jumperchen@potix.com>
import 'dart:js_interop';

bool isString(Object obj) {
  if (obj is String) return true;
  if (obj is JSObject) {
    return obj.isA<JSString>();
  }
  return false;
}
