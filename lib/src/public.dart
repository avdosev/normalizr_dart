import 'core/core.dart';

final normalizr = Normalizr();

dynamic normalize(dynamic json, Entity schema) {
  return normalizr.normalize(json, schema);
}
