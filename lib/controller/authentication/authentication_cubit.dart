// ignore_for_file: deprecated_member_use
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';
import '../../models/identity_user_model/identity_user_model.dart';
import '../../models/user_model/user_model.dart';
import '../../shared/component/authentication/gender_row_in_auth.dart';

part 'authentication_state.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  static AuthenticationCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void userCreateAccount(
      {String? email,
      String? phone,
      required String password,
      required String name,
      required String gender,
      required String birthDate,
     }) async {
    emit(LoadingUserCreateAccountState());
    if (await HelperFunctions.hasConnection()) {
      try {
        final Response response = await DioHelper.postData(
          lang: AppConstant.lang,
          url: ApiConstant.userCreateAccountUrl,
          data: {
            'fullName': name,
            'phoneNumber': phone,
            'email': email,
            'password': password,
            'gender': gender,
            'birthDate': birthDate,
          },
        );
        Map<String, dynamic> responseData = response.data;
        userModel = UserModel.fromJson(responseData);
        emit(SuccessUserCreateAccountState(userModel!));
        getIdentityUser(token: userModel!.token!);
      } catch (error) {
        if (error is DioError) {
          Map<String, dynamic> responseData = error.response!.data;
          userModel = UserModel.fromJson(responseData);
          emit(SuccessUserCreateAccountState(userModel!));
        } else {
          emit(FailedUserCreateAccountState(error.toString()));
        }
      }
    } else {
      emit(FailedNoInternetConnectionState());
    }
  }

  void userLogin(
      {String? email,
      String? phone,
      required String password,
      }) async {
    emit(LoadingUserLoginState());
    if (await HelperFunctions.hasConnection()) {
      try {
        final Response response = await DioHelper.postData(
            lang: AppConstant.lang,
            url: ApiConstant.userLoginUrl,
            data: {'phoneNumber': phone, 'email': email, 'password': password});
        Map<String, dynamic> responseData = response.data;
        userModel = UserModel.fromJson(responseData);
        emit(SuccessUserLoginState(userModel!));
        getIdentityUser(token: userModel!.token!);
      } catch (error) {
        if (error is DioError) {
          Map<String, dynamic> responseData = error.response!.data;
          userModel = UserModel.fromJson(responseData);
          emit(SuccessUserLoginState(userModel!));
        } else {
          emit(FailedUserLoginState('there is Error'));
        }
      }
    } else {
      emit(FailedNoInternetConnectionState());
    }
  }

  bool isObscureOne = true;
  bool isObscureTwo = true;

  void changeVisiabilityPassword(int n) {
    if (n == 1) {
      isObscureOne = !isObscureOne;
    } else {
      isObscureTwo = !isObscureTwo;
    }

    emit(SuccessChangeVisibilityPasswordState());
  }

  gender genderValue = gender.Other;

  void changeGender(int value) {
    if (value == 0) {
      genderValue = gender.Male;
    } else {
      genderValue = gender.Female;
    }
    emit(SuccessChangeGenderState());
  }

  IdentityUserModel? identityUserModel;

  void getIdentityUser({
    required String token,
  }) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    identityUserModel = IdentityUserModel.fromJson(decodedToken);
    if (identityUserModel != null) {
      await CacheHelper.saveData(
          key: AppConstant.userId, value: identityUserModel!.id);
    }
  }

  void changePassword(
      {required String currentPassword,
      required String newPassword,
     }) async {
    emit(LoadingChangePasswordState());
    if (await HelperFunctions.hasConnection()) {
      DioHelper.putData(
          lang: AppConstant.lang,
          token: CacheHelper.getData(key: AppConstant.token),
          url: ApiConstant.changePasswordMethodUrl,
          data: {
            "currentPassword": currentPassword,
            "newPassword": newPassword
          }).then((value) {
        emit(SuccessChangePasswordState(value.data['message']));
      }).catchError((error) {
        if (error is DioError) {
          final responseData = error.response!.data;
          final errorMessage = responseData['msgError'];
          emit(FailedChangePasswordState(errorMessage));
        } else {
          emit(FailedChangePasswordState(error.toString()));
        }
      });
    } else {
      emit(FailedNoInternetConnectionState());
    }
  }

  void forgetPassword(
      {String? email,
      String? phone,
      required String newPassword,
     }) async {
    emit(LoadingChangePasswordState());
    if (await HelperFunctions.hasConnection()) {
      DioHelper.patchData(
          lang: AppConstant.lang,
          url: ApiConstant.forgetPassword,
          data: {
            "email": email,
            "phoneNumber": phone,
            "newPassword": newPassword
          }).then((value) {
        emit(SuccessChangePasswordState(value.data['message']));
      }).catchError((error) {
        if (error is DioError) {
          final responseData = error.response!.data;
          final errorMessage = responseData['msgError'];
          emit(FailedChangePasswordState(errorMessage));
        } else {
          emit(FailedChangePasswordState(error.toString()));
        }
      });
    } else {
      emit(FailedNoInternetConnectionState());
    }
  }

  void deleteAccount(
      {required String token,
      required String id}) async {
    emit(LoadingDeleteAccountState());
    if (await HelperFunctions.hasConnection()) {
      DioHelper.deleteData(
              lang: AppConstant.lang,
              url: ApiConstant.deleteAccountMethodUrl + id,
              token: token)
          .then((value) {
        emit(SuccessDeleteAccountState());
      }).catchError((error) {
        if (error is DioError) {
          final responseData = error.response!.data;
          final errorMessage = responseData['msgError'];
          emit(FailedDeleteAccountState(errorMessage));
        } else {
          emit(FailedDeleteAccountState(error.toString()));
        }
      });
    } else {
      emit(FailedNoInternetConnectionState());
    }
  }

  void signInWithGoogle({
    required BuildContext context,
  }) async {
    emit(LoadingSignInWithGoogleState());
      try {
        // Sign out the user to allow choosing a different Google account
        await _googleSignIn.signOut();

        // Initiate the sign-in process
        final GoogleSignInAccount? googleSignInAccount =
            await _googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final email = googleSignInAccount.email;
          final name = googleSignInAccount.displayName;

          // Dispatching signedIn state with email and name
          emit(SuccessSignInWithGoogleState(email: email, name: name!));
          sendSignInWithGoogleData(
              email: email, name: name);
        } else {
          // User canceled the sign-in process
          emit(FailedSignInWithGoogleState('Sign-in process canceled'));
        }
      } catch (error) {
        emit(FailedSignInWithGoogleState('Error when signing in with Google'));
      }

  }

  void sendSignInWithGoogleData({
    required String email,
    required String name,
  }) async {
    emit(LoadingUserAuthWithGoogleState());
    if (await HelperFunctions.hasConnection()) {
      try {
        final Response response = await DioHelper.postData(
            lang: AppConstant.lang,
            url: ApiConstant.signInWithGoogle,
            data: {'email': email, 'fullName': name});

        Map<String, dynamic> responseData = response.data;
        userModel = UserModel.fromJson(responseData);
        emit(SuccessUserAuthWithGoogleState(userModel!));
        getIdentityUser(token: userModel!.token!);
      } catch (error) {
        if (error is DioError) {
          Map<String, dynamic> responseData = error.response!.data;
          userModel = UserModel.fromJson(responseData);
          emit(SuccessUserAuthWithGoogleState(userModel!));
        } else {
          emit(FailedUserAuthWithGoogleState(error.toString()));
        }
      }
    } else {
      emit(FailedNoInternetConnectionState());
    }
  }

  void sendFcmToken()async{
    var token = await FirebaseMessaging.instance.getToken();
    DioHelper.postData(url: ApiConstant.getFcmToken,
        data: {
          'fcmToken': token
        },
        token:CacheHelper.getData(key: AppConstant.token),
        lang: 'en').then((value) {
          emit(SuccessSendFcmTokenState());
    }).catchError((error){
      print(error.toString());
      if(error is DioError){
        print(error.response!.data);
      }
      emit(FailedSendFcmTokenState(error.toString()));
    });
  }
}
