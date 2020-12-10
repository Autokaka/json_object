part of json_object;

class _JsonObjectException {
  const _JsonObjectException._();

  static String standardError(String message) {
    return "EasyJson: $message";
  }

  static String noSuchKeyException({
    @required String key,
  }) {
    return standardError(
      "NoSuchKeyException. key: $key",
    );
  }

  static String listOutOfRangeException({
    @required int index,
    @required int length,
  }) {
    return standardError(
      "ListOutOfRangeException. "
      "Getting index: $index, "
      "but list length: $length",
    );
  }

  static String getValueException({
    @required String innerDataType,
    @required String expectedType,
  }) {
    return standardError(
      "GetValueException. "
      "Trying to get value in a $innerDataType, "
      "while this `get` method is available only for $expectedType.",
    );
  }

  static String setValueException({
    @required String innerDataType,
    @required String expectedType,
  }) {
    return standardError(
      "GetValueException. "
      "Trying to set value in a $innerDataType, "
      "while this `set` method is available only for $expectedType.",
    );
  }

  static String methodInvokeException({
    @required String methodName,
    @required String innerDataType,
    @required String expectedType,
    String suggestion = "",
  }) {
    return standardError(
      "MethodInvokeException. "
      "Invoking: $methodName in a $innerDataType "
      "by introducing a(n) $expectedType. "
      "$suggestion.",
    );
  }

  static String uncaughtException({String suggestion = ""}) {
    return standardError(
      "UncaughtException. "
      "$suggestion "
      "Please feel free to give an Issue at: "
      "https://github.com/Autokaka/json_object",
    );
  }
}
