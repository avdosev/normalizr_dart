import 'entity.dart';
import 'normalize.dart' as n;

class Normalizr {
  Normalizr([List<Entity> entities = const []]) {
    entities.forEach(add);
  }

  final _schemas = <String, Entity>{};

  void add(Entity schema) {
    _schemas[schema.name] = schema;
  }

  void addAll(Iterable<Entity> schemas) => schemas.forEach(add);

  void clear() => _schemas.clear();

  Entity find(String name) {
    final schema = _schemas[name];
    if (schema == null) {
      throw UnsupportedError('schema with name:$name not found');
    }
    return schema;
  }

  dynamic normalize(dynamic json, Entity schema) {
    final result = <dynamic, dynamic>{};
    void accumulator(String name, dynamic key, dynamic entity) {
      result[name] ??= {};
      result[name][key] = entity;
    }

    final id = n.normalize(json, schema, accumulator, find);
    return {
      'result': id,
      'type': schema.name,
      'entities': result,
    };
  }
}
