abstract class Schema {
  const Schema();
}

class Ref extends Schema {
  final String name;

  const Ref(this.name);
}

class Entity extends Schema {
  final String name;
  final Map<String, Entity> definition;

  const Entity(this.name, [this.definition = const {}]);
}
