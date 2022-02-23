import 'schema.dart';

String normalize(Map<String, dynamic> json, Entity schema,
    AccumulatorCallback accumulator, SchemeFinder find) {
  final result = <String, dynamic>{};
  for (final field in json.entries) {
    if (schema.definition.containsKey(field.key)) {
      if (schema.definition[field.key]!.array) {
        final entities = field.value as List;
        final ids = entities
            .map(
              (entity) => normalize(
                entity,
                find(schema.definition[field.key]!.name),
                accumulator,
                find,
              ),
            )
            .toList();
        result[field.key] = ids;
      } else {
        final entity = field.value;
        final id = normalize(
          entity,
          find(schema.definition[field.key]!.name),
          accumulator,
          find,
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
  String name,
  String key,
  dynamic entity,
);

typedef SchemeFinder = Entity Function(String name);
