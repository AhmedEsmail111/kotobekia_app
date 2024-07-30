import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_states.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/component/loading_indicator.dart';
import 'package:kotobekia/shared/component/posts_grid.dart';
import 'package:solar_icons/solar_icons.dart';

class FavoriteAddsScreen extends StatelessWidget {
  const FavoriteAddsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var font=Theme.of(context).textTheme;
    final locale = AppLocalizations.of(context);
    return BlocBuilder<FavoritesCubit, FavoritesStates>(
      builder: (context, state) {
        final favCubit = FavoritesCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading:  BuildBackIcon(onTap: (){
              Navigator.pop(context);
            }),
            title: Text(
              locale.favorite_adds,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            centerTitle: true,

          ),
            body: favCubit.favPostsModel!=null?
            favCubit.favPostsModel!.result!.isEmpty?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                      Icon(SolarIconsOutline.fileFavourite,size:50.w ,color: Colors.red,),
                      SizedBox(height: 20.h,),
                      Text(locale.noFavourite,style: font.bodyLarge!
                          .copyWith(fontSize: 15.sp),),
                      SizedBox(height: 5.h,),
                      Text(locale.markedFavourite,style: font.headlineMedium!
                          .copyWith(color: Colors.grey,fontSize: 17.sp),),
                    ],),
                  ],
                )
                :
            BuildPostsGrid(
             data: favCubit.favPostsModel!.result!,
                        ): const BuildLoadingIndicator());
      },
    );
  }
}
