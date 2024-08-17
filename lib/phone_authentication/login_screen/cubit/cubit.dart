import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phoneandnotification/phone_authentication/login_screen/cubit/state.dart';
import 'package:phoneandnotification/shared.dart';

class AppCubit extends Cubit<AppState>{

  late String verfivationId;

  AppCubit():super(InitialAppState());

  static AppCubit get(context)=>BlocProvider.of(context);

  Future<void> sumbitPhoneNumber({required String phoneNumber})async{
    emit(LoadingScreen());
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+962${phoneNumber}',
      timeout: const Duration(seconds: 30),
      verificationCompleted: verficationCompleted,
      verificationFailed: verificationFailed,
      codeSent:codeSent ,
      codeAutoRetrievalTimeout:codeAutoRetrievalTimeout ,
    );


  }

  void verficationCompleted(PhoneAuthCredential credential)async{
    print('verfication completed');
    await signIn(credential);

  }

  void verificationFailed(FirebaseAuthException e){
    print('verificationFailed!!!');
    print(e.toString());
    emit(ErrorPhoneAuthenticationState());

  }

  void codeSent(String verficationId, int ?resendToken){
    print('code send');

    this.verfivationId=verficationId;
    emit(PhoneNumberSumbited());

  }

  void codeAutoRetrievalTimeout(String verficationId){
    print('Verification Completed');

  }

  Future<void> sumbitOTP(String otpCode)async{
    PhoneAuthCredential credential=PhoneAuthProvider.credential(verificationId: this.verfivationId, smsCode: otpCode);

    print('nownownonwonownown');

    await signIn(credential);



  }

  Future<void> signIn(PhoneAuthCredential credential)async{

    try{
      await FirebaseAuth.instance.signInWithCredential(credential).then((value){
        print('****************************');
        print(value.user!.uid);
        SharedHelper.SaveData(key: 'phoneToken', value: value.user!.uid);
      });
      emit(PhoneOTPVerifiedState());
    }
    catch(error){
      print('there is error signIn');
      print(error.toString());
      emit(ErrorPhoneAuthenticationState());


    }

  }

  Future<void> logOut()async{
    await FirebaseAuth.instance.signOut().then((value){
      SharedHelper.RemoveData(key: 'phoneToken');
    });
  }

  User getLoggedInUserData(){
    User firebaseUser=FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }

  void getToken()async{
    String ?myToken=await FirebaseMessaging.instance.getToken();
    print('My token is $myToken');
  }






}