import 'package:dtube_togo/utils/SecureStorage.dart' as sec;

import 'package:flutter/services.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'dart:core';
import 'package:dtube_togo/realMain.dart';
import 'package:dtube_togo/style/ThemeData.dart';
import 'package:dtube_togo/style/styledCustomWidgets.dart';

import 'package:dtube_togo/bloc/settings/settings_bloc.dart';
import 'package:dtube_togo/bloc/settings/settings_bloc_full.dart';
import 'package:dtube_togo/bloc/settings/settings_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

  SettingsPage({
    Key? key,
  }) : super(key: key);
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsBloc _settingsBloc;

  @override
  void initState() {
    super.initState();
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);
    _settingsBloc.add(FetchSettingsEvent()); // statements;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dtubeSubAppBar(),
      body: Container(
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoadingState || state is SettingsSavingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SettingsLoadedState) {
              return SettingsList(
                  currentSettings: state.settings, justSaved: false);
            } else if (state is SettingsErrorState) {
              return buildErrorUi(state.message);
            } else if (state is SettingsSavedState) {
              return SettingsList(
                  currentSettings: state.settings, justSaved: true);
            } else {
              return Text("unknown state");
            }
          },
        ),
      ),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}

class SettingsList extends StatefulWidget {
  SettingsList({
    Key? key,
    required this.currentSettings,
    required this.justSaved,
  }) : super(key: key);

  final Map<String, String> currentSettings;
  late bool justSaved;

  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  late SettingsBloc _settingsBloc;

  late double _defaultVote;
  late double _defaultVoteComments;
  late double _defaultTip;
  late double _defaultTipComments;
  late String _showHidden;
  late String _showNsfw;

  List<String> _showHiddentNsfwOptions = ['Show', 'Hide', 'Blur'];

