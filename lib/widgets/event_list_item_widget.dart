import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:startup_namer/app_theme.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/pages/event_page.dart';
import 'package:startup_namer/store/empty_widget.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/event_info_widget.dart';
import 'package:startup_namer/widgets/event_time_widget.dart';
import 'package:startup_namer/widgets/favorit_widget.dart';
import 'package:startup_namer/widgets/main_betoffer_widget.dart';

class EventListItemWidget extends StatelessWidget {
  final int eventId;

  EventListItemWidget({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
        mapper: (store) => store.eventStore[eventId].observable,
        snapshot: (store) => store.eventStore[eventId].last,
        widgetBuilder: _buildWidget
    );
  }


  VoidCallback navigate(BuildContext context) {
    return () =>
        Navigator.push(context, new MaterialPageRoute(
            builder: (ctx) => new EventPage())
        );
  }

  Widget _buildWidget(BuildContext context, Event model) {
    return new Container(
        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        child: new Column(children: <Widget>[
          new Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: new InkWell(
                  onTap: navigate(context),
                  child: new Row(children: <Widget>[
                    new EventTimeWidget(eventId: eventId,),
                    new Expanded(child: new EventInfoWidget(eventId: eventId,)),
                    new FavoriteWidget(eventId: eventId,),
                  ])
              )),
          model.mainBetOfferId != null ? new MainBetOfferWidget(betOfferId: model.mainBetOfferId) : new EmptyWidget(),
          new Padding(padding: EdgeInsets.all(4.0)),
          new Divider(color: AppTheme
              .of(context)
              .list
              .itemDivider, height: 1.0),
        ]));
  }
}
