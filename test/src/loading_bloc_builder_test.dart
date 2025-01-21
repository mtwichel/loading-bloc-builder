import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';

import '../helpers/helpers.dart';

class TestingBloc extends Cubit<TestingState> {
  TestingBloc(LoadingStatus initialStatus)
      : super(
          TestingState(
            status: initialStatus,
          ),
        );
}

class TestingState extends Equatable {
  const TestingState({
    required this.status,
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

void main() {
  group('LoadingBlocBuilder', () {
    group('renders', () {
      testWidgets('initialBuilder when initial and builder is provided',
          (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (context) => TestingBloc(LoadingStatus.initial),
            child: LoadingBlocBuilder<TestingBloc, TestingState>(
              statusGetter: (state) => state.status,
              initialBuilder: (_, state) => const Text('Testing'),
              successBuilder: (_, state) => const Text('Filler'),
            ),
          ),
        );

        expect(find.text('Testing'), findsOneWidget);
      });

      testWidgets('SizedBox when initial and builder is not provided',
          (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (context) => TestingBloc(LoadingStatus.initial),
            child: LoadingBlocBuilder<TestingBloc, TestingState>(
              statusGetter: (state) => state.status,
              successBuilder: (_, state) => const Text('filler'),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('loadingBuilder when loading and builder is provided',
          (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (context) => TestingBloc(LoadingStatus.loading),
            child: LoadingBlocBuilder<TestingBloc, TestingState>(
              statusGetter: (state) => state.status,
              loadingBuilder: (_, state) => const Text('Testing'),
              successBuilder: (_, state) => const Text('Filler'),
            ),
          ),
        );

        expect(find.text('Testing'), findsOneWidget);
      });

      testWidgets(
          'CircularProgressIndicator when loading and builder is not provided',
          (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (context) => TestingBloc(LoadingStatus.loading),
            child: LoadingBlocBuilder<TestingBloc, TestingState>(
              statusGetter: (state) => state.status,
              successBuilder: (_, state) => const Text('filler'),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('successBuilder when success', (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (context) => TestingBloc(LoadingStatus.success),
            child: LoadingBlocBuilder<TestingBloc, TestingState>(
              statusGetter: (state) => state.status,
              successBuilder: (_, state) => const Text('Testing'),
            ),
          ),
        );

        expect(find.text('Testing'), findsOneWidget);
      });

      testWidgets('failureBuilder when failure and builder is provided',
          (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (context) => TestingBloc(LoadingStatus.failure),
            child: LoadingBlocBuilder<TestingBloc, TestingState>(
              statusGetter: (state) => state.status,
              failureBuilder: (_, state) => const Text('Testing'),
              successBuilder: (_, state) => const Text('Filler'),
            ),
          ),
        );

        expect(find.text('Testing'), findsOneWidget);
      });

      testWidgets('Error Icon when failure and builder is not provided',
          (tester) async {
        await tester.pumpApp(
          BlocProvider(
            create: (context) => TestingBloc(LoadingStatus.failure),
            child: LoadingBlocBuilder<TestingBloc, TestingState>(
              statusGetter: (state) => state.status,
              successBuilder: (_, state) => const Text('filler'),
            ),
          ),
        );

        expect(find.byIcon(Icons.error), findsOneWidget);
      });
    });
  });
}
