import 'package:svan_play/data/betoffer_category.dart';


class BetOfferCategoryResponse {
  final String sport;
  final String categoryName;
  final List<BetOfferCategory> categories;

  BetOfferCategoryResponse(this.sport, this.categoryName, this.categories);
}