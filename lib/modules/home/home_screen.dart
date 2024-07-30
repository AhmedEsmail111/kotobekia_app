import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/add_post/add_post_cubit.dart';
import 'package:kotobekia/controller/add_post/add_post_states.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/home/home_state.dart';
import 'package:kotobekia/controller/internet/internet-states.dart';
import 'package:kotobekia/controller/internet/internet_cubit.dart';
import 'package:kotobekia/controller/notification/notification_cubit.dart';
import 'package:kotobekia/modules/category_book/category_book_screen.dart';
import 'package:kotobekia/modules/category_details/category_details_screen.dart';
import 'package:kotobekia/modules/home/component/add_section.dart';
import 'package:kotobekia/modules/home/component/card_to_posts.dart';
import 'package:kotobekia/modules/home/component/no_book_text.dart';
import 'package:kotobekia/modules/home/component/row_above_card.dart';
import 'package:kotobekia/modules/home/component/dignity_flag.dart';
import 'package:kotobekia/modules/notification/notification_screen.dart';
import 'package:kotobekia/modules/search/search_screen.dart';
import 'package:kotobekia/shared/component/handle_time.dart';
import 'package:kotobekia/shared/component/navigation.dart';
import 'package:kotobekia/shared/component/no_internet.dart';
import 'package:kotobekia/shared/component/search_text_form_field.dart';
import 'package:kotobekia/shared/component/shimmer_loading.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/component/text_placeholder.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/socket.io.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favCubit = FavoritesCubit.get(context);
    final font = Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context);
    final FocusNode focusNode = FocusNode();
    InternetCubit.get(context).checkConnectivity();
    if (CacheHelper.getData(key: AppConstant.token) != null &&
        NotificationCubit.get(context).notificationModel == null) {
      NotificationCubit.get(context).getNotifications();
      NotificationCubit.get(context).changeStateNotify();
    }
    if (HomeCubit.get(context).homePostsModel == null) {
      HomeCubit.get(context).getHomePosts(
          noInternet: locale.no_internet, weakInternet: locale.weak_internet);
    }
    if (favCubit.favPostsModel == null) {
      favCubit.getFavPosts();
    }
    if(SocketIO.socket!.disconnected){
      SocketIO.connect();
    }
    final regionsDropDownItems = {
      locale.egypt: 'egypt',
      locale.cairo: 'cairo',
      locale.giza: 'giza',
      locale.alexandria: 'alexandria',
      locale.dakahlia: 'dakahlia',
      locale.sharqia: 'sharqia',
      locale.monufia: 'monufia',
      locale.qalyubia: 'qalyubia',
      locale.beheira: 'beheira',
      locale.port_said: 'port_said',
      locale.damietta: 'damietta',
      locale.ismailia: 'ismailia',
      locale.suez: 'suez',
      locale.kafr_el_sheikh: 'kafr_el_sheikh',
      locale.fayoum: 'fayoum',
      locale.beni_suef: 'beni_suef',
      locale.matruh: 'matruh',
      locale.north_sinai: 'north_sinai',
      locale.south_sinai: 'south_sinai',
      locale.minya: 'minya',
      locale.asyut: 'asyut',
      locale.sohag: 'sohag',
      locale.qena: 'qena',
      locale.red_sea: 'red_sea',
      locale.luxor: 'luxor',
      locale.aswan: 'aswan',
    };
    final searchController = TextEditingController();
    return BlocConsumer<AddPostCubit, AddPostStates>(
      builder: (context, state) {
        return Scaffold(
          body: BlocBuilder<InternetCubit, InternetStates>(
            builder: (context, state) {
              return !InternetCubit.get(context).isDeviceConnected ||
                      state is InternetNotConnected
                  ? const BuildNoInternet()
                  : BlocBuilder<HomeCubit, HomeStates>(
                      builder: (ctx, state) {
                        final homeCubit = HomeCubit.get(context);
                        final homePostsModel = homeCubit.homePostsModel;
                        final kinderGartenPosts = homeCubit.kindergartenPosts;
                        final primaryPosts = homeCubit.primaryPosts;
                        final preparatoryPosts = homeCubit.preparatoryPosts;
                        final secondaryPosts = homeCubit.secondaryPosts;
                        final generalPosts = homeCubit.generalPosts;
                        return NestedScrollView(
                          body: BlocBuilder<FavoritesCubit,
                              FavoritesStates>(
                            builder: (context, favState) {
                              return homePostsModel == null
                                  ? SingleChildScrollView(
                                    child: Column(
                                      children: [
                                    Skeleton(
                                        height: 30.h,
                                        border: 0,
                                        width: double.infinity),
                                    Padding(
                                      padding: EdgeInsets.all(14.h),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Skeleton(
                                              height: 115.h,
                                              width:
                                              double.infinity),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            children: [
                                              Skeleton(
                                                  height: 15.w,
                                                  width: 70.w),
                                              const Spacer(),
                                              Skeleton(
                                                  height: 20.w,
                                                  width: 90.w),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 255.h,
                                      child: ListView.separated(
                                          scrollDirection:
                                          Axis.horizontal,
                                          itemBuilder:
                                              (context, index) =>
                                              SizedBox(
                                                width: 12.w,
                                              ),
                                          separatorBuilder: (context,
                                              index) =>
                                          const BuildBookShimmer(),
                                          itemCount: 5),
                                    )
                                                                    ],
                                                                  ),
                                  )
                                  : RefreshIndicator(
                                color: ColorConstant.primaryColor,
                                onRefresh: () async {
                                  homeCubit.getHomePosts(
                                    noInternet: locale.no_internet,
                                    weakInternet:
                                    locale.weak_internet,
                                  );
                                },
                                child: SingleChildScrollView(
                                  physics:
                                  const BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      BuildPalestine(
                                          text: locale.palestine),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(
                                                14.h),
                                            child:
                                            const BuildAddsSection(
                                              imageUrl:
                                              'https://kotobekia.vercel.app/assets/slider.png',
                                            ),
                                          ),
                                          BuildRowAboveCard(
                                            isEmptySeeMore:
                                            kinderGartenPosts
                                                .isNotEmpty,
                                            title:
                                            locale.kindergarten,
                                            numberOfBooks:
                                            kinderGartenPosts
                                                .length,
                                            onTap: () =>
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          CategoryBooksScreen(
                                                            categoryIndex:
                                                            0,
                                                            category: locale
                                                                .kindergarten,
                                                          ),
                                                    )),
                                          ),
                                          if (kinderGartenPosts
                                              .isEmpty)
                                            const BuildNoBookText(),
                                          if (kinderGartenPosts
                                              .isNotEmpty)
                                            SizedBox(
                                              height: 283.h,
                                              child: state
                                              is GetHomeDataInternetFailureHomeState &&
                                                  kinderGartenPosts
                                                      .isEmpty
                                                  ? BuildTextPlaceHolder(
                                                  text: state
                                                      .message)
                                                  : Padding(
                                                padding: CacheHelper.getData(key: AppConstant.languageKey) ==
                                                    'ar'
                                                    ? EdgeInsets.only(
                                                    right: 10
                                                        .w)
                                                    : EdgeInsets.only(
                                                    left:
                                                    10.w),
                                                child: ListView.separated(
                                                  separatorBuilder: (context, index) => SizedBox(width: 15.w,),
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  itemCount:
                                                  kinderGartenPosts
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index) {
                                                    bool
                                                    isFav =
                                                    false;
                                                    if (favCubit
                                                        .favPostsModel !=
                                                        null) {
                                                      for (var element in favCubit
                                                          .favPostsModel!
                                                          .result!) {
                                                        if (kinderGartenPosts[index].id ==
                                                            element.id) {
                                                          isFav =
                                                          true;
                                                          break;
                                                        }
                                                      }
                                                    }

                                                    return BuildPosts(
                                                      postStatus:
                                                      kinderGartenPosts[index].postStatus!,
                                                      isFavourite:
                                                      isFav,
                                                      onTap: () =>
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  CategoryDetailsScreen(
                                                                    emailOrPhone: kinderGartenPosts[index].createdBy.phoneNumber??
                                                                        kinderGartenPosts[index].createdBy.email,
                                                                    isVerified: kinderGartenPosts[index].createdBy.isVerified,
                                                                    id: kinderGartenPosts[index].id,
                                                                    title: kinderGartenPosts[index].title,
                                                                    description: kinderGartenPosts[index].description,
                                                                    images: kinderGartenPosts[index].images,
                                                                    price: kinderGartenPosts[index].price,
                                                                    grade: kinderGartenPosts[index].grade,
                                                                    bookEdition: kinderGartenPosts[index].bookEdition,
                                                                    educationLevel: kinderGartenPosts[index].educationLevel,
                                                                    views: kinderGartenPosts[index].views,
                                                                    numberOfBooks: kinderGartenPosts[index].numberOfBooks,
                                                                    semester: kinderGartenPosts[index].semester,
                                                                    educationType: kinderGartenPosts[index].educationType,
                                                                    location: kinderGartenPosts[index].location,
                                                                    city: kinderGartenPosts[index].city ?? '',
                                                                    createdAt: getTimeDifference(kinderGartenPosts[index].createdAt, locale),
                                                                    postId: kinderGartenPosts[index].postId,
                                                                    recieverId: kinderGartenPosts[index].createdBy.id,
                                                                    gender: kinderGartenPosts[index].createdBy.gender,
                                                                    fullName: kinderGartenPosts[index].createdBy.fullName,
                                                                  ),
                                                            ),
                                                          ),
                                                      imageHeight:
                                                      140.h,
                                                      imageWidth:
                                                      150.w,
                                                      width:
                                                      150.w,
                                                      height:
                                                      283.h,
                                                      borderRadius:
                                                      BorderRadius.zero,
                                                      id: kinderGartenPosts[index]
                                                          .id,
                                                      title: kinderGartenPosts[index]
                                                          .title,
                                                      description:
                                                      kinderGartenPosts[index].description,
                                                      price: kinderGartenPosts[index]
                                                          .price,
                                                      image: kinderGartenPosts[index]
                                                          .images,
                                                      educationLevel:
                                                      kinderGartenPosts[index].educationLevel,
                                                      cityLocation:
                                                      kinderGartenPosts[index].city ??
                                                          '',
                                                      numberOfWatcher:
                                                      kinderGartenPosts[index].views,
                                                      numberOfBooks:
                                                      kinderGartenPosts[index].numberOfBooks,
                                                      timeSince:
                                                      kinderGartenPosts[index].createdAt,
                                                      cardElevation:
                                                      0,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          BuildRowAboveCard(
                                            isEmptySeeMore:
                                            primaryPosts
                                                .isNotEmpty,
                                            title: locale.primary,
                                            numberOfBooks:
                                            primaryPosts.length,
                                            onTap: () =>
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          CategoryBooksScreen(
                                                            categoryIndex:
                                                            1,
                                                            category: locale
                                                                .primary,
                                                          ),
                                                    )),
                                          ),
                                          if (primaryPosts.isEmpty)
                                            const BuildNoBookText(),
                                          if (primaryPosts
                                              .isNotEmpty)
                                            SizedBox(
                                              height: 283.h,
                                              child: state
                                              is GetHomeDataInternetFailureHomeState &&
                                                  primaryPosts
                                                      .isEmpty
                                                  ? BuildTextPlaceHolder(
                                                  text: state
                                                      .message)
                                                  : Padding(
                                                padding: CacheHelper.getData(key: AppConstant.languageKey) ==
                                                    'ar'
                                                    ? EdgeInsets.only(
                                                    right: 10
                                                        .w)
                                                    : EdgeInsets.only(
                                                    left:
                                                    10.w),
                                                child: ListView
                                                    .separated(
                                                  separatorBuilder: (context, index) => SizedBox(width: 15.w,),
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  itemCount:
                                                  primaryPosts
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index) {
                                                    bool
                                                    isFav =
                                                    false;
                                                    if (favCubit
                                                        .favPostsModel !=
                                                        null) {
                                                      for (var element in favCubit
                                                          .favPostsModel!
                                                          .result!) {
                                                        if (primaryPosts[index].id ==
                                                            element.id) {
                                                          isFav =
                                                          true;
                                                          break;
                                                        }
                                                      }
                                                    }

                                                    return BuildPosts(
                                                      postStatus:
                                                      primaryPosts[index].postStatus!,
                                                      isFavourite:
                                                      isFav,
                                                      onTap: () =>
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  CategoryDetailsScreen(
                                                                    emailOrPhone: primaryPosts[index].createdBy.phoneNumber??
                                                                        primaryPosts[index].createdBy.email,
                                                                    isVerified: primaryPosts[index].createdBy.isVerified,
                                                                    id: primaryPosts[index].id,
                                                                    title: primaryPosts[index].title,
                                                                    description: primaryPosts[index].description,
                                                                    images: primaryPosts[index].images,
                                                                    price: primaryPosts[index].price,
                                                                    grade: primaryPosts[index].grade,
                                                                    bookEdition: primaryPosts[index].bookEdition,
                                                                    educationLevel: primaryPosts[index].educationLevel,
                                                                    views: primaryPosts[index].views,
                                                                    numberOfBooks: primaryPosts[index].numberOfBooks,
                                                                    semester: primaryPosts[index].semester,
                                                                    educationType: primaryPosts[index].educationType,
                                                                    location: primaryPosts[index].location,
                                                                    city: primaryPosts[index].city ?? '',
                                                                    createdAt: getTimeDifference(primaryPosts[index].createdAt, locale),
                                                                    postId: primaryPosts[index].postId,
                                                                    recieverId: primaryPosts[index].createdBy.id,
                                                                    gender: primaryPosts[index].createdBy.gender,
                                                                    fullName: primaryPosts[index].createdBy.fullName,
                                                                  ),
                                                            ),
                                                          ),
                                                      imageHeight:
                                                      140.h,
                                                      imageWidth:
                                                      150.w,
                                                      width:
                                                      150.w,
                                                      height:
                                                      283.h,
                                                      borderRadius:
                                                      BorderRadius.zero,
                                                      id: primaryPosts[index]
                                                          .id,
                                                      title: primaryPosts[index]
                                                          .title,
                                                      description:
                                                      primaryPosts[index].description,
                                                      price: primaryPosts[index]
                                                          .price,
                                                      image: primaryPosts[index]
                                                          .images,
                                                      educationLevel:
                                                      primaryPosts[index].educationLevel,
                                                      cityLocation:
                                                      primaryPosts[index].city ??
                                                          '',
                                                      numberOfWatcher:
                                                      primaryPosts[index].views,
                                                      numberOfBooks:
                                                      primaryPosts[index].numberOfBooks,
                                                      timeSince:
                                                      primaryPosts[index].createdAt,
                                                      cardElevation:
                                                      0,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          BuildRowAboveCard(
                                            isEmptySeeMore:
                                            preparatoryPosts
                                                .isNotEmpty,
                                            title:
                                            locale.preparatory,
                                            numberOfBooks:
                                            preparatoryPosts
                                                .length,
                                            onTap: () =>
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          CategoryBooksScreen(
                                                            categoryIndex:
                                                            2,
                                                            category: locale
                                                                .preparatory,
                                                          ),
                                                    )),
                                          ),
                                          if (preparatoryPosts
                                              .isEmpty)
                                            const BuildNoBookText(),
                                          if (preparatoryPosts
                                              .isNotEmpty)
                                            SizedBox(
                                              height: 283.h,
                                              child: state
                                              is GetHomeDataInternetFailureHomeState &&
                                                  preparatoryPosts
                                                      .isEmpty
                                                  ? BuildTextPlaceHolder(
                                                  text: state
                                                      .message)
                                                  : Padding(
                                                padding: CacheHelper.getData(key: AppConstant.languageKey) ==
                                                    'ar'
                                                    ? EdgeInsets.only(
                                                    right: 10
                                                        .w)
                                                    : EdgeInsets.only(
                                                    left:
                                                    10.w),
                                                child: ListView
                                                    .separated(
                                                  separatorBuilder: (context, index) => SizedBox(width: 15.w,),
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  itemCount:
                                                  preparatoryPosts
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index) {
                                                    bool
                                                    isFav =
                                                    false;
                                                    if (favCubit
                                                        .favPostsModel !=
                                                        null) {
                                                      for (var element in favCubit
                                                          .favPostsModel!
                                                          .result!) {
                                                        if (preparatoryPosts[index].id ==
                                                            element.id) {
                                                          isFav =
                                                          true;
                                                          break;
                                                        }
                                                      }
                                                    }
                                                    return BuildPosts(
                                                      postStatus:
                                                      preparatoryPosts[index].postStatus!,
                                                      isFavourite:
                                                      isFav,
                                                      onTap: () =>
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  CategoryDetailsScreen(
                                                                    emailOrPhone: preparatoryPosts[index].createdBy.phoneNumber??
                                                                        preparatoryPosts[index].createdBy.email,
                                                                    isVerified: preparatoryPosts[index].createdBy.isVerified,
                                                                    id: preparatoryPosts[index].id,
                                                                    title: preparatoryPosts[index].title,
                                                                    description: preparatoryPosts[index].description,
                                                                    images: preparatoryPosts[index].images,
                                                                    price: preparatoryPosts[index].price,
                                                                    grade: preparatoryPosts[index].grade,
                                                                    bookEdition: preparatoryPosts[index].bookEdition,
                                                                    educationLevel: preparatoryPosts[index].educationLevel,
                                                                    views: preparatoryPosts[index].views,
                                                                    numberOfBooks: preparatoryPosts[index].numberOfBooks,
                                                                    semester: preparatoryPosts[index].semester,
                                                                    educationType: preparatoryPosts[index].educationType,
                                                                    location: preparatoryPosts[index].location,
                                                                    city: preparatoryPosts[index].city ?? '',
                                                                    createdAt: getTimeDifference(preparatoryPosts[index].createdAt, locale),
                                                                    postId: preparatoryPosts[index].postId,
                                                                    recieverId: preparatoryPosts[index].createdBy.id,
                                                                    gender: preparatoryPosts[index].createdBy.gender,
                                                                    fullName: preparatoryPosts[index].createdBy.fullName,
                                                                  ),
                                                            ),
                                                          ),
                                                      imageHeight:
                                                      140.h,
                                                      imageWidth:
                                                      150.w,
                                                      width:
                                                      150.w,
                                                      height:
                                                      283.h,
                                                      borderRadius:
                                                      BorderRadius.zero,
                                                      id: preparatoryPosts[index]
                                                          .id,
                                                      title: preparatoryPosts[index]
                                                          .title,
                                                      description:
                                                      preparatoryPosts[index].description,
                                                      price: preparatoryPosts[index]
                                                          .price,
                                                      image: preparatoryPosts[index]
                                                          .images,
                                                      educationLevel:
                                                      preparatoryPosts[index].educationLevel,
                                                      cityLocation:
                                                      preparatoryPosts[index].city ??
                                                          '',
                                                      numberOfWatcher:
                                                      preparatoryPosts[index].views,
                                                      numberOfBooks:
                                                      preparatoryPosts[index].numberOfBooks,
                                                      timeSince:
                                                      preparatoryPosts[index].createdAt,
                                                      cardElevation:
                                                      0,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          BuildRowAboveCard(
                                            isEmptySeeMore:
                                            secondaryPosts
                                                .isNotEmpty,
                                            title: locale.secondary,
                                            numberOfBooks:
                                            secondaryPosts
                                                .length,
                                            onTap: () =>
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          CategoryBooksScreen(
                                                            categoryIndex:
                                                            3,
                                                            category: locale
                                                                .secondary,
                                                          ),
                                                    )),
                                          ),
                                          if (secondaryPosts
                                              .isEmpty)
                                            const BuildNoBookText(),
                                          if (secondaryPosts
                                              .isNotEmpty)
                                            SizedBox(
                                              // margin: const EdgeInsets.only(right: 16),
                                              height: 283.h,
                                              child: state
                                              is GetHomeDataInternetFailureHomeState &&
                                                  secondaryPosts
                                                      .isEmpty
                                                  ? BuildTextPlaceHolder(
                                                  text: state
                                                      .message)
                                                  : Padding(
                                                padding: CacheHelper.getData(key: AppConstant.languageKey) ==
                                                    'ar'
                                                    ? EdgeInsets.only(
                                                    right: 10
                                                        .w)
                                                    : EdgeInsets.only(
                                                    left:
                                                    10.w),
                                                child: ListView
                                                    .separated(
                                                  separatorBuilder: (context, index) => SizedBox(width: 15.w,),
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  itemCount:
                                                  secondaryPosts
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index) {
                                                    bool
                                                    isFav =
                                                    false;
                                                    if (favCubit
                                                        .favPostsModel !=
                                                        null) {
                                                      for (var element in favCubit
                                                          .favPostsModel!
                                                          .result!) {
                                                        if (secondaryPosts[index].id ==
                                                            element.id) {
                                                          isFav =
                                                          true;
                                                          break;
                                                        }
                                                      }
                                                    }

                                                    final languageCode =
                                                    CacheHelper.getData(
                                                        key: AppConstant.languageKey);
                                                    return BuildPosts(
                                                      postStatus:
                                                      secondaryPosts[index].postStatus!,
                                                      isFavourite:
                                                      isFav,
                                                      onTap: () =>
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (ctx) => CategoryDetailsScreen(
                                                                  emailOrPhone: secondaryPosts[index].createdBy.phoneNumber??
                                                                      secondaryPosts[index].createdBy.email,
                                                                  isVerified: secondaryPosts[index].createdBy.isVerified,
                                                                  id: secondaryPosts[index].id,
                                                                  title: secondaryPosts[index].title,
                                                                  description: secondaryPosts[index].description,
                                                                  images: secondaryPosts[index].images,
                                                                  price: secondaryPosts[index].price,
                                                                  grade: secondaryPosts[index].grade,
                                                                  bookEdition: secondaryPosts[index].bookEdition,
                                                                  educationLevel: secondaryPosts[index].educationLevel,
                                                                  views: secondaryPosts[index].views,
                                                                  numberOfBooks: secondaryPosts[index].numberOfBooks,
                                                                  semester: secondaryPosts[index].semester,
                                                                  educationType: secondaryPosts[index].educationType,
                                                                  location: secondaryPosts[index].location,
                                                                  createdAt: getTimeDifference(secondaryPosts[index].createdAt, locale),
                                                                  postId: secondaryPosts[index].postId,
                                                                  city: secondaryPosts[index].city ?? '',
                                                                  recieverId: secondaryPosts[index].createdBy.id,
                                                                  gender: secondaryPosts[index].createdBy.gender,
                                                                  fullName: secondaryPosts[index].createdBy.fullName,
                                                                )),
                                                          ),
                                                      imageHeight:
                                                      140.h,
                                                      imageWidth:
                                                      150.w,
                                                      width:
                                                      150.w,
                                                      height:
                                                      283.h,
                                                      borderRadius:
                                                      BorderRadius.zero,
                                                      id: secondaryPosts[index]
                                                          .id,
                                                      title: secondaryPosts[index]
                                                          .title,
                                                      description:
                                                      secondaryPosts[index].description,
                                                      price: secondaryPosts[index]
                                                          .price,
                                                      image: secondaryPosts[index]
                                                          .images,
                                                      educationLevel:
                                                      secondaryPosts[index].educationLevel,
                                                      cityLocation:
                                                      secondaryPosts[index].city ??
                                                          '',
                                                      numberOfWatcher:
                                                      secondaryPosts[index].views,
                                                      numberOfBooks:
                                                      secondaryPosts[index].numberOfBooks,
                                                      timeSince:
                                                      secondaryPosts[index].createdAt,
                                                      cardElevation:
                                                      0,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          BuildRowAboveCard(
                                            isEmptySeeMore:
                                            generalPosts
                                                .isNotEmpty,
                                            title: locale.general,
                                            numberOfBooks:
                                            generalPosts.length,
                                            onTap: () =>
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          CategoryBooksScreen(
                                                            categoryIndex:
                                                            4,
                                                            category: locale
                                                                .general,
                                                          ),
                                                    )),
                                          ),
                                          if (generalPosts.isEmpty)
                                            const BuildNoBookText(),
                                          if (generalPosts
                                              .isNotEmpty)
                                            SizedBox(
                                              height: 283.h,
                                              child: state
                                              is GetHomeDataInternetFailureHomeState &&
                                                  generalPosts
                                                      .isEmpty
                                                  ? BuildTextPlaceHolder(
                                                  text: state
                                                      .message)
                                                  : Padding(
                                                padding: CacheHelper.getData(key: AppConstant.languageKey) ==
                                                    'ar'
                                                    ? EdgeInsets.only(
                                                    right: 10
                                                        .w)
                                                    : EdgeInsets.only(
                                                    left:
                                                    10.w),
                                                child: ListView
                                                    .separated(
                                                  separatorBuilder: (context, index) => SizedBox(width: 15.w,),
                                                  physics:
                                                  const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                  Axis.horizontal,
                                                  itemCount:
                                                  generalPosts
                                                      .length,
                                                  itemBuilder:
                                                      (context,
                                                      index) {
                                                    bool
                                                    isFav =
                                                    false;
                                                    if (favCubit
                                                        .favPostsModel !=
                                                        null) {
                                                      for (var element in favCubit
                                                          .favPostsModel!
                                                          .result!) {
                                                        if (generalPosts[index].id ==
                                                            element.id) {
                                                          isFav =
                                                          true;
                                                          break;
                                                        }
                                                      }
                                                    }

                                                    return BuildPosts(
                                                      postStatus:
                                                      generalPosts[index].postStatus!,
                                                      isFavourite:
                                                      isFav,
                                                      onTap: () =>
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (ctx) => CategoryDetailsScreen(
                                                                  emailOrPhone: generalPosts[index].createdBy.phoneNumber??
                                                                      generalPosts[index].createdBy.email,
                                                                  isVerified: generalPosts[index].createdBy.isVerified,
                                                                  id: generalPosts[index].id,
                                                                  title: generalPosts[index].title,
                                                                  description: generalPosts[index].description,
                                                                  images: generalPosts[index].images,
                                                                  price: generalPosts[index].price,
                                                                  grade: generalPosts[index].grade,
                                                                  bookEdition: generalPosts[index].bookEdition,
                                                                  educationLevel: generalPosts[index].educationLevel,
                                                                  views: generalPosts[index].views,
                                                                  numberOfBooks: generalPosts[index].numberOfBooks,
                                                                  semester: generalPosts[index].semester,
                                                                  educationType: generalPosts[index].educationType,
                                                                  location: generalPosts[index].location,
                                                                  createdAt: getTimeDifference(generalPosts[index].createdAt, locale),
                                                                  postId: generalPosts[index].postId,
                                                                  city: generalPosts[index].city ?? '',
                                                                  recieverId: generalPosts[index].createdBy.id,
                                                                  gender: generalPosts[index].createdBy.gender,
                                                                  fullName: generalPosts[index].createdBy.fullName,
                                                                )),
                                                          ),
                                                      imageHeight:
                                                      140.h,
                                                      imageWidth:
                                                      150.w,
                                                      width:
                                                      150.w,
                                                      height:
                                                      283.h,
                                                      borderRadius:
                                                      BorderRadius.zero,
                                                      id: generalPosts[index]
                                                          .id,
                                                      title: generalPosts[index]
                                                          .title,
                                                      description:
                                                      generalPosts[index].description,
                                                      price: generalPosts[index]
                                                          .price,
                                                      image: generalPosts[index]
                                                          .images,
                                                      educationLevel:
                                                      generalPosts[index].educationLevel,
                                                      cityLocation:
                                                      generalPosts[index].city ??
                                                          '',
                                                      numberOfWatcher:
                                                      generalPosts[index].views,
                                                      numberOfBooks:
                                                      generalPosts[index].numberOfBooks,
                                                      timeSince:
                                                      generalPosts[index].createdAt,
                                                      cardElevation:
                                                      0,
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          headerSliverBuilder: (context, innerBoxIsScrolled) {
                            return  <Widget>[
                              SliverPadding(
                                padding:EdgeInsets.only(top: 15.h) ,
                                sliver: SliverAppBar(
                                  toolbarHeight: 30.h,
                                  leading: Container(),
                                  backgroundColor: Theme.of(context).cardColor,
                                  flexibleSpace: FlexibleSpaceBar(
                                    background: Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 12.w),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 32.h,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context).dividerColor,
                                                // Color of the border
                                                width: 2.0, // Width of the border
                                              ),
                                              borderRadius: BorderRadius.circular(
                                                  8.0), // Adjust the border radius as needed
                                            ),
                                            child: DropdownButton<String>(
                                              value: CacheHelper.getData(
                                                  key: AppConstant.city) ??
                                                  'egypt',
                                              onChanged: (String? value) {
                                                homeCubit.changeCity(value!);
                                                homeCubit.getHomePosts(
                                                    noInternet: locale.no_internet,
                                                    weakInternet:
                                                    locale.weak_internet);
                                              },
                                              style: font.titleMedium!
                                                  .copyWith(fontSize: 14.sp),
                                              icon:  Icon(
                                                Icons.arrow_drop_down,
                                                color: Theme.of(context).iconTheme.color,
                                              ),
                                              dropdownColor: Theme. of(context).cardColor,
                                              underline: Container(),
                                              items: regionsDropDownItems.entries
                                                  .map<DropdownMenuItem<String>>(
                                                      (entry) {
                                                    return DropdownMenuItem<String>(
                                                      value: entry.value,
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            horizontal: 8.w),
                                                        // Adjust the horizontal padding
                                                        child: Text(
                                                          entry.key,
                                                          style: font.titleMedium!
                                                              .copyWith(
                                                              fontSize: 14.sp),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                          ),
                                          const Spacer(),
                                          Image.asset(
                                           ImageConstant.logoImage,
                                            height: 40.w,
                                            width: 95.w,
                                            fit: BoxFit.cover,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SliverAppBar(
                                pinned: true,
                                expandedHeight: 55.w,
                                leading: Container(),
                                toolbarHeight: 50.w,
                                backgroundColor: Theme.of(context).cardColor,
                                flexibleSpace: Padding(
                                  padding:  EdgeInsets.only(top: 30.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      BuildSearchTextFormField(
                                        hintText: locale.search,
                                        readOnly: true,
                                        onTap: () {
                                          focusNode.requestFocus();
                                          pushWithAnimationLeftAndBottom(
                                              context: context,
                                              widget: SearchScreen(
                                                focusNode: focusNode,
                                                searchController:
                                                searchController,
                                              ));
                                        },
                                        searchController: searchController,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      BlocBuilder<NotificationCubit,
                                          NotificationState>(
                                        builder: (context, state) {
                                          var cubit =
                                          context.read<NotificationCubit>();
                                          return Stack(
                                            alignment: CacheHelper.getData(
                                                key: AppConstant
                                                    .languageKey) ==
                                                'ar'
                                                ? Alignment.topLeft
                                                : Alignment.topRight,
                                            children: [
                                              if (cubit.notificationModel !=
                                                  null &&
                                                  cubit.length != 0)
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 20.w,
                                                  height: 20.w,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    ColorConstant.dangerColor,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20.r),
                                                  ),
                                                  child: Text(
                                                    '${cubit.length>99?'99+':
                                                    cubit.length}',
                                                    style:
                                                    font.bodyLarge!.copyWith(
                                                      color: Colors.white,
                                                      fontSize: 10.sp,
                                                    ),
                                                  ),
                                                ),
                                              IconButton(
                                                alignment: Alignment.center,
                                                onPressed: () {
                                                  int count = 0;
                                                  if (cubit.notificationModel !=
                                                      null) {
                                                    for (var element in cubit
                                                        .notificationModel!
                                                        .result!) {
                                                      if (!element.isRead!) {
                                                        count++;
                                                      }
                                                    }
                                                  }
                                                  if (CacheHelper.getData(
                                                      key: AppConstant
                                                          .token) !=
                                                      null) {
                                                    cubit.readNotifications();
                                                    pushWithAnimationLeftAndBottom(
                                                        context: context,
                                                        left: false,
                                                        widget:
                                                        NotificationScreen(
                                                          numberOfNotitficationUnread:
                                                          count,
                                                        ));
                                                  } else {
                                                    Navigator.pushNamed(
                                                        context, 'getStart');
                                                  }
                                                },
                                                color: ColorConstant.dangerColor,
                                                icon: Icon(
                                                  SolarIconsOutline.bell,
                                                  size: 26.w,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ];
                          },

                        );
                      },
                    );
            },
          ),
        );
      },
      listener: (context, state) {
        if (state is SendNewPostSuccess) {
          snackBarMessage(
              inHome: true,
              displayBottom: false,
              context: context,
              message: locale.add_new_message,
              snackbarState: SnackbarState.inValid,
              duration: const Duration(seconds: 3));
        }
      },
    );
  }
}
