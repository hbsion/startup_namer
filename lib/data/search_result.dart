import 'package:svan_play/data/result_term.dart';

class SearchResult {
  final String term;
  final List<ResultTerm> resultTerms;
  final List<String> searchHitsId;

  SearchResult({this.term, this.resultTerms, this.searchHitsId});

  SearchResult.empty() : this(term: "", resultTerms: [], searchHitsId: []);

  SearchResult.fromJson(Map<String, dynamic> json) :
      this(
        term: json["term"],
        resultTerms: ((json["resultTerms"] ?? []) as List<dynamic>).map<ResultTerm>((s) => new ResultTerm.fromJson(s)).toList(),
        searchHitsId: ((json["searchHitsId"] ?? []) as List<dynamic>).map<String>((s) => s).toList(),
      );


  @override
  String toString() {
    return 'SearchResult{term: $term, resultTerms: $resultTerms, searchHitsId: $searchHitsId}';
  }

}
