import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'actions.dart';
import 'reducer.dart';
import 'package:redux_saga/redux_saga.dart';
import 'sagas.dart';

void main() {
  var sagaMiddleware = createSagaMiddleware();

  // Create store and apply middleware
  final store = Store(
    counterReducer,
    initialState: 0,
    middleware: [applyMiddleware(sagaMiddleware)],
  );

  sagaMiddleware.setStore(store);

  sagaMiddleware.run(rootSaga);

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store store;

  MyApp({Key key, this.store}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider(
        store: store,
        child: MaterialApp(
          title: 'Redux Saga Counter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: MyHomePage(title: 'Flutter Redux Saga Counter Demo'),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StoreConnector<dynamic, String>(
              converter: (store) => store.state.toString(),
              builder: (context, count) {
                return new Text(
                  count,
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
            RaisedButton(
              onPressed: () => StoreProvider.of(context).dispatch(IncrementAction()),
              child: Text('Increase'),
            ),
            RaisedButton(
              onPressed: () => StoreProvider.of(context).dispatch(DecrementAction()),
              child: Text('Decrease'),
            ),
            StoreConnector<dynamic, VoidCallback>(
              converter: (store) {
                return () {
                  if (store.state % 2 != 0) {
                    store.dispatch(IncrementAction());
                  }
                };
              },
              builder: (context, callback) {
                return RaisedButton(
                  onPressed: callback,
                  child: Text('IncreamentIfOdd'),
                );
              },
            ),
            //add button here
            RaisedButton(
              onPressed: () => StoreProvider.of(context).dispatch(IncrementAsyncAction()),
              child: Text('IncrementAsync'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => StoreProvider.of(context).dispatch(IncrementAction()),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
