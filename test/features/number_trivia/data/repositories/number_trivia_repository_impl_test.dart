import 'package:clean_architecture_tdd_practice/core/error/failures.dart';
import 'package:clean_architecture_tdd_practice/core/platform/network_info.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  // ignore: unused_local_variable
  late NumberTriviaRepositoryImpl repository;
  late NumberTriviaLocalDataSource mockNumberTriviaLocalDataSourceImpl;
  late NumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSourceImpl;
  late NetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaLocalDataSourceImpl = MockNumberTriviaLocalDataSource();
    mockNumberTriviaRemoteDataSourceImpl = MockNumberTriviaRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      localDataSource: mockNumberTriviaLocalDataSourceImpl,
      remoteDataSource: mockNumberTriviaRemoteDataSourceImpl,
      networkInfo: mockNetworkInfo,
    );
  });
  group("getConcreteNumberTrivia", () {
    final tNumber = 1;

    final NumberTriviaModel tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check if the device is online", () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          "should return remote data when the call to remote data source is successful",
          () async {
        //arrange
        when(mockNumberTriviaRemoteDataSourceImpl
                .getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNumberTriviaRemoteDataSourceImpl
            .getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });

      test(
          "should cache the data locally when the call to remote data source is successful",
          () {
        //arrange
        when(mockNumberTriviaRemoteDataSourceImpl
                .getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNumberTriviaRemoteDataSourceImpl
            .getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDataSourceImpl
            .cacheNumberTrivia(tNumberTrivia));
      });

      test(
          "should return server failure when the call to remote data source is successful",
          () async {
        //arrange
        when(mockNumberTriviaRemoteDataSourceImpl
                .getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNumberTriviaRemoteDataSourceImpl
            .getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockNumberTriviaLocalDataSourceImpl);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          "should return last locally cached data when the cached data is present",
          () async {
        //arrange
        when(mockNumberTriviaRemoteDataSourceImpl
                .getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSourceImpl);
        verify(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
    });
  });
}
