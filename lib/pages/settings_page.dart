import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:svan_play/models/main_model.dart';
import 'package:svan_play/models/odds_format.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return new _SettingsPage(
          mainModel: model,
        );
      },
    );
  }
}

class _SettingsPage extends StatefulWidget {
  final MainModel mainModel;

  const _SettingsPage({Key key, this.mainModel}) : super(key: key);

  @override
  _SettingPageSate createState() => new _SettingPageSate();
}

class _SettingPageSate extends State<_SettingsPage> {
  List<SettingsItem<dynamic>> _settingsItems;

  @override
  void initState() {
    super.initState();

    _settingsItems = <SettingsItem<dynamic>>[
      new SettingsItem<Brightness>(
          name: 'Theme',
          value: widget.mainModel.brightness,
          hint: 'Select theme',
          valueToString: (Brightness theme) => theme.toString(),
          builder: (SettingsItem<Brightness> item) {
            void close() {
              setState(() {
                item.isExpanded = false;
              });
            }

            return new Form(child: new Builder(builder: (BuildContext context) {
              return new CollapsibleBody(
                onSave: () {
                  Form.of(context).save();
                  widget.mainModel.updateTheme(item.value);
                  close();
                },
                onCancel: () {
                  Form.of(context).reset();
                  close();
                },
                child: new FormField<Brightness>(
                    initialValue: item.value,
                    onSaved: (Brightness result) {
                      item.value = result;
                    },
                    builder: (FormFieldState<Brightness> field) {
                      return new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                              new Radio<Brightness>(
                                value: Brightness.light,
                                groupValue: field.value,
                                onChanged: field.didChange,
                              ),
                              const Text('Light')
                            ]),
                            new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                              new Radio<Brightness>(
                                value: Brightness.dark,
                                groupValue: field.value,
                                onChanged: field.didChange,
                              ),
                              const Text('Dark')
                            ]),
                          ]);
                    }),
              );
            }));
          }),
      new SettingsItem<OddsFormat>(
          name: 'Odds Format',
          value: widget.mainModel.oddsFormat,
          hint: 'Select odds format',
          valueToString: (OddsFormat oddsFormat) => oddsFormat.toString(),
          builder: (SettingsItem<OddsFormat> item) {
            void close() {
              setState(() {
                item.isExpanded = false;
              });
            }

            return new Form(child: new Builder(builder: (BuildContext context) {
              return new CollapsibleBody(
                onSave: () {
                  Form.of(context).save();
                  widget.mainModel.uppdateOddsFormat(item.value);
                  close();
                },
                onCancel: () {
                  Form.of(context).reset();
                  close();
                },
                child: new FormField<OddsFormat>(
                    initialValue: item.value,
                    onSaved: (OddsFormat result) {
                      item.value = result;
                    },
                    builder: (FormFieldState<OddsFormat> field) {
                      return new Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                              new Radio<OddsFormat>(
                                value: OddsFormat.Decimal,
                                groupValue: field.value,
                                onChanged: field.didChange,
                              ),
                              const Text('Decimal')
                            ]),
                            new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                              new Radio<OddsFormat>(
                                value: OddsFormat.Fractional,
                                groupValue: field.value,
                                onChanged: field.didChange,
                              ),
                              const Text('Fractional')
                            ]),
                            new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                              new Radio<OddsFormat>(
                                value: OddsFormat.American,
                                groupValue: field.value,
                                onChanged: field.didChange,
                              ),
                              const Text('American')
                            ]),
                          ]);
                    }),
              );
            }));
          }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Settings')),
      body: new SingleChildScrollView(
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Container(
            margin: const EdgeInsets.all(16.0),
            child: new ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _settingsItems[index].isExpanded = !isExpanded;
                  });
                },
                children: _settingsItems.map((SettingsItem<dynamic> item) {
                  return new ExpansionPanel(
                      isExpanded: item.isExpanded, headerBuilder: item.headerBuilder, body: item.build());
                }).toList()),
          ),
        ),
      ),
    );
  }
}

typedef Widget DemoItemBodyBuilder<T>(SettingsItem<T> item);
typedef String ValueToString<T>(T value);

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({this.name, this.value, this.hint, this.showHint});

  final String name;
  final String value;
  final String hint;
  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return new AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return new Row(children: <Widget>[
      new Expanded(
        flex: 2,
        child: new Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: new FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: new Text(
              name,
              style: textTheme.body1.copyWith(fontSize: 15.0),
            ),
          ),
        ),
      ),
      new Expanded(
          flex: 3,
          child: new Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(new Text(value, style: textTheme.caption.copyWith(fontSize: 15.0)),
                  new Text(hint, style: textTheme.caption.copyWith(fontSize: 15.0)), showHint)))
    ]);
  }
}

class CollapsibleBody extends StatelessWidget {

  const CollapsibleBody({this.margin: EdgeInsets.zero, this.child, this.onSave, this.onCancel});

  final EdgeInsets margin;
  final Widget child;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return new Column(children: <Widget>[
      new Container(
          margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0) - margin,
          child:
              new Center(child: new DefaultTextStyle(style: textTheme.caption.copyWith(fontSize: 15.0), child: child))),
      const Divider(height: 1.0),
      new Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            new Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: new FlatButton(
                    onPressed: onCancel,
                    child: const Text('CANCEL', style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)))),
            new Container(
                margin: const EdgeInsets.only(right: 8.0),
                child: new FlatButton(
                    onPressed: onSave,
                    textTheme: ButtonTextTheme.accent,
                    child: const Text(
                      'SAVE',
                      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                    )))
          ]))
    ]);
  }
}

class SettingsItem<T> {
  SettingsItem({this.name, this.value, this.hint, this.builder, this.valueToString})
      : textController = new TextEditingController(text: valueToString(value));

  final String name;
  final String hint;
  final TextEditingController textController;
  final DemoItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return new DualHeaderWithHint(name: name, value: valueToString(value), hint: hint, showHint: isExpanded);
    };
  }

  Widget build() => builder(this);
}
