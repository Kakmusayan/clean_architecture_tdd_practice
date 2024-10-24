import 'package:clean_architecture_tdd_practice/core/platform/network_info.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_practice/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  // ignore: unused_local_variable
  NumberTriviaRepositoryImpl repository;
  NumberTriviaLocalDataSource mockNumberTriviaLocalDataSourceImpl;
  NumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSourceImpl;
  NetworkInfo mockNetworkInfo;

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
}
