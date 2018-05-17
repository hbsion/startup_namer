import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/pages/event_page.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/util/dates.dart';
import 'package:svan_play/widgets/betoffer/main_betoffer_widget.dart';
import 'package:svan_play/widgets/empty_widget.dart';

class TrendingCard extends StatelessWidget {
  final int eventId;

  const TrendingCard({Key key, this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
      stream: (store) => store.eventStore[eventId].observable,
      initalData: (store) => store.eventStore[eventId].last,
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, Event model) {
    if (model == null) {
      return EmptyWidget();
    }

    return new Card(
      child: new Column(
        children: <Widget>[
          _buildHeader(context, model),
          Divider(height: 1.0, color: AppTheme.of(context).list.itemDivider),
          _buildBody(context, model),
          emptyIfTrue(
              condition: model.mainBetOfferId == null,
              context: context,
              builder: (_) => new Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                    child: MainBetOfferWidget(betOfferId: model.mainBetOfferId, eventId: eventId),
                  ))
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Event event) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: <Widget>[Expanded(child: _buildTitle(context, event)), _buildStartTime(context, event)],
      ),
    );
  }

  Text _buildTitle(BuildContext context, Event event) {
    return new Text(
      "Trending",
      style: TextStyle(fontSize: 16.0),
    );
  }

  Widget _buildStartTime(BuildContext context, Event event) {
    return Row(
      children: <Widget>[
        new Text(
          prettyDate(event.start),
          style: Theme.of(context).textTheme.caption,
        ),
        Padding(padding: EdgeInsets.all(2.0)),
        new Text(
          formatDate(event.start, [HH, ":", nn]),
          style: Theme.of(context).textTheme.caption,
        )
      ],
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

  Widget _buildBody(BuildContext context, Event model) {
    if (model == null) {
      return new EmptyWidget();
    }
    return new InkWell(
      onTap: _navigate(context),
      child: new Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: new Column(
          children: <Widget>[
            new Text(model.originalStartTime != null ? "${model.originalStartTime} ${model.name}" : model.name,
                style: new TextStyle(fontSize: 16.0)),
            Padding(padding: EdgeInsets.all(3.0)),
            _buildPath(context, model)
          ],
        ),
      ),
    );
  }

  VoidCallback _navigate(BuildContext context) {
    return () => Navigator.push(context, new MaterialPageRoute(builder: (ctx) => new EventPage(eventId: eventId)));
  }
}
