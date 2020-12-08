library json_object;

import 'dart:convert';

import 'package:flutter/material.dart';

part 'src/map_extension.dart';
part 'src/list_extension.dart';
part 'src/exception.dart';
part 'src/util.dart';

class JsonObject {
  JsonObject._();

  /// Creates a dynamic(actually a JsonObject) from json string.
  static dynamic fromString(String jsonStr) {
    final decodeResult = json.decode(jsonStr);
    final jsonObject = JsonObject._();

    if (decodeResult is Map) return jsonObject.._map = decodeResult;
    if (decodeResult is List) return jsonObject.._list = decodeResult;
    return jsonObject.._other = decodeResult;
  }

  /// Creates a dynamic(actually a JsonObject) that contains
  /// all the values of the [otherJsonObject].
  static dynamic from(dynamic otherJsonObject) =>
      fromString(otherJsonObject.encode());

  Map _map;
  List _list;
  dynamic _other;
  String get _valueType => getValue().runtimeType.toString();

  void Function(dynamic newValue) _listen;
  void _notify(dynamic newValue) => _listen(newValue);

  static bool isEmpty(JsonObject jsonObject) =>
      jsonObject == null || jsonObject.getValue() == null;
  static bool isNotEmpty(JsonObject jsonObject) => !isEmpty(jsonObject);

  Invocation _invocation;

  /// This is the core magic of json_object.
  /// It uses [invocation] in [noSuchMethod]
  /// to analyze dot access in dynamic object.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    _invocation = invocation;

    if (isGettingMapValue) return getMapValue();
    if (isSettingMapValue) return setMapValue();

    if (isGettingListValue) return getListValue();
    if (isSettingListValue) return setListValue();

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
  dynamic getValue() => _JsonObjectUtil(this).getValue();

  /// Return index list of [_list] if JsonObject inner value [getValue() is List].
  /// For example, if inner value is `["a", "b", "c"]`, then this method
  /// returns `[0, 1, 2]`.
  ///
  /// Return [_map.keys] if JsonObject inner value [getValue() is Map].
  /// For example, if inner value is `{"a": 1, "b": 2, "c": 3}`, then
  /// this method returns `["a", "b", "c"]`.
  ///
  /// Return [_other.toString().split("")] if
  /// JsonObject inner value [_other != null].
  /// For example, if inner value is `"love you"`, then this
  /// method returns `["l", "o", "v", "e", " ", "y", "o", "u"]`
  Iterable get keys => _JsonObjectUtil(this).keys;

  /// Return [_list.length] if JsonObject inner value [getValue() is List].
  /// For example, if inner value is `["a", "b", "c"]`, then this method
  /// returns 3.
  ///
  /// Return [_map.keys.length] if JsonObject inner value [getValue() is Map].
  /// For example, if inner value is `{"a": 1, "b": 2, "c": 3}`, then
  /// this method returns 3, which is the length of [_map.keys],
  /// known as `["a", "b", "c"]`.
  ///
  /// Return [_other.toString().length] if
  /// JsonObject inner value [_other != null].
  /// For example, if inner value is `"love you"`, then this
  /// method returns 8, which is the length of String `"love you"`.
  int get length => _JsonObjectUtil(this).length;

  /// Add a (key, value) pair in [JsonObject].
  ///
  /// If the inner value [getValue() is Map], it adds
  /// a (key, value) pair in [JsonObject].
  ///
  /// If the inner value [getValue() is List], it adds
  /// the value to `[_list[key]]`, this [key]
  /// here represents [index].
  ///
  /// If the inner value [_other != null], it
  /// throws an Exception.
  void add(dynamic key, dynamic value) => _JsonObjectUtil(this).add(key, value);
}
