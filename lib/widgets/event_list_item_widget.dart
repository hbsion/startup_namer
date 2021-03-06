import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:svan_play/app_theme.dart';
import 'package:svan_play/data/event.dart';
import 'package:svan_play/data/event_state.dart';
import 'package:svan_play/data/event_tags.dart';
import 'package:svan_play/pages/event_page.dart';
import 'package:svan_play/store/store_connector.dart';
import 'package:svan_play/widgets/betoffer/main_betoffer_widget.dart';
import 'package:svan_play/widgets/empty_widget.dart';
import 'package:svan_play/widgets/event_info_widget.dart';
import 'package:svan_play/widgets/event_tracker_widget.dart';
import 'package:svan_play/widgets/favorite_widget.dart';

class EventListItemWidget extends StatelessWidget {
  final int eventId;
  final bool showDivider;

  EventListItemWidget({Key key, @required this.eventId, this.showDivider = true})
      : assert(eventId != null),
        assert(showDivider != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
        stream: (store) => store.eventStore[eventId].observable,
        initalData: (store) => store.eventStore[eventId].latest,
        widgetBuilder: _buildWidget);
  }

  VoidCallback _navigate(BuildContext context) {
    return () => Navigator.push(context, new MaterialPageRoute(builder: (ctx) => new EventPage(eventId: eventId)));
  }

  Widget _buildWidget(BuildContext context, Event model) {
    if (model == null) return new EmptyWidget();

    return new Container(
        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: new OrientationBuilder(builder: (context, __) {
          var orientation = MediaQuery.of(context).orientation;
          if (orientation == Orientation.portrait || model.tags.contains(EventTags.competition))
            return _buildPortraitLayout(context, model);
          else
            return _buildLandscapeLayout(context, model);
        }));
  }

  Widget _buildPortraitLayout(BuildContext context, Event model) {
    return new Column(children: <Widget>[
      new Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: new InkWell(
              onTap: _navigate(context),
              child: new Row(
                  crossAxisAlignment:
                      model.state == EventState.STARTED ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildScoreAndMatchClock(context),
                    new Expanded(
                        child: new EventInfoWidget(
                      key: new Key(eventId.toString()),
                      eventId: eventId,
                    )),
                    new FavoriteWidget(
                      eventId: eventId,
                    ),
                  ]))),
      model.mainBetOfferId != null
          ? new MainBetOfferWidget(
              key: new Key(model.mainBetOfferId.toString()), betOfferId: model.mainBetOfferId, eventId: model.id)
          : new EmptyWidget(),
      new Padding(padding: EdgeInsets.all(model.mainBetOfferId != null ? 4.0 : 0.0)),
      _buildDivider(context)
    ]);
  }

  Widget _buildLandscapeLayout(BuildContext context, Event model) {
    return new Column(children: <Widget>[
      new Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: new InkWell(
              onTap: _navigate(context),
              child: new Row(children: <Widget>[
                _buildScoreAndMatchClock(context),
                new Expanded(
                    child: new EventInfoWidget(
                  key: new Key(eventId.toString()),
                  eventId: eventId,
                )),
                new FavoriteWidget(
                  eventId: eventId,
                ),
                new Container(
                    width: 300.0,
                    child: model.mainBetOfferId != null
                        ? new MainBetOfferWidget(
                            key: new Key(model.mainBetOfferId.toString()),
                            betOfferId: model.mainBetOfferId,
                            eventId: model.id,
                          )
                        : new EmptyWidget()),
              ]))),
      new Padding(padding: EdgeInsets.all(model.mainBetOfferId != null ? 4.0 : 0.0)),
      new Divider(color: AppTheme.of(context).list.itemDividerColor, height: 1.0),
    ]);
  }

  Widget _buildScoreAndMatchClock(BuildContext context) {
    return new Container(width: 80.0, child: new EventTrackingWidget(eventId: eventId));
  }

  Widget _buildDivider(BuildContext context) {
    if (!showDivider) return EmptyWidget();

    return new Divider(color: AppTheme.of(context).list.itemDividerColor, height: 1.0);
  }
}
