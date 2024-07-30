import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/controller/profile/profile_states.dart';
import 'package:kotobekia/models/user_data_model/user_data_model.dart';
import 'package:kotobekia/shared/component/authentication/gender_row_in_auth.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(InitialProfileState());

  static ProfileCubit get(context) => BlocProvider.of(context);



  bool hasAccount =
      CacheHelper.getData(key: AppConstant.token) != null ? true : false;
  void signOut() async {
    await CacheHelper.removeData(key: AppConstant.token);
    await CacheHelper.removeData(key: AppConstant.userId);
    await CacheHelper.removeData(key: AppConstant.convId);
    await CacheHelper.removeData(key: AppConstant.reciveId);

    hasAccount = false;
    emit(SignOutState());
  }

  void setUser(String? token) {
    if (token != null) {
      hasAccount = true;
    } else {
      hasAccount = false;
    }
    emit(SetUserState());
  }

  bool isDarkMode = true;



  void toggleDarkMode() {
    isDarkMode = !isDarkMode;
    CacheHelper.saveData(key: AppConstant.mode, value: isDarkMode);
    emit(ToggleDarkModeState());
  }

  UserDataModel? userDataModel;

  void getUser() async {
    if (hasAccount) {
      try {
        emit(GetUserDataLoadingState());
        final token = CacheHelper.getData(key: AppConstant.token);
        final response = await DioHelper.getData(
          lang: AppConstant.lang,
          url: ApiConstant.getMyProfileMethodUrl,
          token: token,
        );
        if (response.statusCode == 200) {
          userDataModel = UserDataModel.fromJson(response.data);
          emit(GetUserDataSuccessState());
          if(userDataModel!.user!.gender=='male'){
            genderValue=gender.Male;
          }else{
            genderValue=gender.Female;
          }
        } else {
          emit(GetUserDataFailureState());
        }
      } catch (error) {
        emit(GetUserDataFailureState());
      }
    }
  }

  gender genderValue = gender.Male;

  void changeGender(int value) {
    if (value == 0) {
      genderValue = gender.Male;
    } else {
      genderValue = gender.Female;
    }
    emit(UserChangingGenderState());
  }



  void updateProfile({
    required String id,
    required String sex,
    required String name,
     String ?email,
    String? phone,
    required String birthDate,
  }){
    emit(LoadingUpdateUserDataState());
    DioHelper.patchData(
        lang: AppConstant.lang,
      data: {
        "fullName":name,
        "gender":sex,
        "email":email,
        "phoneNumber":phone,
        "birthDate":birthDate
      },
        url: ApiConstant.updateProfileMethodUrl+id,
        token:CacheHelper.getData(key: AppConstant.token))
        .then((value) {
      userDataModel = UserDataModel.fromJson(value.data);
      emit(SuccessUpdateUserDataState(value.data['message']!));
      if(userDataModel!.user!.gender=='male'){
        genderValue=gender.Male;
      }else{
        genderValue=gender.Female;
      }
    }).catchError((error){
      if(error is DioError){
        emit(FailureUpdateUserDataState(error.response!.data['msgError']));
      }else{
        emit(FailureUpdateUserDataState(error.toString()));
      }

    });
  }
}
