import 'package:normalizr/normalizr.dart';
import 'dart:convert';

// Define a users schema
final user = Entity('users');

// Define your comments schema
final comment = Entity('comments', {
  'commenter': Ref('users'),
});

// Define your article
final article = Entity('articles', {
  'author': Ref('users'),
  'comments': Ref.list('comments'),
});

void main() {
  // setup
  normalizr.addAll([user, comment, article]);
  // normalize
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
