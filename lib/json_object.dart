library json_object;

import 'dart:convert';

import 'package:flutter/material.dart';

part 'src/map_extension.dart';
part 'src/list_extension.dart';
part 'src/exception.dart';
part 'src/util.dart';

class JsonObject {
  Invocation _invocation;

  Map _map;
  bool get isMap => _map != null;
  List _list;
  bool get isList => _list != null;
  Object _normalValue;
  bool get isNormalValue => _normalValue != null;
  String get _innerDataType {
    if (isMap) return _map.runtimeType.toString();
    if (isList) return _list.runtimeType.toString();
    return _normalValue.runtimeType.toString();
  }

  void Function(Object newValue) _listen;

  static bool isEmpty(JsonObject jsonObject) {
    return jsonObject == null ||
        jsonObject._map == null &&
            jsonObject._list == null &&
            jsonObject._normalValue == null;
  }

  static bool isNotEmpty(JsonObject jsonObject) => !isEmpty(jsonObject);

  /// Creates a dynamic(actually a JsonObject) from json string.
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

  /// Creates a dynamic(actually a JsonObject) that contains
  /// all the values of the [otherObject].
  dynamic from(JsonObject otherObject) => fromString(otherObject.encode());

  /// This is the core magic of json_object.
  /// It uses [invocation] in [noSuchMethod]
  /// to analyze dot access in dynamic object.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    _invocation = invocation;

    if (_isGetMapValue) return _mapValue;
    if (_isSetMapValue) return _setMapValue();

    if (_isGetListValue) return _listValue;
    if (_isSetListValue) return _setListValue();

    throw _JsonObjectException.uncaughtException();
  }

  /// Retrieve name string from [_invocation.memberName]
  /// (known as a Symbol).
  ///
  /// For example, [_invocation.memberName] is [Symbol("url")].
  /// This method will extract the [name] of that [Symbol]
  /// (Symbol("url").name -> "url")
  String get _memberNameStr {
    var symbolStr = _invocation.memberName.toString();
    var equalsStr = symbolStr.contains(r'=') ? '=' : '';
    var keyReg = RegExp(r'Symbol\(\"(.*)' + equalsStr + r'\"\)');
    var match = keyReg.firstMatch(symbolStr);
    return match.group(1);
  }

  /// Convert this [JsonObject] to a intuitive [String].
  ///
  /// For example, the json string
  /// encoded will be like this:
  /// ```Dart
  /// "{
  ///   "url": "https://baidu.com",
  ///   "name": "baidu"
  /// }"
  /// ```
  /// rather than this:
  /// ```Dart
  /// "{"url":"https://baidu.com","name":"baidu"}"
  /// ```
  String encodePretty({int indent = 2}) =>
      _JsonObjectUtil(this).encodePretty(indent: indent);

  /// Convert this [JsonObject] to a normal [String].
  String encode() => _JsonObjectUtil(this).encode();

  /// Get the value of this [JsonObject].
  ///
  /// Please note that every time you need to access the **real
  /// value** of this [JsonObject], you must call [getValue()]
  /// method. This will help you extract inner value from this
  /// [JsonObject] as well as its real value [runtimeType].
  ///
  /// For example, if you want to extract "baidu"
  /// in [jsonObject.name]
  /// ```JSON
  /// {
  ///   "url": "https://baidu.com",
  ///   "name": "baidu"
  /// }
  /// ```
  /// then you **MUST call [jsonObject.name.getValue()]** rather than
  /// [jsonObject.name]. Also note that you only need to call [getValue()]
  /// at the end of the value, which means you can't use
  /// [jsonObject.getValue().name.getValue()] to get the value.
  Object getValue() => _JsonObjectUtil(this).getValue();

  /// Return index list of [_list] if JsonObject inner value [isList].
  /// For example, if inner value is `["a", "b", "c"]`, then this method
  /// returns `[0, 1, 2]`.
  ///
  /// Return [_map.keys] if JsonObject inner value [isMap].
  /// For example, if inner value is `{"a": 1, "b": 2, "c": 3}`, then
  /// this method returns `["a", "b", "c"]`.
  ///
  /// Return [_normalValue.toString().split("")] if
  /// JsonObject inner value [isNormalValue].
  /// For example, if inner value is `"love you"`, then this
  /// method returns `["l", "o", "v", "e", " ", "y", "o", "u"]`
  Iterable get keys => _JsonObjectUtil(this).keys;

  /// Return [_list.length] if JsonObject inner value [isList].
  /// For example, if inner value is `["a", "b", "c"]`, then this method
  /// returns 3.
  ///
  /// Return [_map.keys.length] if JsonObject inner value [isMap].
  /// For example, if inner value is `{"a": 1, "b": 2, "c": 3}`, then
  /// this method returns 3, which is the length of [_map.keys],
  /// known as `["a", "b", "c"]`.
  ///
  /// Return [_normalValue.toString().length] if
  /// JsonObject inner value [isNormalValue].
  /// For example, if inner value is `"love you"`, then this
  /// method returns 8, which is the length of String `"love you"`.
  int get length => _JsonObjectUtil(this).length;

  /// Add a (key, value) pair in [JsonObject].
  ///
  /// If the inner value [isMap], it adds
  /// a (key, value) pair in [JsonObject].
  ///
  /// If the inner value [isList], it adds
  /// the value to `[_list[key]]`, this [key]
  /// here represents [index].
  ///
  /// If the inner value [isNormalValue], it
  /// throws an Exception.
  void add(Object key, Object value) => _JsonObjectUtil(this).add(key, value);
}
