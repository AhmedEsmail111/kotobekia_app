import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/models/fav_posts_model/fav_posts_model.dart';
import 'package:kotobekia/shared/component/toast_message.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';

class FavoritesCubit extends Cubit<FavoritesStates> {
  FavoritesCubit() : super(InitialFavoritesState());

  static FavoritesCubit get(context) => BlocProvider.of(context);


  FavPostsModel? favPostsModel;

  void getFavPosts({String ?postId}) async {
    if (await HelperFunctions.hasConnection() &&
        HelperFunctions.hasUserRegistered()) {
      emit(GetFavPostsLoadingState());
      DioHelper.getData(
        lang: AppConstant.lang,
          url: ApiConstant.getFavPostsMethodUrl,
          token: CacheHelper.getData(key: AppConstant.token)).
      then((value) {
        favPostsModel = FavPostsModel.fromJson(value.data);
        if(postId!=null){
          checkFav(postId);
        }
        emit(GetFavPostsSuccessState());
      }).catchError((error) {
        if(error is DioError){
          print(error.response!.data['msgError']);
        }
        else{
          print(error.toString());
        }
        emit(GetFavPostsFailureState());
      });
    } else if (!await HelperFunctions.hasConnection()) {
      emit(GetFavPostsInternetFailureState());
    }
  }
  bool check=false;
  void checkFav(String id){
    check=false;
    for (var element in favPostsModel!.result!) {
      if(element.id==id){
        for (var element in element.userFavorite!) {
          if(element==CacheHelper.getData(key: AppConstant.userId))
          {
            check=true;
            break;
          }
          if(check)break;
        }

      }

    }
    emit(ChangeChcekSuccessState());
  }
  void addToFavorites(String postId) async {
    if (await HelperFunctions.hasConnection()) {
      emit(AddToFavLoadingState());
      DioHelper.postData(
        lang: AppConstant.lang,
          url: "${ApiConstant.addToFavMethodUrl}$postId",
          token: CacheHelper.getData(key: AppConstant.token)).then((
          value) {
        emit(AddToFavSuccessState());
        getFavPosts(postId: postId);
      }).catchError((error) {
        if(error is DioError){
          emit(AddToFavFailureState(error.response!.data['msgError']));
        }else{
          emit(AddToFavFailureState(error.toString()));
        }


      });
    } else {
      buildToastMessage(
          message: 'لا يوجد إتصال بالإنترنت', gravity: ToastGravity.CENTER);
    }
  }

  void removeFromFavorites(String postId) async {
    if (await HelperFunctions.hasConnection()) {
      emit(RemoveFromFavLoadingState());
      DioHelper.postData(
        lang: AppConstant.lang,
          url: "${ApiConstant.removeFromFavMethodUrl}$postId",
          token: CacheHelper.getData(key: AppConstant.token)).then((value){
         emit(RemoveFromFavSuccessState());
            getFavPosts(postId: postId);
      }).catchError((error){
        emit(RemoveFromFavFailureState());
      });
    } else {
      buildToastMessage(
          message: 'لا يوجد إتصال بالإنترنت', gravity: ToastGravity.CENTER);
    }
  }

}