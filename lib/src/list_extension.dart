part of json_object;

extension _ListExtension on JsonObject {
  bool get isGettingListValue =>
      _invocation.isMethod && !_invocation.memberName.toString().contains(r'=');
  dynamic getListValue() {
    if (getValue() is Map) {
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
    return JsonObject.fromString(valueStr)
      .._listen = (newValue) => _list[index] = newValue;
  }

  bool get isSettingListValue =>
      _invocation.isMethod && _invocation.memberName.toString().contains(r'=');
  void setListValue() {
    if (getValue() is Map) {
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
    _notify(_list);
  }

  void _listAdd(dynamic key, dynamic value) {
    if (key is! int) {
      throw _JsonObjectException.methodInvokeException(
        methodName: "add",
        innerDataType: _valueType,
        expectedType: "Map",
      );
    }

    _list.add(value);
    _notify(_list);
  }
}
