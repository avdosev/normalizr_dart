import 'package:normalizr/normalizr.dart';
import 'package:test/test.dart';

void main() {
  group('normalize', () {
    setUp(() {
      normalizr.clear();
    });

    test('circular references', () {
      const user = Entity('users', {
        'friends': Ref('users', array: true),
      });

      normalizr.add(user);

      final input = {
        'id': '123',
        'nick': 'first',
        'friends': [
          {'id': '124', 'nick': 'second'},
        ]
      };

      expect(normalize(input, user), {
        'result': '123',
        'type': 'users',
        'entities': {
          'users': {
            '123': {
              'id': '123',
              'nick': 'first',
              'friends': ['124'],
            },
            '124': {
              'id': '124',
              'nick': 'second',
            },
          }
        }
      });
    });
  });
}
