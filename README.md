# normalizr &middot; ![build status](https://github.com/avdosev/normalizr_dart/workflows/unittests/badge.svg)

Simple package for json normalization just like [normalizr](https://github.com/paularmstrong/normalizr).

## About

Many APIs, public or not, return JSON data that has deeply nested objects. Using data in this kind of structure is often very difficult. 

Normalizr is a small, but powerful utility for taking JSON with a schema definition and returning nested entities with their IDs, gathered in dictionaries.

## Links

[Pub dev][pubdev]

[Documentation][docs]

[Issue tracker][tracker]

## Usage

Example input json
```json
{
  "id": "123",
  "author": {"id": "1", "name": "Paul"},
  "title": "My awesome blog post",
  "comments": [
    {
      "id": "324",
      "commenter": {"id": "2", "name": "Nicole"}
    }
  ]
}
```
Normalize:
```dart
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
  
  final data = ... // some json

  // normalize json data
  final normalizedData = normalize(data, article);
  // output
  final encoder = JsonEncoder.withIndent('  ');
  String prettyJson = encoder.convert(normalizedData);
  print(prettyJson);
}
```
output:
```json
{
  "result": "123",
  "type": "articles",
  "entities": {
    "users": {
      "1": {
        "id": "1",
        "name": "Paul"
      },
      "2": {
        "id": "2",
        "name": "Nicole"
      }
    },
    "comments": {
      "324": {
        "id": "324",
        "commenter": "2"
      }
    },
    "articles": {
      "123": {
        "id": "123",
        "author": "1",
        "title": "My awesome blog post",
        "comments": [
          "324"
        ]
      }
    }
  }
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/avdosev/normalizr_dart/issues
[pubdev]: https://pub.dev/packages/normalizr
[docs]: https://pub.dev/documentation/normalizr/latest/
