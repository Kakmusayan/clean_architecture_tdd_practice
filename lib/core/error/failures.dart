import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {
  // const ServerFailure([List properties = const <dynamic>[]])
  //     : super(properties);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  //const CacheFailure([List properties = const <dynamic>[]]) : super(properties);

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
