import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/cubit.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/state.dart';
import 'package:phoneandnotification/test_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {

  late final verificationId;
  dynamic otpCode;
  OtpScreen(this.verificationId);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: BlocConsumer<AppCubit,AppState>(
              listener: (context,state){
                // if(state is PhoneOTPVerifiedState){
                //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TestScreen()), (x)=>false);
                // }

              },
              builder: (context,state){
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verify Your Phone number ? ',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text:const TextSpan(
                          text: 'Enter your 6 digit code numbers sent to you at ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16

                          ),
                          children:<TextSpan> [
                            TextSpan(
                                text: '+962797313842',
                                style: TextStyle(
                                    color: Colors.blue,
                                    height: 1.4,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16
                                )
                            )

                          ]

                      ),

                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    buildPinCodeFields(context),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<AppCubit,AppState>(
                      listener: (context,state){
                        if(state is PhoneOTPVerifiedState){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TestScreen()), (x)=>false);
                        }
                      },
                      builder: (context,state){
                        return Row(

                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.circular(20),
                                  color: Colors.black

                              ),
                              child: MaterialButton(
                                onPressed: ()async{
                                  AppCubit.get(context).sumbitOTP(otpCode);


                                },
                                child:const Text(
                                  'Verify',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    )

                  ],
                );
              },
            ),
          ),
        ),
      ),

    );
  }
  Widget buildPinCodeFields(context)=>Container(
    child:PinCodeTextField(
      appContext:context,
      autoFocus: true,
      cursorColor: Colors.black,
      keyboardType: TextInputType.number,
      length: 6,
      obscureText: false,
      animationType: AnimationType.scale,
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          borderWidth: 1,
          activeColor: Colors.white,
          inactiveColor: Colors.blue,
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.lightBlue,
          selectedColor: Colors.blue,
          selectedFillColor: Colors.white
      ),
      animationDuration: Duration(milliseconds: 300),
      backgroundColor: Colors.white,
      enableActiveFill: true,
      onCompleted: (code) {
        print("Completed");
        otpCode=code;
      },
    ) ,
  );

  void _login(context){
    //AppCubit.get(context).sumbitOTP(otpCode!);
  }

}