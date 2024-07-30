import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category_details/category_details_cubit.dart';
import 'package:kotobekia/controller/category_details/category_details_states.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/modules/category_details/component/contact_card.dart';
import 'package:kotobekia/modules/category_details/component/details_card.dart';
import 'package:kotobekia/modules/category_details/component/important_info_flag.dart';
import 'package:kotobekia/modules/category_details/component/interaction_card.dart';
import 'package:kotobekia/modules/category_details/component/row_details.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/modules/home/component/add_section.dart';
import 'package:kotobekia/shared/component/handle_time.dart';
import 'package:kotobekia/shared/component/small_loading_indicator.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:solar_icons/solar_icons.dart';

class CategoryDetailsScreen extends StatelessWidget {
  const CategoryDetailsScreen({
    super.key,
    required this.id,
    required this.isVerified,
    required this.title,
    required this.description,
    required this.images,
    this.postType,
    required this.price,
    required this.grade,
    required this.bookEdition,
    required this.educationLevel,
    this.postStatus,
    required this.views,
    this.feedback,
    required this.numberOfBooks,
    required this.semester,
    required this.educationType,
    required this.location,
    required this.city,
    this.identificationNumber,
    required this.createdAt,
    this.updatedAt,
    required this.postId,
    required this.recieverId,
    required this.fullName,
    required this.gender,
    required this.emailOrPhone,
     this.viewProfile=true,
  });

