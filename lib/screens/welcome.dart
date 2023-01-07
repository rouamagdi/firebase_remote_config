import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomeWidget extends AnimatedWidget {
  WelcomeWidget({
    required this.remoteConfig,
  }) : super(listenable: remoteConfig);

  final FirebaseRemoteConfig remoteConfig;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(int.parse( remoteConfig.getString('color'))),
      appBar: AppBar(
        backgroundColor:Colors.white, 
        title: const Text('Remote Config Example',style: TextStyle(color: Colors.black),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome ${remoteConfig.getString('welcome')}'),
            const SizedBox(
              height: 20,
            ),
             Text('Hello ${remoteConfig.getString('hello')}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Using zero duration to force fetching from remote server.
            await remoteConfig.setConfigSettings(RemoteConfigSettings(
              fetchTimeout: const Duration(seconds: 10),
              minimumFetchInterval: Duration.zero,
            ));
            await remoteConfig.fetchAndActivate();
          } on PlatformException catch (exception) {
            // Fetch exception.
            print(exception);
          } catch (exception) {
            print(
                'Unable to fetch remote config. Cached or default values will be '
                'used');
            print(exception);
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

Future<FirebaseRemoteConfig> setupRemoteConfig() async {
  await Firebase.initializeApp(
   );
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 10),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(<String, dynamic>{
    'welcome': 'to Remote Config',
    'hello': 'default hello',
    'color': 0xffFFBF00,
    
  });
  RemoteConfigValue(null, ValueSource.valueStatic);
  return remoteConfig;
}