part of json_object;

extension _JsonObjectUtil on JsonObject {
  String encodePretty({int indent = 2}) {
    var spaces = ' ' * indent;
    var encoder = JsonEncoder.withIndent(spaces);
    if (getValue() is Map) return encoder.convert(_map);
    if (getValue() is List) return encoder.convert(_list);
    return encoder.convert(_other);
  }

  String encode() {
    if (getValue() is Map) return json.encode(_map);
    if (getValue() is List) return json.encode(_list);
    return json.encode(_other);
  }

  dynamic getValue() => _map ?? _list ?? _other;

  Iterable get keys {
    if (getValue() is Map) return _map.keys;
    if (getValue() is List)
      return List.generate(_list.length, (index) => index);
    return _other.toString().split("");
  }

  int get length {
    if (getValue() is List) return _list.length;
    if (getValue() is Map) return _map.keys.length;
    return _other.toString().length;
  }

  void add(dynamic key, dynamic value) {
    if (_other != null) {
      throw _JsonObjectException.methodInvokeException(
        methodName: "add",
        innerDataType: _valueType,
        expectedType: "Map or List",
      );
    }
    if (getValue() is Map) return _mapAdd(key, value);
    if (getValue() is List) return _listAdd(key, value);
  }
}
