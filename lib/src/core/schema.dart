import 'entity.dart';
import 'normalize.dart';

abstract class ISchema {
  const ISchema();
}

typedef DoCallback = dynamic Function(dynamic json, Schema schema);

abstract class Schema extends ISchema {
  const Schema();

  Entity getEntity(dynamic json, SchemeFinder find);
  dynamic useId(dynamic id, Entity entity);
}

class SchemaList extends ISchema {
  final Schema schema;

  const SchemaList(this.schema);

  dynamic doCallback(dynamic json, DoCallback callback) {
    return (json as List).map((item) => callback(item, schema)).toList();
  }
}

class Ref extends Schema {
  final String name;

  const Ref(
    this.name,
  );

  static SchemaList list(String name) => SchemaList(Ref(name));

  @override
  Entity getEntity(dynamic json, SchemeFinder find) => find(name);

  @override
  useId(dynamic id, Entity entity) => id;
}

typedef LookupCallback = Ref Function(dynamic json);

class Union extends Schema {
  final LookupCallback lookup;

  const Union(
    this.lookup,
  );

  static SchemaList list(LookupCallback lookup) => SchemaList(Union(lookup));

  @override
  Entity getEntity(dynamic json, SchemeFinder find) =>
      lookup(json).getEntity(json, find);

  @override
  useId(id, Entity entity) => {
        'id': id,
        'type': entity.name,
      };
}
