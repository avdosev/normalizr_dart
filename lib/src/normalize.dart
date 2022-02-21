import 'schema.dart';

dynamic normalize(dynamic json, Entity schema) {
  final result = <String, dynamic>{};
  void accumulator(String name, String key, dynamic entity) {
    result[name] ??= {};
    result[name][key] = entity;
  }

  final id = _normalize(json as Map<String, dynamic>, schema, accumulator);
  return {
    'result': id,
    'type': schema.name,
    'entities': result,
  };
}

Entity findEntitySchemeByName(String name) {
  final schema = Entities.I.find(name);
  if (schema == null) {
    throw UnimplementedError('schema with name:$name not found');
  }
  return schema;
}

String _normalize(
  Map<String, dynamic> json,
  Entity schema,
  AccumulatorCallback accumulator,
) {
  final result = <String, dynamic>{};
  for (final field in json.entries) {
    if (schema.definition.containsKey(field.key)) {
      if (schema.definition[field.key]!.array) {
        final entities = field.value as List;
        final ids = entities
            .map(
              (entity) => _normalize(
                entity,
                findEntitySchemeByName(schema.definition[field.key]!.name),
                accumulator,
              ),
            )
            .toList();
        result[field.key] = ids;
      } else {
        final entity = field.value;
        final id = _normalize(
          entity,
          findEntitySchemeByName(schema.definition[field.key]!.name),
          accumulator,
        );
        result[field.key] = id;
      }
    } else {
      result[field.key] = field.value;
    }
  }
  accumulator(schema.name, json[schema.options.id], result);
  return json[schema.options.id];
}

typedef AccumulatorCallback = void Function(
    String name, String key, dynamic entity);
