part of json_object;

extension _JsonObjectUtil on JsonObject {
  String encodePretty({int indent = 2}) {
    var spaces = ' ' * indent;
    var encoder = JsonEncoder.withIndent(spaces);
    if (isMap) return encoder.convert(_map);
    if (isList) return encoder.convert(_list);
    return encoder.convert(_normalValue);
  }

  String encode() {
    if (isMap) return json.encode(_map);
    if (isList) return json.encode(_list);
    return json.encode(_normalValue);
  }

  Object getValue() {
    if (isMap) return _map;
    if (isList) return _list;
    return _normalValue;
  }

  Iterable get keys {
    if (isMap) return _map.keys;
    if (isList) return List.generate(_list.length, (index) => index);
    if (isNormalValue) return _normalValue.toString().split("");
    throw _JsonObjectException.uncaughtException();
  }

  int get length {
    if (isList) return _list.length;
    if (isMap) return _map.keys.length;
    if (isNormalValue) return _normalValue.toString().length;
    throw _JsonObjectException.uncaughtException();
  }

  void add(Object key, Object value) {
    if (isNormalValue) {
      throw _JsonObjectException.methodInvokeException(
        methodName: "add",
        innerDataType: _innerDataType,
        expectedType: "Map or List",
      );
    }
    if (isMap) return _mapAdd(key, value);
    if (isList) return _listAdd(key, value);
  }
}
