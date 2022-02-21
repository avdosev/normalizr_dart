import 'package:normalizr/normalizr.dart';
import 'dart:convert';

// Define a users schema
final user = Entity('users');

// Define your comments schema
final comment = Entity('comments', const {
  'commenter': Ref('users'),
});

// Define your article
final article = Entity('articles', const {
  'author': Ref('users'),
  'comments': Ref('comments', array: true),
});

void main() {
  [user, comment, article].forEach(Entities.I.add);
  final normalizedData = normalize(data, article);
  JsonEncoder encoder = JsonEncoder.withIndent('  ');
  String prettyprint = encoder.convert(normalizedData);
  print(prettyprint);
}

final data = {
  "id": "123",
  "author": {"id": "1", "name": "Paul"},
  "title": "My awesome blog post",
  "comments": [
    {
      "id": "324",
      "commenter": {"id": "2", "name": "Nicole"}
    }
  ]
};
