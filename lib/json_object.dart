library json_object;

import 'dart:convert';
import 'exception.dart';

export 'dart:convert';

class JsonObject {
  JsonObject._();

  /// Creates a dynamic(actually a JsonObject) from json string.
  static dynamic decode(String jsonStr) {
    final jsonObject = JsonObject._();
    final decodeResult = json.decode(jsonStr);
    if (decodeResult is Map) return fromMap(decodeResult);
    if (decodeResult is List) return fromList(decodeResult);
    return jsonObject.._other = decodeResult;
  }

  /// Creates a dynamic(actually a JsonObject) that contains
  /// all the values of the [otherJsonObject].
  static dynamic from(JsonObject otherJsonObject) {
    final value = otherJsonObject.getValue();
    if (value is Map) return fromMap(value);
    if (value is List) return fromList(value);
    return JsonObject._().._other = value;
  }

  /// Creates a dynamic(actually a JsonObject) from Map.
  static dynamic fromMap(Map map) => JsonObject._().._map = Map.from(map);

  /// Creates a dynamic(actually a JsonObject) from List.
  static dynamic fromList(List list) => JsonObject._().._list = List.from(list);

  Map _map;
  List _list;
  dynamic _other;

  void Function(dynamic newValue) _listen;
  void _notify(dynamic newValue) => _listen?.call(newValue);

  static bool isEmpty(JsonObject jsonObject) =>
      jsonObject == null || jsonObject.getValue() == null;
  static bool isNotEmpty(JsonObject jsonObject) => !isEmpty(jsonObject);

  /// This is the core magic of json_object.
  /// It uses [invocation] in [noSuchMethod]
  /// to analyze dot access in dynamic object.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (!invocation.isAccessor) {
      throw JsonObjectException.uncaughtException();
    }

    String getMemberName() {
      var symbolStr = invocation.memberName.toString();
      var equalsStr = symbolStr.contains(r'=') ? '=' : '';
      var keyReg = RegExp(r'Symbol\(\"(.*)' + equalsStr + r'\"\)');
      var match = keyReg.firstMatch(symbolStr);
      return match.group(1);
    }

    if (invocation.isSetter) {
      if (_map == null && _list != null || _other != null) {
        throw JsonObjectException.setValueException(
          innerDataType: valueRuntimeType.toString(),
          expectedType: 'Map',
        );
      }

      var key = getMemberName();
      var value = invocation.positionalArguments.first;
      if (value is JsonObject) value = value.getValue();
      _map ??= {};
      _map[key] = value;
      _notify(_map);
    }

    if (invocation.isGetter) {
      if (_map == null && _list != null || _other != null) {
        throw JsonObjectException.getValueException(
          innerDataType: valueRuntimeType.toString(),
          expectedType: 'Map',
        );
      }

      var key = getMemberName();

      if (_map == null) {
        return JsonObject._()
          .._listen = (newValue) {
            _map = {key: newValue};
          };
      }

      if (!_map.keys.contains(key)) {
        print(JsonObjectException.noSuchKeyException(key: key));
      }

      final jsonStr = json.encode(_map[key]);
      return JsonObject.decode(jsonStr)
        .._listen = (newValue) => _map[key] = newValue;
    }
  }

  dynamic operator [](dynamic key) {
    if (_other != null) {
      throw JsonObjectException.getValueException(
        innerDataType: _other.runtimeType.toString(),
        expectedType: 'Map or List',
      );
    }

    final jsonStr = json.encode(getValue()[key]);
    return JsonObject.decode(jsonStr)
      .._listen = (newValue) {
        if (getValue() is Map) {
          _map[key] = newValue;
        } else {
          _list[key] = newValue;
        }
      };
  }

  void operator []=(dynamic key, dynamic value) {
    if (_other != null) {
      throw JsonObjectException.setValueException(
        innerDataType: _other.runtimeType.toString(),
        expectedType: 'Map or List',
      );
    }

    if (value is JsonObject) value = value.getValue();

    if (getValue() is Map) {
      _map[key] = value;
      _notify(_map);
    } else {
      _list[key] = value;
      _notify(_list);
    }
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
  static String encodePretty(
    JsonObject jsonObject, {
    int indent = 2,
  }) {
    var spaces = ' ' * indent;
    var encoder = JsonEncoder.withIndent(spaces);
    return encoder.convert(jsonObject.getValue());
  }

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
  T getValue<T>() => (_map ?? _list ?? _other) as T;
  Type get valueRuntimeType => getValue().runtimeType;

  void apply<T>(T f(T value)) {
    final newValue = f?.call(getValue<T>());
    _notify(newValue);
  }
}
