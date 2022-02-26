import 'package:normalizr/normalizr.dart';
import 'package:test/test.dart';

void main() {
  group('normalize', () {
    setUp(() {
      normalizr.clear();
    });

    test('example', () {
      final user = Entity('users');

      final comment = Entity('comments', {
        'commenter': Ref('users'),
      });

      final article = Entity('articles', {
        'author': Ref('users'),
        'comments': Ref('comments', array: true),
      });

      normalizr.addAll([user, comment, article]);

      final input = {
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

      expect(normalize(input, article), {
        "result": "123",
        "type": "articles",
        "entities": {
          "users": {
            "1": {"id": "1", "name": "Paul"},
            "2": {"id": "2", "name": "Nicole"}
          },
          "comments": {
            "324": {"id": "324", "commenter": "2"}
          },
          "articles": {
            "123": {
              "id": "123",
              "author": "1",
              "title": "My awesome blog post",
              "comments": ["324"]
            }
          }
        }
      });
    });

    test('circular references', () {
      const user = Entity('users', {
        'friends': Ref('users', array: true),
      });

      normalizr.add(user);

      final input = {
        'id': 123,
        'nick': 'first',
        'friends': [
          {'id': 124, 'nick': 'second'},
        ]
      };

      expect(normalize(input, user), {
        'result': 123,
        'type': 'users',
        'entities': {
          'users': {
            123: {
              'id': 123,
              'nick': 'first',
              'friends': [124],
            },
            124: {
              'id': 124,
              'nick': 'second',
            },
          }
        }
      });
    });
  });
}
