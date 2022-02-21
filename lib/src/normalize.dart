import 'schema.dart';

dynamic normalize(dynamic json, Entity schema) {
  final result = <String, dynamic>{};
  void accumulator(String name, String key, dynamic entity) {
    result[name][key] = entity;
  }

  _normalize(json, schema, accumulator);

  return result;
}

void _normalize(dynamic json, Entity schema, AccumulatorCallback accumulator) {
  
}

typedef AccumulatorCallback = void Function(
    String name, String key, dynamic entity);
