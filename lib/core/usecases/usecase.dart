import 'package:clean_architecture_tdd_practice/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>>? call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoParams extends Equatable {
  const NoParams() : super();
  @override
  List<Object?> get props => [];
}
