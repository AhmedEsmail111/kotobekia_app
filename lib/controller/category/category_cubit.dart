import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/controller/category/category_states.dart';
import 'package:kotobekia/models/category_model/specific_category_model.dart';
import 'package:kotobekia/models/post_model/post_model.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  CategoryCubit() : super(InitialCategoryState());

  static CategoryCubit get(context) => BlocProvider.of(context);

  bool isGrid = true;

  void changeLayout(status) {
    isGrid = status;
    emit(ChangeLayoutCategoryState());
  }

  List<Post> posts = [];
  int? page = 1;
  bool isLoading = false;
  bool isThereOtherData = true;
  SpecificCategoryModel? specificCategoryModel;

  Future<void> getCategory({required String category,
    required BuildContext context,
    required String noInternet,
    required String weakInternet,
    required String noMore}) async {
    if (isThereOtherData &&
        page != null &&
        await HelperFunctions.hasConnection() &&
        state is! GetCategoryDataLoadingState) {
      // isLoading will only be true when he tries to fetch other pages(more date),
      //and that does not include when he opens the category screen for the first time
      isLoading = page == 1 ? false : true;
      emit(GetCategoryDataLoadingState(isFirstFetch: page == 1));
      try {
        final response = await DioHelper.getData(
          lang: AppConstant.lang,
          url: '${ApiConstant.getSpecificCategoryMethodUrl}$category',
          query: {'page': page},
        );

        if (response.data == null) {
          emit(GetCategoryDataFailureState());
          return;
        }

        if (response.statusCode == 200) {
          specificCategoryModel = SpecificCategoryModel.fromJson(response.data);
          isLoading = false;
          posts = posts + specificCategoryModel!.posts;
          page = specificCategoryModel!.nextPage;

          isThereOtherData = page == null ? false : true;


          emit(GetCategoryDataSuccessState());
        }
      } catch (error) {
        isLoading = false;
        if (error is SocketException) {
          emit(GetCategoryDataInternetFailureState(message: weakInternet));
        }
        if (error is DioException &&
            error.type == DioExceptionType.connectionError ||
            error is DioException &&
                error.type == DioExceptionType.connectionTimeout ||
            error is DioException &&
                error.type == DioExceptionType.sendTimeout ||
            error is DioException &&
                error.type == DioExceptionType.receiveTimeout) {
          emit(GetCategoryDataInternetFailureState(message: weakInternet));
        } else {
          emit(GetCategoryDataFailureState());
        }
      }
    } else if (!await HelperFunctions.hasConnection()) {
      emit(GetCategoryDataInternetFailureState(message: noInternet));
    }
  }

  final scrollController = ScrollController();

  void handleScroll({required String category,
    required BuildContext context,
    required String noInternet,
    required String weakInternet,
    required noMore}) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          getCategory(
            category: category,
            context: context,
            noInternet: noInternet,
            weakInternet: weakInternet,
            noMore: noMore,
          );
        }
      }
    });
  }


  bool free = false;
  bool paid = false;
  bool gradeOne = false;
  bool gradeTwo = false;
  bool gradeThree = false;
  bool gradeFour = false;
  bool gradeFive = false;
  bool gradeSix = false;
  bool general = false;
  bool azhar = false;
  String sort='';
  List<String>grade=[];
  List<String>educationType=[];
  Map<String,dynamic>query={};
  void changeBoxFilter(Filter type, dynamic value) {
    if (type == Filter.free) {
      free = value;
    } else if (type == Filter.paid) {
      paid = value;
    } else if (type == Filter.gradeOne) {
      gradeOne = value;
      if(gradeOne){
        grade.add('grade_one');
      }else{
        if (grade.contains('grade_one')) {
          grade.remove('grade_one');
        }
      }
    } else if (type == Filter.gradeTwo) {
      gradeTwo = value;
      if(gradeTwo){
        grade.add('grade_two');
      }else{
        if (grade.contains('grade_two')) {
          grade.remove('grade_two');
        }
      }
    } else if (type == Filter.gradeThree) {
      gradeThree = value;
      if(gradeThree){
        grade.add('grade_three');
      }else{
        if (grade.contains('grade_three')) {
          grade.remove('grade_three');
        }
      }
    } else if (type == Filter.gradeFour) {
      gradeFour = value;
      if(gradeFour){
        grade.add('grade_four');
      }else{
        if (grade.contains('grade_four')) {
          grade.remove('grade_four');
        }
      }
    } else if (type == Filter.gradeFive) {
      gradeFive = value;
      if(gradeFive){
        grade.add('grade_five');
      }else{
        if (grade.contains('grade_five')) {
          grade.remove('grade_five');
        }
      }
    } else if (type == Filter.gradeSix) {
      gradeSix = value;
      if(gradeSix){
        grade.add('grade_six');
      }else{
        if (grade.contains('grade_six')) {
          grade.remove('grade_six');
        }
      }
    } else if (type == Filter.general) {
      general = value;
      if(general){
        educationType.add('general');
      }else{
        if (educationType.contains('general')) {
          educationType.remove('general');
        }
      }
    } else if(type == Filter.azhar) {
      azhar = value;
      if(azhar){
        educationType.add('azhar');
      }else{
        if (educationType.contains('azhar')) {
          educationType.remove('azhar');
        }
      }
    }else if(type==Filter.sort){
      sort = value;
        if (sort.isNotEmpty) {
          query.addAll({
            'sort': sort
          });
        } else {
          query.remove('sort');
        }

    }
    if(free || paid){
      query.addAll({
        'price':free?0:1
      });
    }else{
      query.remove('price');
    }
    if(educationType.isNotEmpty){
      query.addAll({
        'educationType':educationType
      });
    }else{
      query.remove('educationType');
    }
    if(grade.isNotEmpty){
      query.addAll({
        'grade':grade
      });
    }else{
      query.remove('grade');
    }
    emit(ChangeBoxFilterSuccessState());
  }

  void resetBoxFilter() {
    free = false;
    paid = false;
    gradeOne = false;
    gradeTwo = false;
    gradeThree = false;
    gradeFour = false;
    gradeFive = false;
    gradeSix = false;
    general = false;
    azhar = false;
    query.clear();
    educationType.clear();
    grade.clear();
    sort='';
    emit(ChangeBoxFilterSuccessState());
  }

  void getSpecificLevelEducation(int categoryIndex) {
    query.addAll({
      'page':1
    });
   isLoading = page == 1 ? false : true;
    emit(GetEducationLevelLoadingState(isFirstFetch: page == 1));
    DioHelper.getData(
      query:query,
        url: ApiConstant.getSpecificEducationLevel + levels[categoryIndex],
        lang:AppConstant.lang).
    then((value) {

      specificCategoryModel = SpecificCategoryModel.fromJson(value.data);
      isLoading = false;
      posts.clear();
      posts = posts + specificCategoryModel!.posts;
      page = specificCategoryModel!.nextPage;
      isThereOtherData = page == null ? false : true;
      emit(GetEducationLevelSuccessState());
    }).catchError((error){
      emit(GetEducationLevelFailureState());
    });
  }


}

enum Filter {
  free,
  paid,
  gradeOne,
  gradeTwo,
  gradeThree,
  gradeFour,
  gradeFive,
  gradeSix,
  general,
  azhar,
  sort
}