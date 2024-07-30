import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/shared/component/handle_time.dart';
import 'package:kotobekia/shared/component/price_container.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:solar_icons/solar_icons.dart';

// card that contain about post books

class BuildPosts extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final dynamic price;
  final List<String> image;
  final String educationLevel;
  final String cityLocation;
  final DateTime timeSince;
  final int numberOfWatcher;
  final int numberOfBooks;
  final double? height;
  final double? width;
  final double imageWidth;
  final double imageHeight;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final double cardElevation;
  final BoxBorder? cardBorder;
  final void Function() onTap;
  final bool isFavourite;
  final String postStatus;

  const BuildPosts({
    super.key,
    required this.title,
    required this.isFavourite,
    required this.postStatus,
    required this.description,
    required this.price,
    required this.image,
    required this.educationLevel,
    required this.cityLocation,
    // required this.lastTime,
    required this.numberOfWatcher,
    required this.numberOfBooks,
    this.height,
    this.width,
    required this.imageWidth,
    required this.imageHeight,
    required this.borderRadius,
    required this.cardElevation,
    this.contentPadding,
    required this.onTap,
    this.cardBorder,
    required this.timeSince,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    final String time = getTimeDifference(timeSince, locale);
    //  to show returned education level based on the user's locale
    final reversEducationLevels = {
      '655b4ec133dd362ae53081f7': locale.kindergarten,
      '655b4ecd33dd362ae53081f9': locale.primary,
      '655b4ee433dd362ae53081fb': locale.preparatory,
      '655b4efb33dd362ae53081fd': locale.secondary,
      '655b4f0a33dd362ae53081ff': locale.general,
    };

    //  to show returned city based on the user's locale
    final reversedRegions = {
      'cairo': locale.cairo,
      'giza': locale.giza,
      'alexandria': locale.alexandria,
      'dakahlia': locale.dakahlia,
      'sharqia': locale.sharqia,
      'monufia': locale.monufia,
      'qalyubia': locale.qalyubia,
      'beheira': locale.beheira,
      'port_said': locale.port_said,
      'damietta': locale.damietta,
      'ismailia': locale.ismailia,
      'suez': locale.suez,
      'kafr_el_sheikh': locale.kafr_el_sheikh,
      'fayoum': locale.fayoum,
      'beni_suef': locale.beni_suef,
      'matruh': locale.matruh,
      'north_sinai': locale.north_sinai,
      'south_sinai': locale.south_sinai,
      'minya': locale.minya,
      'asyut': locale.asyut,
      'sohag': locale.sohag,
      'qena': locale.qena,
      'red_sea': locale.red_sea,
      'luxor': locale.luxor,
      'aswan': locale.aswan,
    };


    final city = reversedRegions[cityLocation] ?? ' ';
    final favCubit = FavoritesCubit.get(context);
    return BlocBuilder<FavoritesCubit, FavoritesStates>(
      builder: (context, state) {
        return FittedBox(
          fit: BoxFit.contain,
          child: Card(
            color: cardBorder != null
                ? Theme.of(context).cardColor
                : Theme.of(context).scaffoldBackgroundColor,
            elevation: cardElevation,
            shape: RoundedRectangleBorder(
                borderRadius: borderRadius),
            child: GestureDetector(
              onTap: onTap,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: cardBorder != null
                          ? Theme.of(context).cardColor
                          : Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: borderRadius,
                      border:cardBorder,
                    ),
                    padding: contentPadding,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                14.sp,
                              ),
                              child: Hero(
                                tag: 'post$id',
                                child: Image.network(
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: imageWidth,
                                      height: imageHeight,
                                      decoration: BoxDecoration
                                        (
                                        color: Colors.grey.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(
                                          14.sp,
                                        )
                                      ),

                                    );
                                  },   width: imageWidth,
                                  height: imageHeight,

                                  fit: BoxFit.cover,
                                  '${AppConstant.imageUrl}${image[0]}',
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                icon: Icon(
                                  isFavourite
                                      ? SolarIconsBold.heart
                                      : SolarIconsOutline.heart,
                                  color: isFavourite
                                      ? ColorConstant.dangerColor
                                      : const Color(0xFFD7D7D8),
                                  size: 26.w,
                                ),
                                onPressed: () {
                                  if (HelperFunctions.hasUserRegistered()) {
                                    if (isFavourite) {
                                      favCubit.removeFromFavorites(id);
                                    } else {
                                      favCubit.addToFavorites(id);
                                    }
                                  } else {
                                    Navigator.pushNamed(context, 'getStart');
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: HelperFunctions.isArabic(title)
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                            textDirection: HelperFunctions.isArabic(title)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          description,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                              ),
                          textDirection: HelperFunctions.isArabic(description)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              SolarIconsOutline.book,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              '$numberOfBooks',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Icon(
                              SolarIconsOutline.eye,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              '$numberOfWatcher',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            const Spacer(),
                            BuildPriceContainer(price: price, locale: locale),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: Text(
                            reversEducationLevels[educationLevel]!,
                            style:
                                Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                            textDirection:
                                HelperFunctions.isArabic(educationLevel)
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              SolarIconsOutline.mapPoint,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              city,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textDirection: HelperFunctions.isArabic(city)
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            const Spacer(),
                            Icon(
                              SolarIconsOutline.clockCircle,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            SizedBox(
                              width: city.length >= 8? 60.w : null,
                              child: FittedBox(
                                child: Text(
                                  locale.time_since(time),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  postStatus == "approved"
                      ? Container()
                      : Positioned(
                          top: 0,
                          left: 0,
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft:  Radius.circular(15.r),
                                    bottomRight: Radius.circular(15.r)),
                                color: postStatus == "pending"
                                    ? Colors.orange
                                    : postStatus == "rejected"
                                        ? Colors.red
                                        : Colors.blue),
                            width: 65.w,
                            height: 25.h,
                            child: Text(
                              postStatus,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.white, fontSize: 12.sp),
                            ),
                          ),
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

// custimize the radius and the elevation
// add the logic to home screen
