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

class BuildRectangleCardPost extends StatelessWidget {
  final String title;
  final String description;
  final dynamic price;
  final String image;
  final String educationLevel;
  final String cityLocation;
  final DateTime timeSince;
  final int numberOfWatcher;
  final int numberOfBooks;
  final String id;
  final bool isFavourite;
  final void Function() onTap;
  const BuildRectangleCardPost({
    super.key,
    required this.title,
    required this.isFavourite,
    required this.description,
    required this.price,
    required this.image,
    required this.educationLevel,
    required this.cityLocation,
    required this.numberOfWatcher,
    required this.numberOfBooks,
    required this.onTap,
    required this.timeSince,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final String time = getTimeDifference(timeSince, locale);


    bool? isFavorite;
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
    final city = reversedRegions[cityLocation];
    return BlocConsumer<FavoritesCubit, FavoritesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final favCubit = FavoritesCubit.get(context);
        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color:Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFC8C5C5)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              width: double.infinity,
              height: 178.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        clipBehavior: Clip.hardEdge,
                        borderRadius: BorderRadius.circular(
                          14.sp,
                        ),
                        child: Image.network(
                          width: MediaQuery.of(context).size.width / 2.6,
                          height: 158.h,
                          fit: BoxFit.cover,
                          AppConstant.imageUrl+image,
                        ),
                      ),
                      Positioned(
                        right: 1,
                        bottom: 1,
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
                            if (HelperFunctions
                                .hasUserRegistered()) {
                              if (isFavourite) {
                                favCubit.removeFromFavorites(id);
                              }else{
                                favCubit.addToFavorites(id);
                              }
                            } else {
                              Navigator.pushNamed(
                                  context, 'getStart');
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                          textDirection: HelperFunctions.isArabic(title)
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2.4,
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                            description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                            textDirection: HelperFunctions.isArabic(description)
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ),
                      ),
                      Text(
                        reversEducationLevels[educationLevel]!,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                        textDirection: HelperFunctions.isArabic(
                                reversEducationLevels[educationLevel]!)
                            ? TextDirection.rtl
                            : TextDirection.ltr,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Row(
                          children: [
                            Icon(
                              SolarIconsOutline.book,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 60,
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
                              width: MediaQuery.sizeOf(context).width / 55,
                            ),
                            Icon(
                              SolarIconsOutline.eye,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 55,
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
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Row(
                          children: [
                            Icon(
                              SolarIconsOutline.mapPoint,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 90,
                            ),
                            Text(
                              city!,
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
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 55,
                            ),
                            const Spacer(),
                            Icon(
                              SolarIconsOutline.clockCircle,
                              size: 10.h,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width / 120,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 6,
                              child: Text(
                                locale.time_since(time),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
