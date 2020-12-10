part of json_object;

extension _MapExtension on JsonObject {
  bool get isGettingMapValue => _invocation.isAccessor && _invocation.isGetter;
  dynamic getMapValue() {
    if (getValue() is List) {
      throw _JsonObjectException.getValueException(
        innerDataType: "List",
        expectedType: "Map",
      );
    }

    var key = _memberNameStr;
    if (!_map.keys.contains(key)) {
      print(_JsonObjectException.noSuchKeyException(key: key));
    }

    var valueStr = json.encode(_map[key]);
    return JsonObject.fromString(valueStr)
      .._listen = (newValue) => _map[key] = newValue;
  }

  bool get isSettingMapValue => _invocation.isAccessor && _invocation.isSetter;
  void setMapValue() {
    if (getValue() is List) {
      throw _JsonObjectException.setValueException(
        innerDataType: "List",
        expectedType: "Map",
      );
    }

    var key = _memberNameStr;
    var value = _invocation.positionalArguments.first;
    _map[key] = value;
    _notify(_map);
  }

  void _mapAdd(dynamic key, dynamic value) {
    if (key is int) {
      throw _JsonObjectException.methodInvokeException(
        methodName: "add",
        innerDataType: _valueType,
        expectedType: "List",
      );
    }

    if (key is! String) {
      throw _JsonObjectException.uncaughtException(
        suggestion: "This might be caused by "
            "`key` runtimeType: ${key.runtimeType} "
            "and `value` runtimeType: ${value.runtimeType}. "
            "This is quite a weired problem since generally "
            "you won't be able to set a (key, value) pair in "
            "a json object like that.",
      );
    }

    _map[key] = value;
    _notify(_map);
  }

  void _mapAddAll(dynamic otherJsonObject) {
    if (otherJsonObject.getValue() is! Map) {
      throw _JsonObjectException.methodInvokeException(
        methodName: "addAll",
        innerDataType: _valueType,
        expectedType: otherJsonObject.getValue().runtimeType.toString(),
      );
    }

    final copyJsonObject = JsonObject.from(otherJsonObject);
    _map.addAll(copyJsonObject.getValue());
    _notify(_map);
  }
}
