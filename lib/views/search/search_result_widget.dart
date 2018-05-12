import 'package:flutter/material.dart';
import 'package:startup_namer/data/search_result.dart';
import 'package:startup_namer/widgets/empty_widget.dart';
import 'package:startup_namer/widgets/sticky/sticky_header_list.dart';

class SearchResultWidget extends StatelessWidget {
  final SearchResult result;

  SearchResultWidget(this.result);

  @override
  Widget build(BuildContext context) {
    return new AnimatedOpacity(
      duration: new Duration(milliseconds: 300),
      opacity: result?.resultTerms?.isNotEmpty ?? false ? 1.0 : 0.0,
      child: _buildListView(context),
    );
  }

  Widget _buildListView(BuildContext context) {
    if (result == null) {
      return EmptyWidget();
    }
    return new StickyList(children: _buildRows(context).toList());
  }

  Iterable<StickyListRow> _buildRows(BuildContext context) sync* {
    var players = result.resultTerms
        .where((term) => term.type == "PARTICIPANT")
        .where((term) => result.searchHitsId.contains(term.id));
    var others = result.resultTerms
        .where((term) => term.type != "PARTICIPANT")
        .where((term) => result.searchHitsId.contains(term.id));

    if (players.length > 0) {
      yield new HeaderRow(child: new Text("Teams & Players"));
      for (var player in players) {
        yield new RegularRow(child: new Text(player.localizedName));
      }
    }

    if (others.length > 0) {
      yield new HeaderRow(child: new Text("Sports, Regions & Leagues"));
      for (var other in others) {
        yield new RegularRow(child: new Text(other.localizedName));
      }
    }
  }
}
