import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/home/home_state.dart';
import 'package:kotobekia/modules/category_details/category_details_screen.dart';
import 'package:kotobekia/modules/home/component/card_to_posts.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/component/handle_time.dart';
import 'package:kotobekia/shared/component/search_text_form_field.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen(
      {super.key, required this.searchController, required this.focusNode});

  final TextEditingController searchController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    var favCubit = FavoritesCubit.get(context);
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        final locale = AppLocalizations.of(context);
        final font = Theme.of(context).textTheme;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 50.h,
            leading: BuildBackIcon(onTap: () {
              focusNode.unfocus();
              cubit.searchPostsBook.clear();
              Navigator.pop(context);
            }),
            title: BuildSearchTextFormField(
              focusNode: focusNode,
              hintText: locale.searchType,
              searchController: searchController,
              onChange: (String? value) {
                cubit.searchPostsBook.clear();
                cubit.getSearchBook(title: value!);

              },
            ),
          ),
          body: state is SuccessSearchState && cubit.searchPostsBook.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        color: Colors.red,
                        size: 50.w,
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        locale.noMatch,
                        style: font.titleMedium,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        locale.trySearchAgain,
                        style: font.bodyMedium!.copyWith(color: Colors.grey),
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    if (state is LoadingSearchState)
                      Padding(
                        padding: EdgeInsets.all(12.h),
                        child: const LinearProgressIndicator(
                          color: ColorConstant.primaryColor,
                        ),
                      ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (state is SuccessSearchState &&
                        cubit.searchPostsBook.isNotEmpty)
                      BlocBuilder<FavoritesCubit, FavoritesStates>(
                        builder: (context, favState) {
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4.h),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 270.h,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: cubit.searchPostsBook.length,
                                itemBuilder: (ctx, index) {
                                  bool isFav = false;
                                  if (favCubit.favPostsModel != null) {
                                    for (var element
                                        in favCubit.favPostsModel!.result!) {
                                      if (cubit.searchPostsBook[index].sId ==
                                          element.id) {
                                        isFav = true;
                                        break;
                                      }
                                    }
                                  }

                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 4.h,
                                    ),
                                    child: BuildPosts(
                                      postStatus: cubit.searchPostsBook[
                                      index].postStatus!,
                                      isFavourite: isFav,
                                      id: cubit.searchPostsBook[index].sId!,
                                      title:
                                          cubit.searchPostsBook[index].title!,
                                      image: cubit
                                          .searchPostsBook[index].images!,
                                      price: int.parse(
                                          cubit.searchPostsBook[index].price!),
                                      description: cubit
                                          .searchPostsBook[index].description!,
                                      educationLevel: cubit
                                          .searchPostsBook[index]
                                          .educationLevel!,
                                      cityLocation:
                                          cubit.searchPostsBook[index].city ??
                                              '',
                                      numberOfBooks: cubit
                                          .searchPostsBook[index]
                                          .numberOfBooks!,
                                      numberOfWatcher:
                                          cubit.searchPostsBook[index].views!,
                                      timeSince: DateTime.parse(cubit
                                          .searchPostsBook[index].createdAt!),
                                      imageWidth: 150.w,
                                      imageHeight: 135.h,
                                      borderRadius: BorderRadius.circular(14),
                                      cardElevation: 2,
                                      // height: 275.h,
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      contentPadding: EdgeInsets.all(8.w),
                                      cardBorder: Border.all(
                                          color: const Color(0xFFEDEDED)),
                                      onTap: () => Navigator.push(
                                        ctx,
                                        MaterialPageRoute(
                                          builder: (ctx) =>
                                              CategoryDetailsScreen(
                                                emailOrPhone:cubit
                                                    .searchPostsBook[index].createdBy!
                                                    .phoneNumber??cubit
                                                    .searchPostsBook[index].createdBy!
                                                    .email!,
                                                isVerified:cubit
                                                    .searchPostsBook[index].createdBy!
                                                    .isVerified!,
                                            id: cubit
                                                .searchPostsBook[index].sId!,
                                            title: cubit
                                                .searchPostsBook[index].title!,
                                            description: cubit
                                                .searchPostsBook[index]
                                                .description!,
                                            images: cubit
                                                .searchPostsBook[index].images!,
                                            price: int.parse(cubit
                                                .searchPostsBook[index].price!),
                                            grade: cubit
                                                .searchPostsBook[index].grade!,
                                            bookEdition: cubit
                                                .searchPostsBook[index]
                                                .bookEdition!,
                                            educationLevel: cubit
                                                .searchPostsBook[index]
                                                .educationLevel!,
                                            views: cubit
                                                .searchPostsBook[index].views!,
                                            numberOfBooks: cubit
                                                .searchPostsBook[index]
                                                .numberOfBooks!,
                                            semester: cubit
                                                .searchPostsBook[index]
                                                .educationTerm!,
                                            educationType: cubit
                                                .searchPostsBook[index]
                                                .educationType!,
                                            location: cubit
                                                .searchPostsBook[index]
                                                .location!,
                                            city: cubit
                                                .searchPostsBook[index].city!,
                                            createdAt: getTimeDifference(
                                                DateTime.parse(cubit
                                                    .searchPostsBook[index]
                                                    .createdAt!),locale),
                                            postId: cubit
                                                .searchPostsBook[index].postId!,
                                            fullName: cubit
                                                .searchPostsBook[index]
                                                .createdBy!
                                                .fullName!,
                                            gender: cubit.searchPostsBook[index]
                                                .createdBy!.gender!,
                                            recieverId: cubit
                                                .searchPostsBook[index]
                                                .createdBy!
                                                .sId!,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    if (state is! SuccessSearchState &&
                        cubit.searchPostsBook.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 180.h),
                        child: Center(
                          child: Text(
                            locale.searchByKeyword,
                            style:
                                font.headlineMedium!.copyWith(fontSize: 20.sp),
                          ),
                        ),
                      )
                  ],
                ),
        );
      },
    );
  }
}
