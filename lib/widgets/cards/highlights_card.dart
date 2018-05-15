import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/pages/event_page.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/dates.dart';
import 'package:svan_play/widgets/empty_widget.dart';

class HighlightsCard extends StatelessWidget {
  final List<int> eventIds;

  const HighlightsCard({Key key, this.eventIds})
      : assert(eventIds != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildHeader(context),
          Divider(height: 1.0, color: AppTheme.of(context).list.itemDivider),
          _buildBody(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Text("Highlights", style: TextStyle(fontSize: 16.0)),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<Widget> childs = [];
    for (var i = 0; i < eventIds.length; ++i) {
      var eventId = eventIds[i];
      childs.add(_HighlightRow(eventId: eventId));
      if (i < (eventIds.length - 1)) {
        childs.add(new Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: new Divider(height: 1.0, color: AppTheme.of(context).list.itemDivider),
        ));
      }
    }
    return new Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: childs);
  }
}

class _HighlightRow extends StatelessWidget {
  final int eventId;

  const _HighlightRow({Key key, this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector(
      stream: (store) => store.eventStore[eventId].observable,
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, Event model) {
    if (model == null) {
      return new EmptyWidget();
    }
    return new InkWell(
      onTap: _navigate(context),
      child: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Expanded(child: new Text(_buildEventName(model), style: new TextStyle(fontSize: 13.0))),
                new Text(prettyDate(model.start), style: Theme.of(context).textTheme.caption)
              ],
            ),
            Padding(padding: EdgeInsets.all(3.0)),
            new Row(
              children: <Widget>[
                new Expanded(child: _buildPath(context, model)),
                new Text(formatDate(model.start, [HH, ":", nn]), style: Theme.of(context).textTheme.caption)
              ],
            )
          ],
        ),
      ),
    );
  }

  Text _buildPath(BuildContext context, Event event) {
    return new Text(
      event.path.map((p) => p.name).join(" / "),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.caption,
    );
  }

  VoidCallback _navigate(BuildContext context) {
    return () => Navigator.push(context, new MaterialPageRoute(builder: (ctx) => new EventPage(eventId: eventId)));
  }

  String _buildEventName(Event model) {
//    if (model.homeName != null && model.awayName != null) {
//      return
//    }
    return model.name;
  }
}
