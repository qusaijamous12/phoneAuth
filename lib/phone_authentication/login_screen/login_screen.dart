
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/cubit.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/state.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/otb_screen/otb_Screen.dart';
import 'package:phoneandnotification/test_screen.dart';

class Loginscreen extends StatefulWidget {
  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  var phoneController=TextEditingController();

  var countryController=TextEditingController();

  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    countryController.text=generateCountryFlag()+' +962 ';
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: BlocConsumer<AppCubit,AppState>(
                listener: (context,state){
                  if(state is PhoneNumberSumbited){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(AppCubit.get(context).verfivationId)));
                  }
                   if(state is PhoneOTPVerifiedState){
                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>TestScreen()), (x)=>false);
                   }

                },
                builder: (context,state){
                  return Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What is Your Phone number ? ',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Please enter your phone number to verify your account',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      buildTextFormField(),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(

                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(20),
                                color: Colors.black

                            ),
                            child: ConditionalBuilder(
                              condition:AppState is ! LoadingScreen,
                              builder:(context)=>MaterialButton(
                                onPressed: ()async{
                                  if(formKey.currentState!.validate()){
                                   // await FirebaseAuth.instance.verifyPhoneNumber(
                                   //   phoneNumber: '+'+phoneController.text,
                                   //     verificationCompleted: (PhoneAuthCredential credintial){
                                   //
                                   //
                                   //     },
                                   //     verificationFailed: (FirebaseAuthException e){
                                   //     print('*******************************');
                                   //     print('there is an error $e');
                                   //     },
                                   //     codeSent: (verficationId,forceResendingToken){
                                   //     Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(verficationId)));
                                   //     },
                                   //     codeAutoRetrievalTimeout: (verficationId){
                                   //     print('Auto Retrieval Timeout');
                                   //     });

                                    await AppCubit.get(context).sumbitPhoneNumber(phoneNumber: phoneController.text);


                                  }

                                },
                                child:const Text(
                                  'Next',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18
                                  ),
                                ),
                              ),
                              fallback:(context)=>Center(child: CircularProgressIndicator()) ,
                            ),
                          ),
                        ],
                      )


                    ],
                  ) ;
                },
              ),
            ),
          ),
        ),
      ),

    );
  }

  String generateCountryFlag(){
    String countryCode='jo';
    return countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'), (match)=>String.fromCharCode(match.group(0)!.codeUnitAt(0)+127397));
  }

  Widget buildTextFormField()=> Row(
    children: [
      Expanded(
        flex: 1,
        child: TextFormField(
          decoration:const InputDecoration(
            border: OutlineInputBorder(),

          ),
          controller: countryController,

          readOnly: true,
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      Expanded(
        flex: 2,
        child: TextFormField(
          decoration:const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Phone number',
              suffixIcon: Icon(
                  Icons.phone
              )
          ),
          validator: (String ?value){
            if(value!.isEmpty){
              return 'Please enter your phone !!';
            }
            // else if(value!.length<11){
            //   return 'your phone must be >11 !';
            // }
            return null;
          },
          keyboardType: TextInputType.number,
          controller: phoneController,
        ),
      ),
    ],
  );

  Future SignInWithPhone({
    required String phone
})async{
    return await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${phone}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential)async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
    if (e.code == 'invalid-phone-number') {
      print('The provided phone number is not valid.');
    }


      },
      codeSent: (String verificationId, int? resendToken)async {

        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

        // Sign the user in (or link) with the credential
        await FirebaseAuth.instance.signInWithCredential(credential);


      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    ).then((value){

    }).catchError((error){
      print('======================================');
      print('there is an error');
      print(error.toString());
    });

  }
}