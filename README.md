# Loading Bloc Builder

Provides special `BlocBuilder` for displaying the lifecycle of a state with a `LoadingStatus`


## LoadingStatus
A simple enum that represents four basic statuses an api call can have: `initial`, `loading`, `success`, `failure`

## LoadingBlocBuilder
**Usage**
1. Create a `Bloc` or `Cubit` whose state includes a `LoadingStatus`

```dart
class TestingBloc extends Cubit<TestingState> {
  TestingBloc()
    : super(const TestingState());

  // Make api call here
}

class TestingState extends Equatable {
  const TestingState({
    this.status = LoadingStatus.initial,
  });
  final LoadingStatus status;

  @override
  List<Object> get props => [status];

  TestingState copyWith({
    LoadingStatus? status,
  }) {
    return TestingState(
      status: status ?? this.status,
    );
  }
}
```

2. Provide that `Bloc` somewhere up in the widget tree:
```dart
BlocProvider(
  create: (context) => TestingBloc();
  child: // widgets here
);
```

3. Lower in the widget tree, implement your `LoadingBlocBuilder`
```dart
LoadingBlocBuilder<TestingBloc, TestingState>(
  statusGetter: (state) => state.status,
  initialBuilder: (_, _state) => const Text('Initial'),
  loadingBuilder: (_, _state) => const Text('Loading'),
  successBuilder: (_, _state) => const Text('Success'),
  failureBuilder: (_, _state) => const Text('Failure'),
),
```

**Notes**
- The `successBuilder` is the only builder strictly required.
- If `loadingBuilder` is not supplied, a `CircularProgressIndicator` will be
rendered.
- If `initialBuilder` is not supplied, a `SizedBox` will be rendered.
- If `failureBuilder` is not supplied, an `Icon` with `Icons.error` will be
rendered.