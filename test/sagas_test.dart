import 'package:redux_saga/redux_saga.dart';
import 'package:redux_saga_beginner_tutorial/actions.dart';
import 'package:redux_saga_beginner_tutorial/sagas.dart';
import 'package:test/test.dart';

void main() {
  group('Middleware Tests', () {
    test('incrementAsync Saga test', () {
      Iterable gen = incrementAsync();

      Iterator iterator = gen.iterator;

      iterator.moveNext();

      expect(iterator.current, TypeMatcher<Delay>(),
          reason: 'incrementAsync should return a Delay effect');
      expect(iterator.current.duration, Duration(seconds: 1),
          reason: 'Delay effect must resolve after 1 second');

      iterator.moveNext();

      expect(iterator.current, TypeMatcher<Put>(),
          reason: 'incrementAsync should return a Put effect');
      expect(iterator.current.action, TypeMatcher<IncrementAction>(),
          reason: 'incrementAsync Saga must dispatch an IncrementAction action');

      expect(iterator.moveNext(), false, reason: 'incrementAsync Saga must be done');
    });
  });
}
