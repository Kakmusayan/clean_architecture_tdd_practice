import 'package:clean_architecture_tdd_practice/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [NoLocalDataException] if no cached data is present.
  Future<NumberTrivia> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTrivia triviaToChache);
}
