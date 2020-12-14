import 'package:flutter/material.dart';

class JsonObjectException {
  const JsonObjectException._();

  static String standardError(String message) {
    return "JsonObject: $message";
  }

  static String noSuchKeyException({
    @required String key,
  }) {
    return standardError(
      "NoSuchKeyException. key: $key",
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

  static String uncaughtException({String suggestion = ""}) {
    return standardError(
      "UncaughtException. "
      "$suggestion "
      "Please feel free to give an Issue at: "
      "https://github.com/Autokaka/json_object",
    );
  }
}
