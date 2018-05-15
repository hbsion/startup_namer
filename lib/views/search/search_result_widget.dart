import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/result_term.dart';
import 'package:svan_play/data/search_result.dart';
import 'package:svan_play/pages/sport_page.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/sticky/sticky_header_list.dart';

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
      yield new HeaderRow(child: _buildHeader("Teams & Players", context));
      for (var term in players) {
        yield new RegularRow(child: _buildRow(term, context));
      }
    }

    if (others.length > 0) {
      yield new HeaderRow(child: _buildHeader("Sports, Regions & Leagues", context));
      for (var term in others) {
        yield new RegularRow(child: _buildRow(term, context));
      }
    }
  }

  Widget _buildHeader(String title, BuildContext context) {
    var appTheme = AppTheme.of(context);
    return new Container(
        color: appTheme.list.headerBackground,
        child: new Material(
            color: Colors.transparent,
            child: new Column(
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        new Text(title, style: Theme.of(context).textTheme.subhead),
                      ],
                    )),
                new Divider(color: appTheme.list.headerDivider, height: 2.0)
              ],
            )));
  }

  Widget _buildRow(ResultTerm term, BuildContext context) {
    var appTheme = AppTheme.of(context);
    return new Container(
        child: new InkWell(
            onTap: _handleRowTap(term, context),
            child: new Column(
              children: <Widget>[
                new Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        new Flexible(child: new Text(term.localizedName, style: Theme.of(context).textTheme.subhead)),
                        new Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: new Text(_unwindPath(term.parentId) ?? "", style: Theme.of(context).textTheme.caption),
                        )
                      ],
                    )),
                new Divider(color: appTheme.list.headerDivider, height: 2.0)
              ],
            )));
  }

  String _unwindPath(String id, {String path}) {
    if (id != null) {
      if (id.endsWith("/all")) {
        return this._unwindPath(id.replaceAll("/all", ""), path: path);
      }
      var term = result.resultTerms.firstWhere((t) => t.id == id, orElse: () => null);
      if (term != null) {
        path = path != null ? term.localizedName + ", " + path : term.localizedName;
        return this._unwindPath(term.parentId, path: path);
      }
    }

    return path;
  }

  VoidCallback _handleRowTap(ResultTerm term, BuildContext context) {
    return () {
      var termKeys = term.id.split("/").where((key) => key.isNotEmpty).toList();

      var sport = termKeys[0];
      var region = termKeys.length > 1 ? termKeys[1] : "all";
      var league = termKeys.length > 2 ? termKeys[2] : "all";
      var participant = termKeys.length > 3 ? termKeys[3] : "all";

      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => new SportPage(
                    sport: sport,
                    league: league,
                    region: region,
                    participant: participant,
                    title: term.localizedName,
                  )));
    };
  }
}
