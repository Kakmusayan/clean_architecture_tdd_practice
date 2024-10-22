import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_tdd_practice/core/error/failures.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return super.noSuchMethod(
      Invocation.method(#getConcreteNumberTrivia, [number]),
      returnValue: Future.value(
          Right<Failure, NumberTrivia>(NumberTrivia(number: 1, text: "test"))),
      returnValueForMissingStub: Future.value(
          Right<Failure, NumberTrivia>(NumberTrivia(number: 1, text: "test"))),
    ) as Future<Either<Failure, NumberTrivia>>;
  }
}

void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get trivia for the number from the repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber))
        .thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await usecase(Params(number: tNumber));
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
