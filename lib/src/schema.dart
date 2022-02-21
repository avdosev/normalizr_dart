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

class Entity extends Schema {
  final String name;
  final Map<String, Ref> definition;

  const Entity(this.name, [this.definition = const {}]);
}
