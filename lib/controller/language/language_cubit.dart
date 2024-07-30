import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/controller/language/language_states.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';

class LanguageCubit extends Cubit<LanguageStates> {
  LanguageCubit() : super(InitialLanguageState());
  static LanguageCubit get(context) => BlocProvider.of(context);

  bool arabicStatus =
      CacheHelper.getData(key: AppConstant.languageKey) == 'ar' ? true : false;
  bool englishStatus =
      CacheHelper.getData(key: AppConstant.languageKey) == 'en' ? true : false;

  void changeLanguageStatus(bool status, int num) {
    if (num == 1) {
      arabicStatus = status;
      englishStatus = !arabicStatus;
      index = num;
    } else if (num == 0) {
      englishStatus = status;
      arabicStatus = !englishStatus;
      index = num;
    }
    emit(ChangeLanguageStatusProfileState());
  }

  int ?index=CacheHelper.getData(key: AppConstant.languageKey)!=null?
  CacheHelper.getData(key: AppConstant.languageKey)=='ar'?1:0:null;
  Locale locale =
      Locale(CacheHelper.getData(key: AppConstant.languageKey) ?? 'ar');

  void setDefaultLanguage() async {
    if (index == 0 &&
        CacheHelper.getData(key: AppConstant.languageKey) != 'en') {
      await CacheHelper.saveData(key: AppConstant.languageKey, value: 'en');
      locale = const Locale('en');
    }
    if (index == 1 &&
        CacheHelper.getData(key: AppConstant.languageKey) != 'ar') {
      await CacheHelper.saveData(key: AppConstant.languageKey, value: 'ar');
      locale = const Locale('ar');
    }
    emit(SaveDefaultLanguageProfileStatus());
  }

  void changeLanguage(bool check) async {
    if (check == false) {
      index = 0;
    } else {
      index = 1;
    }
    emit(SuccessChangeCheckLanguageState());
  }
}
