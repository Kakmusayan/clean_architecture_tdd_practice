import 'package:clean_architecture_tdd_practice/core/usecases/usecase.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:clean_architecture_tdd_practice/core/error/failures.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {
  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return super.noSuchMethod(
      Invocation.method(#getConcreteNumberTrivia, [NoParams()]),
      returnValue: Future.value(
          Right<Failure, NumberTrivia>(NumberTrivia(number: 1, text: "test"))),
      returnValueForMissingStub: Future.value(
          Right<Failure, NumberTrivia>(NumberTrivia(number: 1, text: "test"))),
    ) as Future<Either<Failure, NumberTrivia>>;
  }
}

void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumberTrivia = NumberTrivia(number: 1, text: "test");

  test('should get trivia from the repository', () async {
    //arrange
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => Right(tNumberTrivia));
    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
