import 'package:flutter/material.dart';
import 'package:rxdart/src/observable.dart';
import 'package:startup_namer/data/event.dart';
import 'package:startup_namer/store/app_store.dart';
import 'package:startup_namer/store/store_connector.dart';
import 'package:startup_namer/widgets/empty_widget.dart';
import 'package:startup_namer/widgets/main_betoffer_widget.dart';

class LiveRightNowCardWidget extends StatelessWidget {
  final int eventId;

  const LiveRightNowCardWidget({Key key, this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<Event>(
      mapper: _mapStateToViewModel,
      widgetBuilder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context, Event model) {
    return new Card(
      child: new Column(
        children: <Widget>[
          _buildHeader(context, model),
          Divider(height: 1.0),
          _buildBody(context, model)
        ],
      ),
    );
  }

  Observable<Event> _mapStateToViewModel(AppStore appStore) {
    return appStore.eventStore[eventId].observable;
  }

  Widget _buildHeader(BuildContext context, Event model) {
    return new Text("HEADDER");
  }

  Widget _buildBody(BuildContext context, Event model) {
    if (model == null) {
      return new EmptyWidget();
    }
    return new Column(
      children: <Widget>[
        Text(model.homeName, style: Theme.of(context).textTheme.subhead),
        Text(model.awayName, style: Theme.of(context).textTheme.subhead),
        emptyIfTrue(
            condition: model.mainBetOfferId == null,
            widget: MainBetOfferWidget(betOfferId: model.mainBetOfferId, eventId: model.id))
      ],
    );
  }
}