  @override
  void initState() {
    super.initState();
    _settingsBloc = BlocProvider.of<SettingsBloc>(context);

    _showHidden = widget.currentSettings[sec.settingKey_showHidden] != null
        ? widget.currentSettings[sec.settingKey_showHidden]!
        : "Hide";

    _showNsfw = widget.currentSettings[sec.settingKey_showNSFW] != null
        ? widget.currentSettings[sec.settingKey_showNSFW]!
        : "Hide";
    _defaultVote =
        widget.currentSettings[sec.settingKey_defaultVotingWeight] != null
            ? double.parse(
                widget.currentSettings[sec.settingKey_defaultVotingWeight]!)
            : 5.0;
    _defaultVoteComments = widget
                .currentSettings[sec.settingKey_defaultVotingWeightComments] !=
            null
        ? double.parse(
            widget.currentSettings[sec.settingKey_defaultVotingWeightComments]!)
        : 5.0;
    _defaultTip = widget.currentSettings[sec.settingKey_defaultVotingTip] !=
            null
        ? double.parse(widget.currentSettings[sec.settingKey_defaultVotingTip]!)
        : 25;
    _defaultTipComments = widget
                .currentSettings[sec.settingKey_defaultVotingTipComments] !=
            null
        ? double.parse(
            widget.currentSettings[sec.settingKey_defaultVotingTipComments]!)
        : 25.0;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
              Text("User interface",
                  style: Theme.of(context).textTheme.headline3),
              SizedBox(height: 8),
              DTubeFormCard(
                childs: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Display",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      //filled: true,
                      //fillColor: Hexcolor('#ecedec'),
                      labelText: 'negative videos',
                      //border: new CustomBorderTextFieldSkin().getSkin(),
                    ),
                    value: _showHidden,
                    onChanged: (newValue) {
                      setState(() {
                        _showHidden = newValue.toString();
                        widget.justSaved = false;
                      });
                    },
                    items: _showHiddentNsfwOptions.map((option) {
                      return DropdownMenuItem(
                        child: new Text(option),
                        value: option,
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      //filled: true,
                      //fillColor: Hexcolor('#ecedec'),
                      labelText: 'NSFW videos',
                      //border: new CustomBorderTextFieldSkin().getSkin(),
                    ),
                    value: _showNsfw,
                    onChanged: (newValue) {
                      setState(() {
                        _showNsfw = newValue.toString();
                        widget.justSaved = false;
                      });
                    },
                    items: _showHiddentNsfwOptions.map((option) {
                      return DropdownMenuItem(
                        child: new Text(option),
                        value: option,
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text("Avalon settings",
                  style: Theme.of(context).textTheme.headline3),
              SizedBox(height: 8),
              DTubeFormCard(
                childs: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Voting weight",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("default voting weight (posts):",
                          style: TextStyle(color: Colors.grey))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Slider(
                          min: 1.0,
                          max: 100.0,
                          value: _defaultVote,
                          label: _defaultVote.floor().toString() + "%",
                          divisions: 20,
                          inactiveColor: globalBlue,
                          activeColor: globalRed,
                          onChanged: (dynamic value) {
                            setState(() {
                              _defaultVote = value;
                              widget.justSaved = false;
                            });
                          },
                        ),
                      ),
                      Text(
                        _defaultVote.floor().toString() + "%",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("default voting weight (comments):",
                          style: TextStyle(color: Colors.grey))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Slider(
                          min: 0.0,
                          max: 100.0,
                          value: _defaultVoteComments,
                          label: _defaultVoteComments.floor().toString() + "%",
                          divisions: 20,
                          inactiveColor: globalBlue,
                          activeColor: globalRed,
                          onChanged: (dynamic value) {
                            setState(() {
                              _defaultVoteComments = value;
                              widget.justSaved = false;
                            });
                          },
                        ),
                      ),
                      Text(
                        _defaultVoteComments.floor().toString() + "%",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
              DTubeFormCard(
                childs: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text("Vote tipping",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                  Text("default voting tip (posts):",
                      style: TextStyle(color: Colors.grey)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Slider(
                          min: 0.0,
                          max: 100.0,
                          value: _defaultTip,
                          label: _defaultTip.floor().toString() + "%",
                          divisions: 20,
                          inactiveColor: globalBlue,
                          activeColor: globalRed,
                          onChanged: (dynamic value) {
                            setState(() {
                              _defaultTip = value;
                              widget.justSaved = false;
                            });
                          },
                        ),
                      ),
                      Text(
                        _defaultTip.floor().toString() + "%",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("default voting tip (comments):",
                          style: TextStyle(color: Colors.grey))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Slider(
                          min: 0.0,
                          max: 100.0,
                          value: _defaultTipComments,
                          label: _defaultTipComments.floor().toString() + "%",
                          divisions: 20,
                          inactiveColor: globalBlue,
                          activeColor: globalRed,
                          onChanged: (dynamic value) {
                            setState(() {
                              _defaultTipComments = value;
                              widget.justSaved = false;
                            });
                          },
                        ),
                      ),
                      Text(
                        _defaultTipComments.floor().toString() + "%",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text("Cross-posting settings",
                  style: Theme.of(context).textTheme.headline3),
              SizedBox(height: 8),
              DTubeFormCard(
                childs: [
                  Row(
                    children: [
                      Container(
                        width: deviceWidth * 0.6,
                        child: Column(
                          children: [
                            Text(
                                "Cross-posting to the hive blockchain is possible by linking your account via hivesigner.",
                                style: Theme.of(context).textTheme.bodyText1),
                            SizedBox(height: 8),
                            Text(
                                "This does not include voting, commenting or any other functionality of the hive blockchain.",
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                      ),
                      HiveSignerButton(),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              InputChip(
                backgroundColor: widget.justSaved ? Colors.green : globalBlue,
                avatar: FaIcon(widget.justSaved
                    ? FontAwesomeIcons.checkSquare
                    : FontAwesomeIcons.save),
                shadowColor: globalBlue,
                label: Text('save settings'),
                onPressed: () {
                  Map<String, String> newSettings = {
                    sec.settingKey_defaultVotingWeight: _defaultVote.toString(),
                    sec.settingKey_defaultVotingWeightComments:
                        _defaultVoteComments.toString(),
                    sec.settingKey_defaultVotingTip: _defaultTip.toString(),
                    sec.settingKey_defaultVotingTipComments:
                        _defaultTipComments.toString(),
                    sec.settingKey_showHidden: _showHidden,
                    sec.settingKey_showNSFW: _showNsfw
                  };
                  _settingsBloc.add(PushSettingsEvent(newSettings));
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new MyApp();
                  }));
                },
              ),
            ],
          ),
        ));
  }

  void _launchURL(String externalUrl) async => await canLaunch(externalUrl)
      ? await launch(externalUrl)
      : throw 'Could not launch $externalUrl';
}

// TODO: extract logic to its own bloc
class HiveSignerButton extends StatefulWidget {
  const HiveSignerButton({
    Key? key,
  }) : super(key: key);

  @override
  _HiveSignerButtonState createState() => _HiveSignerButtonState();
}

class _HiveSignerButtonState extends State<HiveSignerButton> {
  String _status = 'notset'; // notset, invalid, valid

  @override
  void initState() {
    super.initState();
  }

  void authenticate() async {
    final callbackUrlScheme = 'dtubetogo';
    final _redirectUrlHTMLencoded = 'dtubetogo%3A%2F%2Foauth2redirect';
    final url =
        'https://hivesigner.com/oauth2/authorize?client_id=dtubemobile&redirect_uri=${_redirectUrlHTMLencoded}&scope=vote,comment';
    try {
      final result = await FlutterWebAuth.authenticate(
          url: url, callbackUrlScheme: callbackUrlScheme);

      Uri _uri = Uri.parse(result);
      String _accessToken = _uri.queryParameters['access_token'].toString();
      String _expiresIn = _uri.queryParameters['expires_in'].toString();

      String _accessTokenRequestedOn = new DateTime.now().toString();

      await sec.persistHiveSignerData(
          _accessToken, _expiresIn, _accessTokenRequestedOn);
    } on PlatformException catch (e) {
      setState(() {
        _status = 'Got error: $e';
        print("error: " + e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InputChip(
          elevation: 2,
          backgroundColor: _status == "valid" ? Colors.green : globalRed,
          avatar: FaIcon(
            _status == "valid"
                ? FontAwesomeIcons.check
                : _status == "invalid"
                    ? FontAwesomeIcons.undo
                    : FontAwesomeIcons.play,
            size: 10,
          ),
          label: Text("hivesigner"),
          onPressed: () {
            this.authenticate();
          },
        ),
        Text(_status == "valid"
            ? "you are already connected"
            : _status == "invalid"
                ? "you need to renew your connection"
                : "not connected yet")
      ],
    );
  }
}
