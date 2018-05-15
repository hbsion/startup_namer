import 'package:svan_play/data/search_result.dart';

class SearchState {
  final SearchResult result;
  final bool hasError;
  final bool isLoading;

  SearchState({
    this.result,
    this.hasError = false,
    this.isLoading = false,
  });

  factory SearchState.initial() => new SearchState();

  factory SearchState.loading() => new SearchState(isLoading: true);

  factory SearchState.error() => new SearchState(hasError: true);

  @override
  String toString() {
    return '_SearchState{result: $result, hasError: $hasError, isLoading: $isLoading}';
  }
}