  // final int postIndex;
  // final int categoryIndex;
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String? postType;
  final dynamic price;
  final String grade;
  final String bookEdition;
  final String educationLevel;
  final String? postStatus;
  final int views;
  final String? feedback;
  final int numberOfBooks;
  final String semester;
  final String educationType;
  final String location;
  final String city;
  final String? identificationNumber;
  final dynamic createdAt;
  final DateTime? updatedAt;
  final int postId;
  final String fullName;
  final String gender;
  final String recieverId;
  final bool viewProfile;
  final bool isVerified;
  final String emailOrPhone;
  @override
  Widget build(BuildContext context) {

    late String time;
    final locale = AppLocalizations.of(context);
    if(createdAt is DateTime){
      time =getTimeDifference(createdAt,locale);

    }


    //  to show returned education level based on the user's locale
    final reversEducationLevels = {
      '655b4ec133dd362ae53081f7': locale.kindergarten,
      '655b4ecd33dd362ae53081f9': locale.primary,
      '655b4ee433dd362ae53081fb': locale.preparatory,
      '655b4efb33dd362ae53081fd': locale.secondary,
      '655b4f0a33dd362ae53081ff': locale.general,
    };

    //  to show returned grade based on the user's locale
    final reversedGrades = {
      'grade_one': locale.grade_one,
      'grade_two': locale.grade_two,
      'grade_three': locale.grade_three,
      'grade_four': locale.grade_four,
      'grade_five': locale.grade_five,
      'grade_six': locale.grade_six,
    };
    //  to show returned semester based on the user's locale
    final reversedSemesters = {
      'first': locale.first,
      'second': locale.second,
      'both': locale.both,
    };
//  to show returned education type based on the user's locale
    final reversedEducationType = {
      'general': locale.general_type,
      'azhar': locale.azhar,
      'other': locale.any_type,
    };
    SwiperController swiperController = SwiperController();

    if(CacheHelper.getData(key: AppConstant.token)!=null){
      FavoritesCubit.get(context).getFavPosts(postId: id);
    }
    return BlocConsumer<CategoryDetailsCubit, CategoryDetailsStates>(
      listener: (context, state) {
        if(state is SuccessSendReportState){
          Navigator.pop(context);
          snackBarMessage(context: context,
              displayBottom: false,
              message: state.message,
              snackbarState: SnackbarState.success,
              duration: const Duration(seconds: 2));
        }else if(state is FailureSendReportState){
          Navigator.pop(context);
          snackBarMessage(context: context,
              displayBottom: false,
              message: state.error,
              snackbarState: SnackbarState.error,
              duration: const Duration(seconds: 2));
        }
      },
      builder: (context, state) {
        final cubit = CategoryDetailsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
              leading: BuildBackIcon(onTap: () {
                cubit.changeIndexImage(0);
                Navigator.pop(context);
              }),
              title: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              )),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 190.h,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) {
                            return Scaffold(
                              appBar: AppBar(
                                leading: IconButton(
                                  icon: Padding(
                                    padding: EdgeInsets.only(right: 14.w),
                                    child: const Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                backgroundColor: Colors.black,
                                // Make the app bar transparent
                                elevation: 0, // Remove the shadow
                              ),
                              body: PhotoViewGallery.builder(
                                itemCount: images.length,
                                builder: (context, index) {
                                  return PhotoViewGalleryPageOptions(
                                    imageProvider: NetworkImage(
                                        "${AppConstant.imageUrl}${images[index]}"),
                                    minScale: PhotoViewComputedScale.contained,
                                    maxScale:
                                        PhotoViewComputedScale.covered * 2,
                                    heroAttributes: PhotoViewHeroAttributes(
                                        tag:   "${AppConstant.imageUrl}${images[index]}"),
                                  );
                                },
                                scrollPhysics: const BouncingScrollPhysics(),
                                backgroundDecoration: const BoxDecoration(
                                  color:
                                      Colors.black, // Initial background color
                                ),
                                pageController: PageController(
                                    initialPage: cubit.currentIndex),
                                onPageChanged: (index) {
                                  // You can handle page changes if needed
                                },
                              ),
                            );
                          },
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                    child: Swiper(
                      loop: false,
                      controller: swiperController,
                      transformer: ScaleAndFadeTransformer(
                          fade: BorderSide.strokeAlignCenter, scale: 1),
                      index: cubit.currentIndex,
                      viewportFraction: 0.96,
                      scale: 1.1,
                      onIndexChanged: (index) {
                        cubit.changeIndexImage(index);
                        print(index);
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          clipBehavior: Clip.hardEdge,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14)),
                          width: double.infinity,
                          height: 190.h,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Hero(
                                tag:'post$id',

                                child: Image.network(
                                  "${AppConstant.imageUrl}${images[index]}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                left: 0,
                                bottom: 0,
                                height: 40.h,
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: const Color(0xFFD7D7D8)
                                          .withOpacity(0.5)),
                                  margin: EdgeInsets.all(8.w),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${images.length} ${locale.images}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                ),
                              ),
                              BlocBuilder<FavoritesCubit, FavoritesStates>(
                                builder: (ctx, state) {
                                  final cubit = context.read<FavoritesCubit>();
                                  return Positioned(
                                    right: 6,
                                    bottom: 6,
                                    width: 32.w,
                                    height: 32.w,
                                    child: InkWell(
                                      onTap: () {
                                        if (HelperFunctions
                                            .hasUserRegistered()) {
                                          if (cubit.check) {
                                            cubit.removeFromFavorites(id);
                                          }else{
                                            cubit.addToFavorites(id);
                                          }
                                        } else {
                                          Navigator.pushNamed(
                                              context, 'getStart');
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: ColorConstant.linearColor,
                                        ),
                                        alignment: Alignment.center,
                                        child:state is! GetFavPostsSuccessState
                                        &&cubit.favPostsModel!=null
                                            ?
                                        const BuildSmallLoadingIndicator()
                                        :
                                          Icon(
                                            cubit.check?
                                            SolarIconsBold.heart
                                                :SolarIconsOutline.heart,
                                          color: cubit.check?
                                          ColorConstant.dangerColor
                                              : const Color(0xFFD7D7D8),
                                          size: 24.w,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 52.h,
                  margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        cubit.changeIndexImage(index);
                        swiperController.move(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: cubit.currentIndex == index
                                    ? Colors.blue
                                    : Colors.white,
                                width: 2.w),
                            borderRadius: BorderRadius.circular(12.r)),
                        width: 52.h,
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: ClipRRect(
                          clipBehavior: Clip.antiAlias,
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            "${AppConstant.imageUrl}${images[index]}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15..h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          BuildCardDetails(
                            description: description,
                            cityLocation: city,
                            price: price.toString(),
                            time: createdAt is DateTime ?time:createdAt,
                            title: title,
                          ),
                          Positioned(
                              top: 0,
                              left: CacheHelper.getData(
                                          key: AppConstant.languageKey) !=
                                      'ar'
                                  ? 10
                                  : null,
                              right: CacheHelper.getData(
                                          key: AppConstant.languageKey) ==
                                      'ar'
                                  ? 10
                                  : null,
                              child: const BuildImportantInfoFlag())
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        AppLocalizations.of(context).book_details,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 15.sp),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      if (reversedGrades[grade] != null)
                        BuildRowDetails(
                          isLast:
                              reversedEducationType[educationType] == null &&
                                      bookEdition.isEmpty &&
                                      reversedSemesters[semester] == null
                                  ? false
                                  : true,
                          firstText: locale.grade,
                          secondText: reversedGrades[grade]!,
                        ),
                      if (reversedEducationType[educationType] != null)
                        BuildRowDetails(
                          isLast: bookEdition.isEmpty &&
                                  reversedSemesters[semester] == null
                              ? false
                              : true,
                          firstText: locale.education_type,
                          secondText: reversedEducationType[educationType]!,
                        ),
                      if (bookEdition.isNotEmpty)
                        BuildRowDetails(
                          isLast: reversedSemesters[semester] == null
                              ? false
                              : true,
                          firstText: locale.education_year,
                          secondText: bookEdition,
                        ),
                      if (reversedSemesters[semester] != null)
                        BuildRowDetails(
                          isLast: false,
                          firstText: locale.term,
                          secondText: reversedSemesters[semester]!,
                        ),
                      SizedBox(
                        height: 25.h,
                      ),
                      BuildInteractionCard(
                        userId: recieverId,
                        postId: id,
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      if(recieverId!=CacheHelper.getData(key: AppConstant.userId)||
                          CacheHelper.getData(key: AppConstant.userId)==null
                      )
                        BuildContactCard(
                          image: images[0],
                          emailOrPhone: emailOrPhone,
                          price: price.toString(),
                          categoryPost:description ,
                        titlePost:title ,
                        isVerified:isVerified,
                        viewProfile: viewProfile,
                       name: fullName,
                        receiverId: recieverId,
                        male: gender == 'male' ? true : false,
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      const BuildAddsSection(
                        imageUrl:
                            'https://kotobekia.vercel.app/assets/slider.png',
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
