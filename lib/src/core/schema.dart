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

  const Entity(
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
