import 'schema.dart';

class Entity {
  final String name;
  final Map<String, ISchema> definition;
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
