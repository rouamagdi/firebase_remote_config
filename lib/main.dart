import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:remote_config/screens/welcome.dart';



void main() {
   WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
    debugShowCheckedModeBanner: false,
      title: 'Remote Config Example',
      home: FutureBuilder<FirebaseRemoteConfig>(
        future: setupRemoteConfig(),
        builder: (BuildContext context,
            AsyncSnapshot<FirebaseRemoteConfig> snapshot) {
          return snapshot.hasData
              ? WelcomeWidget(remoteConfig: snapshot.requireData)
              : Container();
        },
      )));
}
