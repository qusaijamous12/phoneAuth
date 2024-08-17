import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoneandnotification/firebase_options.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/cubit.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/login_screen.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/otb_screen/otb_Screen.dart';
import 'package:phoneandnotification/shared.dart';
import 'package:phoneandnotification/test_screen.dart';

import 'observer.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  Bloc.observer = MyBlocObserver();
  await SharedHelper.init();
  phoneToken=SharedHelper.getData(key: 'phoneToken');
  print(phoneToken);

  Widget ?widget;
  if(phoneToken!=null){
    widget=TestScreen();
  }
  else
    {
      widget=Loginscreen();
    }

  runApp( MyApp(StartApp: widget,));

}

class MyApp extends StatelessWidget {
   MyApp({super.key,
  this.StartApp
  });

  Widget ?StartApp;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context)=>AppCubit()..getToken()),
      ],
        child:const MaterialApp(
         title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        home: TestScreen()
      ),
    );
  }
}
