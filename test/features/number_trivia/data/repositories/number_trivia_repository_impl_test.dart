import 'package:clean_architecture_tdd_practice/core/platform/network_info.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/entities/number_trivia.dart';
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
  NumberTriviaLocalDataSource mockNumberTriviaLocalDataSourceImpl;
  NumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSourceImpl;
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
  });
}
