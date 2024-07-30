import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/shared/component/back_icon.dart';
import 'package:kotobekia/shared/constants/icons/icons_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    Future<void> launchSocial(String url) async {
      if (!await launchUrl(Uri.parse(url), mode: LaunchMode.inAppBrowserView)) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading:  BuildBackIcon(onTap: (){
          Navigator.pop(context);
        }),
        title: Text(
          locale.help,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageConstant.logoImage,
                scale: 1,
                fit: BoxFit.cover,
              ),
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          Text(
            locale.connectWithUs,
            style: Theme.of(context).textTheme.titleMedium!,
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  launchSocial('https://www.facebook.com/kotobekia');
                },
                child: Icon(
                  Icons.facebook,
                  color: Colors.blue,
                  size: 25.w,
                ),
              ),
              SizedBox(
                width: 25.w,
              ),
              InkWell(
                onTap: () {
                  launchSocial('https://www.linkedin.com/company/kotobekia');
                },
                child: ClipRRect
                  (
                    borderRadius: BorderRadius.circular(2.r),
                    child: Image.asset(IconConstant.linkedInIcon,height: 20.w,width: 20.w,)),
              ),
              SizedBox(
                width: 25.w,
              ),
              InkWell(
                  onTap: () => launchSocial('https://www.instagram.com/kotobekia'),
                  child: Image.asset(IconConstant.instegramIcon,height: 20.w,width: 20.w)),
            ],
          )
        ],
      ),
    );
  }
}
