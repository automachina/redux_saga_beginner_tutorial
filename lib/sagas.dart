import 'package:redux_saga/redux_saga.dart';
import 'actions.dart';

helloSaga() sync* {
  print('Hello Sagas!');
}

incrementAsync({action}) sync* {
  yield Delay(Duration(seconds: 1));
  yield Put(IncrementAction());
}

watchIncrementAsync() sync* {
  yield TakeEvery(incrementAsync, pattern: IncrementAsyncAction);
}

// single entry point to start all Sagas at once
rootSaga() sync* {
  yield All({
    #hello: helloSaga(),
    #watch: watchIncrementAsync(),
  });
}
