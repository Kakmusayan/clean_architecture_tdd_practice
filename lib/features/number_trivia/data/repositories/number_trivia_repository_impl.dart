import 'package:clean_architecture_tdd_practice/core/error/failures.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaREpositoryImpl implements NumberTriviaRepository {
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    throw UnimplementedError();
  }

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
