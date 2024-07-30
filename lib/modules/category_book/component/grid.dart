import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category/category_cubit.dart';
import 'package:kotobekia/controller/category/category_states.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/models/post_model/post_model.dart';
import 'package:kotobekia/modules/category_details/category_details_screen.dart';
import 'package:kotobekia/modules/home/component/card_to_posts.dart';
import 'package:kotobekia/shared/component/handle_time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildGrid extends StatelessWidget {
  const BuildGrid({
    super.key,
    required this.data,
  });
  final List<Post> data;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    var favCubit=FavoritesCubit.get(context);
    return BlocBuilder<FavoritesCubit,FavoritesStates>(
      builder: (context, state) => Expanded(
        child: BlocBuilder<CategoryCubit, CategoryStates>(
          builder: ((context, state) {
            final categoryCubit = CategoryCubit.get(context);

            return GridView.builder(
              controller: categoryCubit.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
               mainAxisExtent: 265.h,
              ),
              physics: const BouncingScrollPhysics(),
              // isLoading will only be true when he tries to fetch other pages(more date)
              itemCount: data.length
              ,
              itemBuilder: (ctx, index) {
                bool isFav=false;
                if(favCubit.favPostsModel!=null){
                  for (var element in favCubit.favPostsModel!
                      .result!) {
                    if(data[index]
                        .id==element.id){
                      isFav=true;
                      break;
                    }
                  }
                }
                return FittedBox(
                  fit: BoxFit.contain,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 4.h,
                    ),
                    child: BuildPosts(
                      postStatus: data[index].postStatus!,
                      isFavourite: isFav,
                      onTap: () => Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (ctx) => CategoryDetailsScreen(
                            emailOrPhone:data[index]
                                .createdBy.phoneNumber??data[index]
                                .createdBy.email  ,
                            postStatus: data[index].postStatus,
                            isVerified:data[index]
                                .createdBy.isVerified ,
                            id: data[index].id,
                            title: data[index].title,
                            description: data[index].description,
                            images: data[index].images,
                            price: data[index].price,
                            grade: data[index].grade,
                            bookEdition: data[index].bookEdition,
                            educationLevel: data[index].educationLevel,
                            views: data[index].views,
                            numberOfBooks: data[index].numberOfBooks,
                            semester: data[index].semester,
                            educationType: data[index].educationType,
                            location: data[index].location,
                            city: data[index].city,
                            createdAt:
                            getTimeDifference(data[index].createdAt,locale),
                            postId: data[index].postId,
                            recieverId: data[index].createdBy.id,
                            gender: data[index].createdBy.gender,
                            fullName: data[index].createdBy.fullName,
                          ),
                        ),
                      ),
                      id: data[index].id,
                      title: data[index].title,
                      image: data[index].images,
                      price: data[index].price,
                      description: data[index].description,
                      educationLevel: data[index].educationLevel,
                      cityLocation: data[index].city,
                      numberOfBooks: data[index].numberOfBooks,
                      numberOfWatcher: data[index].views,
                      timeSince: data[index].createdAt,
                      imageWidth: 150.w,
                      imageHeight: 135.h,
                      borderRadius: BorderRadius.circular(14.r),
                      cardElevation: 2,
                      // height: 275.h,
                      width: MediaQuery.of(context).size.width / 2.2,
                      contentPadding: EdgeInsets.all(8.w),
                      cardBorder: Border.all(color: const Color(0xFFEDEDED)),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
