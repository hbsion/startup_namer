import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/store/action_type.dart';
import 'package:svan_play/store/app_store.dart';
import 'package:svan_play/store/store_connector.dart';

class FavoriteWidget extends StatelessWidget {
  final int eventId;

  const FavoriteWidget({Key key, @required this.eventId})
      : assert(eventId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<_ViewModel>(stream: mapStateToViewModel, widgetBuilder: _buildWidget);
  }

  Observable<_ViewModel> mapStateToViewModel(AppStore store) {
    return store.favoritesStore.favorites().observable.map((favorites) {
      return new _ViewModel(
          isFavorite: favorites.contains(eventId), toggle: () => store.dispatch(ActionType.toggleFavorite, eventId));
    });
  }

  Widget _buildWidget(BuildContext context, _ViewModel model) {
    return new IconButton(
        icon: model != null && model.isFavorite
            ? new Icon(Icons.star, color: Colors.orangeAccent)
            : new Icon(Icons.star_border),
        onPressed: model != null ? model.toggle : () {});
  }
}

class _ViewModel {
  final bool isFavorite;
  final VoidCallback toggle;

  _ViewModel({this.isFavorite, this.toggle});
}
