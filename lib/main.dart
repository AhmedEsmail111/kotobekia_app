import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/add_post/add_post_cubit.dart';
import 'package:kotobekia/controller/authentication/authentication_cubit.dart';
import 'package:kotobekia/controller/category/category_cubit.dart';
import 'package:kotobekia/controller/category_details/category_details_cubit.dart';
import 'package:kotobekia/controller/chat/chat_cubit.dart';
import 'package:kotobekia/controller/favorites/favorites_cubit.dart';
import 'package:kotobekia/controller/home/home_cubit.dart';
import 'package:kotobekia/controller/internet/internet-states.dart';
import 'package:kotobekia/controller/internet/internet_cubit.dart';
import 'package:kotobekia/controller/language/language_cubit.dart';
import 'package:kotobekia/controller/language/language_states.dart';
import 'package:kotobekia/controller/notification/notification_cubit.dart';
import 'package:kotobekia/controller/otp/otp_cubit.dart';
import 'package:kotobekia/controller/profile/profile_cubit.dart';
import 'package:kotobekia/controller/profile/profile_states.dart';
import 'package:kotobekia/controller/user_ads/user_ads_cubit.dart';
import 'package:kotobekia/l10n/l10n.dart';
import 'package:kotobekia/layout/home_layout.dart';
import 'package:kotobekia/modules/add_post/add_post_screen.dart';
import 'package:kotobekia/modules/change_passwrod/chnage_password_screen.dart';
import 'package:kotobekia/modules/create_account/create_account_screen.dart';
import 'package:kotobekia/modules/favorite_adds/favorite_adds_.dart';
import 'package:kotobekia/modules/forget_password/forget_password_screen.dart';
import 'package:kotobekia/modules/get_start/get_start_screen.dart';
import 'package:kotobekia/modules/help/help_screen.dart';
import 'package:kotobekia/modules/home/home_screen.dart';
import 'package:kotobekia/modules/login/Login_screen.dart';
import 'package:kotobekia/modules/modify_profile/modify_profile.dart';
import 'package:kotobekia/modules/otp/otp_screen.dart';
import 'package:kotobekia/modules/verified_email/verified_email_screen.dart';
import 'package:kotobekia/shared/component/snakbar_message.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/constants/images/images_constant.dart';
import 'package:kotobekia/shared/helper/notifications.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';
import 'package:kotobekia/shared/styles/colors.dart';
import 'package:kotobekia/shared/styles/styles.dart';
import 'package:page_transition/page_transition.dart';
import 'modules/chat_screen/chat_screen.dart';
import 'modules/choose_anguage/languages_screen.dart';
import 'shared/component/show_toast.dart';
import 'shared/helper/bloc_observer.dart';
import 'shared/network/remote/socket.io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {
  String title = message.notification!.title ?? 'Default Title';
  String value = message.notification!.body ?? 'Default Value';
  LocalNotificationService().showNotificationAndroid(title, value);
  // ShowToast(message: 'on BackgroundMessage', state: ToastState.SUCCESS);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  await DioHelper.init();
  SocketIO.connect();
  await LocalNotificationService().init();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String title = message.notification!.title ?? 'Default Title';
    String value = message.notification!.body ?? 'Default Value';
    LocalNotificationService().showNotificationAndroid(title, value);
    //ShowToast(message: 'on Message', state: ToastState.SUCCESS);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    String title = message.notification!.title ?? 'Default Title';
    String value = message.notification!.body ?? 'Default Value';
    LocalNotificationService().showNotificationAndroid(title, value);
    // ShowToast(message: 'on Message', state: ToastState.SUCCESS);
  });
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  var token = await FirebaseMessaging.instance.getToken();

  if(token!=null&&
      CacheHelper.getData(key: AppConstant.tokenDevice)==null){
    CacheHelper.saveData(key: AppConstant.tokenDevice,
        value: true);
  }


  print(CacheHelper.getData(key: AppConstant.token));
await ScreenUtil.ensureScreenSize();
  Bloc.observer = MyBlocObserver();
  //CacheHelper.deleteAllData();
  Widget widget;
  // if(CacheHelper.getData(key: AppConstant.mode)==null){
  //   if( ThemeMode.system == ThemeMode.dark){
  //     CacheHelper.saveData(key: AppConstant.mode,
  //         value: true);
  //   }else{
  //     CacheHelper.saveData(key: AppConstant.mode,
  //         value: false);
  //   }
  // }

  if (CacheHelper.getData(key: AppConstant.otpScreen) != null) {
    widget = const OtpScreen();
  } else {
    if (CacheHelper.getData(key: AppConstant.languageKey) == null) {
      widget = const LanguageScreen();
    } else {
      widget = const LayoutScreen();
    }
  }
  runApp(
    MyApp(widget: widget),
  );
}

