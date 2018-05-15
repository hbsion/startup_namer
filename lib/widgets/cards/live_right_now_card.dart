import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:startup_namer/app_theme.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/pages/event_page.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/util/sports.dart';
import 'package:startup_namer/widgets/betoffer/main_betoffer_widget.dart';
import 'package:startup_namer/widgets/live_score_widget.dart';
import 'package:startup_namer/widgets/empty_widget.dart';
import 'package:startup_namer/widgets/match_clock_widget.dart';

class LiveRightNowCard extends StatelessWidget {
  final int eventId;

  const LiveRightNowCard({Key key, this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
      mapper: _mapStateToViewModel,
      widgetBuilder: _buildWidget,
    );
  }

  Observable<Event> _mapStateToViewModel(AppStore appStore) {
    return appStore.eventStore[eventId].observable;
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
              builder: (context) => new Padding(
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
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child:
                new Text("Live", style: new TextStyle(color: Colors.red, fontSize: 16.0, fontStyle: FontStyle.italic)),
          ),
          Expanded(child: _buildPath(context, event)),
          showMatchClockForSport(event.sport) ? new MatchClockWidget(eventId: eventId) : EmptyWidget()
        ],
      ),
    );
  }

  Text _buildPath(BuildContext context, Event event) {
    return new Text(
      event.path.map((p) => p.name).join(" / "),
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 16.0),
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
        child: new LiveScoreWidget(eventId: eventId),
      ),
    );
  }

  VoidCallback _navigate(BuildContext context) {
    return () => Navigator.push(context, new MaterialPageRoute(builder: (ctx) => new EventPage(eventId: eventId)));
  }
}
