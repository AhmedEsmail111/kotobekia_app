import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category/category_cubit.dart';
import 'package:kotobekia/controller/category/category_states.dart';
import 'package:kotobekia/models/post_model/post_model.dart';
import 'package:kotobekia/modules/category_book/component/filter.dart';
import 'package:kotobekia/modules/category_book/component/grid.dart';
import 'package:kotobekia/modules/category_book/component/list.dart';
import 'package:kotobekia/shared/component/shimmer_loading.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/modules/home/component/dignity_flag.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:solar_icons/solar_icons.dart';

class CategoryBooksScreen extends StatelessWidget {
  const CategoryBooksScreen({
    super.key,
    required this.category,
    required this.categoryIndex,
  });

  final int categoryIndex;
  final String category;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    CategoryCubit.get(context).handleScroll(
      category: levels[categoryIndex],
      context: context,
      noInternet: locale.no_internet,
      weakInternet: locale.weak_internet,
      noMore: locale.no_more_message,
    );
    CategoryCubit.get(context).getCategory(
      category: levels[categoryIndex],
      context: context,
      noInternet: locale.no_internet,
      weakInternet: locale.weak_internet,
      noMore: locale.no_more_message,
    );
    final viewsDropDown = {
      locale.priceLowToHigh: 'priceLowToHigh',
      locale.priceHighToLow: 'priceHighToLow',
      locale.viewsHighToLow: 'viewsHighToLow',
      locale.viewsLowToHigh: 'viewsLowToHigh',
      locale.latest: 'latest',
      locale.oldest: 'oldest',
    };
    var font = Theme.of(context).textTheme;
    return BlocConsumer<CategoryCubit, CategoryStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        final categoryCubit = CategoryCubit.get(context);
        return PopScope(
          onPopInvoked: (_) async {
            categoryCubit.posts = [];
            categoryCubit.isThereOtherData = true;
            categoryCubit.page = 1;
            categoryCubit.changeLayout(true);
            categoryCubit.resetBoxFilter();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: BuildBackIcon(onTap: () {
                categoryCubit.resetBoxFilter();
                Navigator.pop(context);
              }),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(5),
                child: Container(),
              ),
            ),
            body:state is GetCategoryDataLoadingState
            && state.isFirstFetch
                ?
            Column(
              children: [
                Skeleton(
                    height: 30.h,
                    border: 0,
                    width: double.infinity),
                Padding(
                  padding:  EdgeInsets.all(14.h),
                  child: Column(children: [
                    Row(children: [
                      Skeleton(height: 20.h, width: 70.w),
                      const Spacer(),
                      Skeleton(height: 40.h, width: 40.w),
                    ],),
                    SizedBox(height: 10.h,),
                    Row(children: [
                      Skeleton(height: 20.h, width: 85.w),
                      const Spacer(),
                      Skeleton(height: 20.h, width: 50.w),
                    ],),

                  ],),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 260.h
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (ctx, index) {
                      return Card(
                          elevation: 0.1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r)
                          ),
                          child: Shimmer.fromColors(
                            baseColor: Colors.black,
                            highlightColor: Colors.blue[100]!,
                            child: Padding(
                              padding:  EdgeInsets.all(6.h),
                              child: const BuildBookShimmer(),
                            ),
                          ));
                    },
                  ),
                ),
              ],
            ): SafeArea(
              child: Column(
                children: [

                  BuildPalestine(text: locale.palestine_2),
                  Container(
                    margin: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        IconButton(
                          onPressed: () {
                            categoryCubit.changeLayout(!categoryCubit.isGrid);
                          },
                          icon: !categoryCubit.isGrid
                              ? Icon(
                                  SolarIconsOutline.widget,
                                  size: 32.w,
                                )
                              : Icon(
                                  SolarIconsOutline.hamburgerMenu,
                                  size: 32.w,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                // Return a widget that represents the contents of the bottom sheet
                                return BuildBoxFilter(
                                  categoryIndex: categoryIndex,
                                );
                              },
                            );
                          },
                          child: Row(
                            children: [
                              Text(locale.postFilter,style: font.bodyMedium,),
                              SizedBox(
                                width: 5.w,
                              ),
                              const Icon(SolarIconsOutline.filter),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            final double leftOffset = CacheHelper.getData(key: AppConstant.languageKey)=='en' ? 16.w : 0;
                            final double rightOffset =CacheHelper.getData(key: AppConstant.languageKey)!='en'  ? 16.w : 0;
                            final RelativeRect position = RelativeRect.fromLTRB(leftOffset ,160.h,rightOffset, 0); // Adjust these values as needed
                            showMenu<String>(
                              context: context,
                              position: position,
                              elevation: 5,
                              items: viewsDropDown.keys.map((String value) {
                                return PopupMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: font.bodyMedium,),
                                );
                              }).toList(),
                            ).then((value) {
                              if (value != null) {
                               categoryCubit.changeBoxFilter(Filter.sort, viewsDropDown[value]);
                               categoryCubit.getSpecificLevelEducation(categoryIndex);
                              }
                            });
                          },
                          child:  Row(
                            children: [
                              Text(locale.sortBy,style: font.bodyMedium,),
                              SizedBox(
                                width: 5.w,
                              ),
                              const Icon(SolarIconsOutline.arrowDown),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                  SizedBox(
                    height: 15.h,
                  ),


                  if (categoryCubit.posts.isEmpty &&
                      (state is GetEducationLevelSuccessState ||
                          state is ChangeLayoutCategoryState) &&
                      categoryCubit.specificCategoryModel != null)
                    Padding(
                      padding: EdgeInsets.only(top: 60.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            SolarIconsOutline.book2,
                            size: 30.r,
                            color: ColorConstant.dangerColor,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            locale.noFoundBook,
                            style: font.titleMedium!.copyWith(fontSize: 14.sp),
                          )
                        ],
                      ),
                    ),
                  categoryCubit.isGrid
                      ? BuildGrid(
                          data: categoryCubit.posts,
                        )
                      : BuildList(
                          data: categoryCubit.posts,
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
