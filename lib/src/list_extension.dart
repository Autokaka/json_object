part of json_object;

extension _ListExtension on JsonObject {
  bool get _isGetListValue =>
      _invocation.isMethod && !_invocation.memberName.toString().contains(r'=');
  dynamic get _listValue {
    if (isMap) {
      throw _JsonObjectException.getValueException(
        innerDataType: "Map",
        expectedType: "List",
      );
    }

    int index = _invocation.positionalArguments.first;
    if (index >= _list.length) {
      throw _JsonObjectException.listOutOfRangeException(
        index: index,
        length: _list.length,
      );
    }

    var valueStr = json.encode(_list[index]);
    var child = JsonObject()
      .._listen = (newValue) {
        _list[index] = newValue;
      };
    return child.fromString(valueStr);
  }

  bool get _isSetListValue =>
      _invocation.isMethod && _invocation.memberName.toString().contains(r'=');
  void _setListValue() {
    if (isMap) {
      throw _JsonObjectException.setValueException(
        innerDataType: "Map",
        expectedType: "List",
      );
    }

    int index = _invocation.positionalArguments.first;
    var value = _invocation.positionalArguments.last;
    if (index >= _list.length) {
      throw _JsonObjectException.listOutOfRangeException(
        index: index,
        length: _list.length,
      );
    }

    _list[index] = value;
    _listen?.call(_list);
  }

  void _listAdd(Object key, Object value) {
    if (key is! int) {
      throw _JsonObjectException.methodInvokeException(
        methodName: "add",
        innerDataType: _innerDataType,
        expectedType: "Map",
      );
    }

    _list.add(value);
    _listen?.call(_list);
    return;
  }
}
