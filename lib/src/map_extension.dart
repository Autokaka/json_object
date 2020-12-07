part of json_object;

extension _MapExtension on JsonObject {
  bool get _isGetMapValue => _invocation.isAccessor && _invocation.isGetter;
  dynamic get _mapValue {
    if (isList) {
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
    var child = JsonObject()
      .._listen = (newValue) {
        _map[key] = newValue;
      };
    return child.fromString(valueStr);
  }

  bool get _isSetMapValue => _invocation.isAccessor && _invocation.isSetter;
  void _setMapValue() {
    if (isList) {
      throw _JsonObjectException.setValueException(
        innerDataType: "List",
        expectedType: "Map",
      );
    }

    var key = _memberNameStr;
    var value = _invocation.positionalArguments.first;
    _map[key] = value;
    _listen?.call(_map);
  }

  void _mapAdd(Object key, Object value) {
    if (key is int) {
      throw _JsonObjectException.methodInvokeException(
        methodName: "add",
        innerDataType: _innerDataType,
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
    _listen?.call(_map);
  }
}
