import 'package:chat_app/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../firebase_options.dart';

final getIt = GetIt.instance;

Future<void> setupServicesLocator()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getIt.registerLazySingleton(()=> AppRouter());
}