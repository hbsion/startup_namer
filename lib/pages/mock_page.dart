import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:startup_namer/app_drawer.dart';
import 'package:startup_namer/data/odds.dart';
import 'package:startup_namer/models/main_model.dart';
import 'package:startup_namer/models/odds_format.dart';
import 'package:startup_namer/widgets/app_toolbar.dart';
import 'package:startup_namer/widgets/section_list_view.dart';

class MockPage extends StatelessWidget {
  final String title;

  MockPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[new AppToolbar(title: "MOCK"), new _MockView()],
      ),
      drawer: new AppDrawer(onSelect: (Widget page) {}),
    );
  }
}

class _MockView extends StatelessWidget {
  final String sport;
  final String league;
  final String region;
  final String prefix;

  const _MockView({Key key, this.sport, this.league, this.region, this.prefix}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new SectionListView(sections: buildSections(prefix));
  }
}

List<ListSection> buildSections(String prefix) {
  List<ListSection> data = [];

  for (int i = 0; i < 200; i++) {
    data.add(buildTile(i, prefix));
  }
  return data;
}

class _MockSection extends ListSection {
  final int section;

  _MockSection(this.section);

  @override
  IndexedWidgetBuilder get builder => (context, index) => buildRow(section, index);

  @override
  int get count => 100;

  @override
  bool get initiallyExpanded => true;

  @override
  String get title => "Section $section";
}

ListSection buildTile(int i, String prefix) {
  ListSection tile = new _MockSection(i);

  return tile;
}

List<Widget> buildRows(int section) {
  List<Widget> data = [];

  for (int row = 0; row < 100; row++) {
    data.add(buildRow(section, row));
  }

  return data;
}

Widget buildRow(int section, int row) {
  return new _EventListItemWidget(
    key: Key("$section - $row"),
  );
}

class _EventListItemWidget extends StatelessWidget {
  const _EventListItemWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Padding(
        padding: EdgeInsets.all(8.0),
        child: new Column(children: <Widget>[
          new InkWell(
              onTap: () => print("List tap"),
              child: new Row(children: <Widget>[
                _EventTimeWidget(),
                new Expanded(child: new _EventInfoWidget()),
                new _FavoriteWidget(),
              ])),
          new _BetOfferWidget(),
          new Divider()
        ]));
  }
}

class _EventInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
    //    print("Render list view item: $eventId");
    var textTheme = Theme.of(context).textTheme;
    return new Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      new Text("Barcelona", overflow: TextOverflow.ellipsis, style: textTheme.subhead),
      new Text("Arsenal" ?? "", style: textTheme.subhead),
      new Padding(padding: EdgeInsets.all(2.0)),
      _buildGroupPath(textTheme),
    ]);
  }

  Widget _buildGroupPath(TextTheme textTheme) {
    return new Container(
        //        color: Colors.yellow,
        child: new Row(children: _buildGroupPathElements(textTheme).toList()));
  }

  Iterable<Widget> _buildGroupPathElements(TextTheme textTheme) sync* {
    yield new Padding(
        padding: EdgeInsets.only(right: 2.0),
        child: new Text("Live",
            style: textTheme.caption.merge(new TextStyle(color: Colors.red, fontStyle: FontStyle.italic))));
    for (var i = 0; i < 3; ++i) {
      if (i > 0) {
        yield new Padding(
            padding: EdgeInsets.only(left: 2.0, right: 2.0), child: new Text("/", style: textTheme.caption));
      }
      yield new Flexible(child: new Container(child: new Text("path-$i", softWrap: false, style: textTheme.caption)));
    }
  }
}

class _EventTimeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Text("C");
//    return new CountDownWidget(time: DateTime.now().add(new Duration(minutes: 10)),);
  }
}

class _FavoriteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new IconButton(icon: new Icon(Icons.star, color: Colors.orangeAccent), onPressed: () {});
  }
}

class _BetOfferWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Row(children: <Widget>[
      new Expanded(child: new Padding(padding: EdgeInsets.only(right: 4.0), child: new _OutcomeWidget())),
      new Expanded(child: new Padding(padding: EdgeInsets.only(right: 4.0), child: new _OutcomeWidget())),
      new Expanded(child: new _OutcomeWidget()),
    ]);
  }
}

class _OutcomeWidget extends StatelessWidget {
  static final Color blue = Color.fromRGBO(0x00, 0xad, 0xc9, 1.0);

  @override
  Widget build(BuildContext context) {
    return _buildWidget(context);
  }

  Widget _buildWidget(BuildContext context) {
//    print("render outcome ${widget.outcomeId}");
    //_handleOddsChange(viewModel);

    return new ScopedModelDescendant<MainModel>(builder: (context, child, model) {
      return new Container(
          height: 38.0,
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: _isSuspended() ? Colors.grey : blue,
          ),
          child: _buildContentWrapper(model));
    });
  }

//  Container _buildPlaceholder() {
//    return new Container(
//        height: 38.0,
//        padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
//        decoration: new BoxDecoration(
//            borderRadius: BorderRadius.circular(3.0),
//            color: Colors.grey
//        ),
//        child: new EmptyWidget());
//  }

//  void _handleOddsChange(_ViewModel viewModel) {
//    if (_oddsDiff(viewModel.outcome) != 0) {
//      if (_timer != null) {
//        _timer.cancel();
//      }
//      _timer = new Timer(new Duration(seconds: 6), () {
//        if (mounted) {
//          setState(() {});
//        }
//      });
//    }
//  }

  Widget _buildContentWrapper(MainModel model) {
    if (_isSuspended()) {
      return _buildContent(model);
    }

    return new Material(
      color: Colors.transparent,
      child: new InkWell(onTap: () => print("outcome tap " + DateTime.now().toString()), child: _buildContent(model)),
    );
  }

  bool _isSuspended() => false;

  Widget _buildContent(MainModel model) {
    var label = _formatLabel();

    if (label != null) {
      return new Row(
        children: <Widget>[new Expanded(child: _buildLabel(label)), _buildOdds(model)],
      );
    } else {
      return new Row(
        children: <Widget>[
          new Expanded(child: _buildOdds(model)),
        ],
      );
    }
  }

  Widget _buildOdds(MainModel model) {
    var formatOdds = _formatOdds(new Odds(decimal: 1123), model.oddsFormat);

    return new Text(formatOdds, style: new TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold));
  }

  Text _buildLabel(String label) {
    return new Text(label ?? "?",
//        overflow: TextOverflow.fade,
        softWrap: false,
        style: new TextStyle(color: Colors.white, fontSize: 12.0));
  }

  String _formatLabel() {
    return "Manchester";
  }

  String _formatOdds(Odds odds, OddsFormat format) {
    switch (format) {
      case OddsFormat.Fractional:
        return odds.fractional ?? "";
      case OddsFormat.American:
        return odds.american ?? "";
      case OddsFormat.Decimal:
      default:
        return ((odds.decimal ?? 1000) / 1000).toString();
    }
  }
}
