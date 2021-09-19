import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_bloc_builder/loading_bloc_builder.dart';

/// {@template loading_bloc_builder}
/// A special [BlocBuilder] for displaying the lifecycle of a state with
/// a [LoadingStatus].
///
///
/// Example:
/// ```dart
/// LoadingBlocBuilder<TestingBloc, TestingState>(
///   statusGetter: (state) => state.status,
///   initialBuilder: (_, _state) => const Text('Initial'),
///   loadingBuilder: (_, _state) => const Text('Loading'),
///   successBuilder: (_, _state) => const Text('Success'),
///   failureBuilder: (_, _state) => const Text('Failure'),
/// ),
/// ```
/// - The [successBuilder] is the only builder strictly required.
/// - If [loadingBuilder] is not supplied, a [CircularProgressIndicator] will be
/// rendered.
/// - If [initialBuilder] is not supplied, a [SizedBox] will be rendered.
/// - If [failureBuilder] is not supplied, an [Icon] with [Icons.error] will be
/// rendered.
/// {@endtemplate}
class LoadingBlocBuilder<B extends BlocBase<S>, S> extends StatelessWidget {
  /// {@macro loading_bloc_builder}
  const LoadingBlocBuilder({
    required this.statusGetter,
    required this.successBuilder,
    this.initialBuilder,
    this.failureBuilder,
    this.loadingBuilder,
    Key? key,
  }) : super(key: key);

  /// The method that this widget determines which [LoadingStatus] should be
  /// used when deciding what to render
  final LoadingStatus Function(S) statusGetter;

  /// A builder for the widget built initially.
  final Widget Function(BuildContext, S)? initialBuilder;

  /// A builder for the widget build when loading.
  final Widget Function(BuildContext, S)? loadingBuilder;

  /// A builder for the widget built on successful call.
  final Widget Function(BuildContext, S) successBuilder;

  /// A builder for the widget built when call fails.
  final Widget Function(BuildContext, S)? failureBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        switch (statusGetter(state)) {
          case LoadingStatus.initial:
            final builder = initialBuilder;
            if (builder != null) {
              return builder(context, state);
            }
            return const SizedBox();
          case LoadingStatus.loading:
            final builder = loadingBuilder;
            if (builder != null) {
              return builder(context, state);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          case LoadingStatus.success:
            return successBuilder(context, state);
          case LoadingStatus.failure:
            final builder = failureBuilder;
            if (builder != null) {
              return builder(context, state);
            }
            return const Center(
              child: Icon(Icons.error),
            );
        }
      },
    );
  }
}
