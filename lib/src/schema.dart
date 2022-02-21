abstract class Schema {
  const Schema();
}

class Ref extends Schema {
  final String name;
  final bool array;

  const Ref(
    this.name, {
    this.array = false,
  });
}

class Entity {
  final String name;
  final Map<String, Ref> definition;
  final EntityOptions options;

  Entity(
    this.name, [
    this.definition = const {},
    this.options = const EntityOptions(),
  ]);
}

class EntityOptions {
  /// Name identificator of id
  final String id;

  const EntityOptions({
    this.id = "id",
  });
}

class Entities {
  static Entities? _i;

  static Entities get I => Entities();

  Entities._();

  factory Entities() {
    _i ??= Entities._();
    return _i!;
  }

  final _schemas = <String, Entity>{};

  void add(Entity schema) {
    _schemas[schema.name] = schema;
  }

  Entity? find(String name) {
    return _schemas[name];
  }
}
