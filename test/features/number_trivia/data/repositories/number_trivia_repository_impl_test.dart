import 'package:clean_architecture_tdd_practice/core/error/exceptions.dart';
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

  void runTestsOnline(Function body) {
    group("device is online", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group("device is offline", () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

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

    runTestsOnline(() {
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
            .thenThrow(ServerException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNumberTriviaRemoteDataSourceImpl
            .getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockNumberTriviaLocalDataSourceImpl);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          "should return last locally cached data when the cached data is present",
          () async {
        //arrange
        when(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSourceImpl);
        verify(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });

      test("should return cache failure when there is no cached data present",
          () async {
        //arrange
        when(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia())
            .thenThrow(CacheException());
        //act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        //assert
        verify(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group("getRandomNumberTrivia", () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 123, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("should check is the device is online", () {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      //act
      repository.getRandomNumberTrivia();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(() {
      test(
          "should return remote data when the call to remote data source is successfull",
          () async {
        //arrange
        when(mockNumberTriviaRemoteDataSourceImpl.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockNumberTriviaRemoteDataSourceImpl.getRandomNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test(
          "should cache data locally, when the call to remote data source is successfull",
          () async {
        //arrange
        when(mockNumberTriviaRemoteDataSourceImpl.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        await repository.getRandomNumberTrivia();
        //assert
        verify(mockNumberTriviaRemoteDataSourceImpl.getRandomNumberTrivia());
        verify(mockNumberTriviaLocalDataSourceImpl
            .cacheNumberTrivia(tNumberTrivia));
      });

      test(
          "should return server failure when the call to remote data source is unsuccessfull",
          () async {
        //arrange
        when(mockNumberTriviaRemoteDataSourceImpl.getRandomNumberTrivia())
            .thenThrow(ServerException());
        //act
        final result = await repository.getRandomNumberTrivia();
        //assert
        verify(mockNumberTriviaRemoteDataSourceImpl.getRandomNumberTrivia());
        verifyZeroInteractions(mockNumberTriviaLocalDataSourceImpl);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runTestsOffline(() {
      test(
          "should return last locally cached data when the cached data is present",
          () async {
        //arrange
        when(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        //act
        final result = await repository.getRandomNumberTrivia();

        //assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSourceImpl);
        verify(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
    });

    test("should return cache failure when there is no cached data present",
        () async {
      //arrange
      when(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia())
          .thenThrow(CacheException());
      //act
      final result = await repository.getRandomNumberTrivia();
      //assert
      verifyZeroInteractions(mockNumberTriviaRemoteDataSourceImpl);
      verify(mockNumberTriviaLocalDataSourceImpl.getLastNumberTrivia());
      expect(result, equals(Left(CacheFailure())));
    });
  });
}
