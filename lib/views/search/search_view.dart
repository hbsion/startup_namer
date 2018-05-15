import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:svan_play/api/offering_api.dart';
import 'package:svan_play/data/search_result.dart';
import 'package:svan_play/views/search/empty_result_widget.dart';
import 'package:svan_play/views/search/search_error_widget.dart';
import 'package:svan_play/views/search/search_intro_widget.dart';
import 'package:svan_play/views/search/search_loading_widget.dart';
import 'package:svan_play/views/search/search_result_widget.dart';
import 'package:svan_play/views/search/search_state.dart';

class SearchView extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SearchView> {
  TextEditingController _controller = new TextEditingController();
  final StreamController<String> _onTextChanged = new StreamController<String>();
  final PublishSubject<SearchState> _onClear = new PublishSubject<SearchState>();
  Observable<SearchState> _searchStream;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  @override
  void initState() {
    _searchStream = new Observable<String>(_onTextChanged.stream)
        .distinct()
        .where((str) => str.length > 1)
        .debounce(const Duration(milliseconds: 250))
        .switchMap(_buildSearch())
        .mergeWith([_onClear.stream]);
    super.initState();
  }

  @override
  void dispose() {
    _onTextChanged.close();
    _onClear.close();
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAppBar(BuildContext context) {
    return new _DarkAppBar(new AppBar(
        title: new TextField(
            controller: _controller,
            autofocus: true,
            decoration: new InputDecoration.collapsed(hintText: "Search"),
            style: Theme.of(context).textTheme.title.merge(TextStyle(color: Colors.white)),
            onChanged: _onTextChanged.add),
        actions: [
          new IconButton(
              icon: new Icon(Icons.clear),
              onPressed: () {
                _onClear.add(new SearchState.initial());
                _controller.text = '';
              }),
        ]));
  }

  Widget _buildBody(BuildContext context) {
    return new StreamBuilder<SearchState>(
        stream: _searchStream,
        initialData: new SearchState.initial(),
        builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
          final model = snapshot.data;

          return new Stack(
            children: <Widget>[
              // Fade in an intro screen if no term has been entered
              new SearchIntroWidget(model.result == null && !model.isLoading),
              // Fade in an Empty Result screen if the search contained// no items
              new EmptyResultWidget(model.result?.resultTerms?.isEmpty ?? false),
              // Fade in a loading screen when results are being fetched
              new SearchLoadingWidget(model.isLoading ?? false),
              // Fade in an error if something went wrong when fetching the results
              new SearchErrorWidget(model.hasError ?? false),
              // Fade in the Result if available
              new SearchResultWidget(model.result),
            ],
          );
        });
  }

  Observable<SearchState> Function(String) _buildSearch() {
    return (String term) {
      return new Observable<SearchResult>.fromFuture(doSearch(term))
          .map<SearchState>((SearchResult result) {
            return new SearchState(
              result: result,
              isLoading: false,
            );
          })
          .onErrorReturn(new SearchState.error())
          .startWith(new SearchState.loading());
    };
  }
}

class _DarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;

  _DarkAppBar(this.appBar);

  @override
  Widget build(BuildContext context) {
    return new Theme(child: appBar, data: new ThemeData.dark());
  }

  @override
  Size get preferredSize => appBar.preferredSize;
}
