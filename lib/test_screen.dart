import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/cubit.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/state.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/login_screen.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BlocBuilder<AppCubit,AppState>(
          builder: (context,state){
            return IconButton(
              onPressed: (){
                AppCubit.get(context).logOut().then((value){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Loginscreen()), (x)=>false);
                });
              },
              icon: Icon(
                  Icons.logout
              ),
            );
          },
        ),
      ),
      body:const Center(
        child: Text(
          'Done Done Done'
        ),
      ),
    );
  }
}
