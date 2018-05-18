import 'package:svan_play/data/betoffer_category.dart';


class BetOfferCategoryResponse {
  final int groupId;
  final String categoryName;
  final List<BetOfferCategory> categories;

  BetOfferCategoryResponse(this.groupId, this.categoryName, this.categories);
}