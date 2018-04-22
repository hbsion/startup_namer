import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';

const _list = const [
    'Igor Minar',
    'Brad Green',
    'Dave Geddes',
    'Naomi Black',
    'Greg Weber',
    'Dean Sofer',
    'Wes Alvaro',
    'John Scott',
    'Daniel Nadasi',
];

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new MaterialSearch<String>(
        placeholder: 'Search',
        //placeholder of the search bar text input

//        getResults: (String criteria) async {
//          var list = await _fetchList(criteria);
//          return list.map((name) =>
//          new MaterialSearchResult<String>(
//            value: name, //The value must be of type <String>
//            text: name, //String that will be show in the list
//            icon: Icons.person,
//          )).toList();
//        },
        //or
        results: _list.map((name) =>
        new MaterialSearchResult<String>(
          value: name, //The value must be of type <String>
          text: name, //String that will be show in the list
          icon: Icons.person,
        )).toList(),

        //optional. default filter will look like this:
//        filter: (String value, String criteria) {
//          return value.toString().toLowerCase().trim()
//              .contains(new RegExp(r'' + criteria.toLowerCase().trim() + ''));
//        },
        //optional
//        sort: (String value, String criteria) {
//          return 0;
//        },
        //callback when some value is selected, optional.
        onSelect: (String selected) {
          print(selected);
        },
      ),
    );
  }

}