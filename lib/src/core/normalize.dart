import 'schema.dart';
import 'entity.dart';

dynamic /*String|Int*/ normalize(Map json, Entity schema,
    AccumulatorCallback accumulator, SchemeFinder find) {
  final result = <dynamic, dynamic>{};
  for (final field in json.entries) {
    if (schema.definition.containsKey(field.key)) {
      final define = schema.definition[field.key]!;

      if (define is SchemaList) {
        final entities = field.value as List;
        final ids = define.doCallback(
          entities,
          (json, nextScheme) {
            final entity = nextScheme.getEntity(json, find);
            return nextScheme.useId(
              normalize(json, entity, accumulator, find),
              entity,
            );
          },
        );
        result[field.key] = ids;
      } else if (define is Schema) {
        final entity = field.value;
        final nextScheme = define.getEntity(entity, find);
        final id = normalize(entity, nextScheme, accumulator, find);
        result[field.key] = define.useId(id, nextScheme);
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
  dynamic key,
  dynamic entity,
);

typedef SchemeFinder = Entity Function(String name);
