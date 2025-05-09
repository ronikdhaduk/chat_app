import 'package:chat_app/data/repository/auth_repository.dart';
import 'package:chat_app/data/repository/contact_repository.dart';
import 'package:chat_app/logic/cubits/auth/auth_cubit.dart';
import 'package:chat_app/router/app_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../../firebase_options.dart';
import '../../logic/cubits/chat/chat_cubit.dart';
import '../repository/chat_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServicesLocator()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getIt.registerLazySingleton(()=> AppRouter());
  getIt.registerLazySingleton<FirebaseFirestore>(()=> FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseAuth>(()=> FirebaseAuth.instance);
  getIt.registerLazySingleton(()=> AuthRepository());
  getIt.registerLazySingleton(()=> ContactRepository());
  getIt.registerLazySingleton(() => ChatRepository());
  getIt.registerLazySingleton(()=> AuthCubit(authRepository: AuthRepository()));
  getIt.registerFactory(() => ChatCubit(chatRepository: ChatRepository(), currentUserId: getIt<FirebaseAuth>().currentUser!.uid,),);

}