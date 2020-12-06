library json_object;

import 'dart:convert';

import 'package:flutter/material.dart';

part 'src/map_extension.dart';
part 'src/list_extension.dart';
part 'src/exception.dart';

class JsonObject {
  Invocation _invocation;

  Map _map;
  bool get isMap => _map != null;
  List _list;
  bool get isList => _list != null;
  Object _normalValue;
  bool get isNormalValue => _normalValue != null;

  void Function(Object newValue) _listen;

  Object getValue() {
    if (isMap) return _map;
    if (isList) return _list;
    return _normalValue;
  }

  dynamic fromString(String jsonStr) {
    var decodeResult = json.decode(jsonStr);

    if (decodeResult is Map) {
      _map = decodeResult;
      return this;
    }
    if (decodeResult is List) {
      _list = decodeResult;
      return this;
    }
    _normalValue = decodeResult;
    return this;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    _invocation = invocation;

    if (_isGetMapValue) return _mapValue;
    if (_isSetMapValue) return _setMapValue();

    if (_isGetListValue) return _listValue;
    if (_isSetListValue) return _setListValue();

    throw _JsonObjectException.uncaughtException();
  }

  String get _memberNameStr {
    var symbolStr = _invocation.memberName.toString();
    var equalsStr = symbolStr.contains(r'=') ? '=' : '';
    var keyReg = RegExp(r'Symbol\(\"(.*)' + equalsStr + r'\"\)');
    var match = keyReg.firstMatch(symbolStr);
    return match.group(1);
  }
}