class MyApp extends StatelessWidget {
  final Widget widget;

  const MyApp({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            if (CacheHelper.getData(key: AppConstant.token) != null) {
              return FavoritesCubit()..getFavPosts();
            } else {
              return FavoritesCubit();
            }
          },
        ),
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(create: (context) {
          if (CacheHelper.getData(key: AppConstant.token) != null) {
            return ChatCubit()
              ..recieveMessage()
              ..getUsersConversation(
                  token: CacheHelper.getData(key: AppConstant.token))
              ..joinSocket(CacheHelper.getData(key: AppConstant.userId))
              ..getOnlineUser();
          } else {
            return ChatCubit();
          }
        }),
        BlocProvider(
          create: (context) => UserAddsCubit(),
        ),
        BlocProvider(
          create: (context) => OtpCubit(),
        ),
        BlocProvider(create: (ctx) => HomeCubit()),
        BlocProvider(
          create: (ctx) => CategoryCubit(),
        ),
        BlocProvider(
          create: (ctx) => AddPostCubit(),
        ),
        BlocProvider(create: (ctx) => ProfileCubit()),
        BlocProvider(
          create: (ctx) {
            if (CacheHelper.getData(key: AppConstant.token) != null) {
              return FavoritesCubit()..getFavPosts();
            } else {
              return FavoritesCubit();
            }
          },
        ),
        BlocProvider(
          create: (ctx) => CategoryDetailsCubit(),
        ),
        BlocProvider(
          create: (ctx) => LanguageCubit(),
        ),
        BlocProvider(create: (ctx) {
          if (CacheHelper.getData(key: AppConstant.token) != null) {
            return NotificationCubit()
              ..changeStateNotify()
              ..getNotifications();
          } else {
            return NotificationCubit();
          }
        }),
        BlocProvider(
          create: (ctx) => InternetCubit()..checkConnectivity(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return BlocBuilder<ProfileCubit, ProfileStates>(
            builder: (context, state) {
              return BlocConsumer<LanguageCubit, LanguageStates>(
                listener: (ctx, state) {},
                builder: (ctx, state) {
                  final profileCubit = LanguageCubit.get(_);
                  return MaterialApp(
                      routes: {
                        'homeLayout': (context) => const LayoutScreen(),
                        'home': (context) => const HomeScreen(),
                        'getStart': (context) => const GetStartScreen(),
                        'createAccount': (context) =>
                            const CreateAccountScreen(),
                        'login': (context) => const LoginScreen(),
                        'verifiedEmail': (context) =>
                            const VerifiedEmailScreen(),
                        'chat': (context) => const ChatScreen(),
                        'addPost': (context) => const AddPostScreen(),
                        'changePassword': (context) =>
                            const ChangePasswordScreen(),
                        'forgetPassword': (context) =>
                            const ForgetPasswordScreen(),
                        'modifyProfile': (context) =>
                            const ModifyProfileScreen(),
                        'help': (context) =>
                            const HelpScreen(),
                        'favoriteAdds': (context) => const FavoriteAddsScreen(),
                      },
                      locale: profileCubit.locale,
                      localizationsDelegates: const [
                        AppLocalizations.delegate,
                        GlobalMaterialLocalizations.delegate,
                        GlobalCupertinoLocalizations.delegate,
                        GlobalWidgetsLocalizations.delegate,
                      ],
                      supportedLocales: L10n.all,
                      debugShowCheckedModeBanner: false,
                      themeMode: ThemeMode.light,
                      theme: lightTheme(width: width, height: height),
                      home: BlocListener<InternetCubit, InternetStates>(
                        listener: (ctx, state) {
                          final locale = AppLocalizations.of(ctx);
                          if (state is InternetNotConnected) {
                            snackBarMessage(
                              context: ctx,
                              message: locale.snackbar_no_internet,
                              snackbarState: SnackbarState.error,
                              duration: const Duration(days: 1),
                            );
                          }
                          if (state is InternetConnected && !state.isFirst) {
                            snackBarMessage(
                                context: ctx,
                                message: locale.connection_restored,
                                snackbarState: SnackbarState.success,
                                duration: const Duration(seconds: 2));
                          }
                        },
                        child: AnimatedSplashScreen(
                          nextScreen: CacheHelper.getData(
                                      key: AppConstant.languageKey) ==
                                  null
                              ? const LanguageScreen()
                              : widget,
                          duration: 2500,
                          splashIconSize: width / 0.7,
                          pageTransitionType:
                              PageTransitionType.rightToLeftWithFade,
                          backgroundColor: ColorConstant.backgroundColor,
                          splash: ImageConstant.splashAnimationImage,
                          splashTransition: SplashTransition.fadeTransition,
                        ),
                      ));
                },
              );
            },
          );
        },
      ),
    );
  }
}
