// ignore_for_file: deprecated_member_use

import 'package:demandium/data/model/notification_body.dart';
import 'package:demandium/feature/home/widget/cookies_view.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'components/core_export.dart';
import 'core/helper/language_di.dart' as di;
import 'core/helper/notification_helper.dart';
import 'core/initial_binding/initial_binding.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
    await FlutterDownloader.initialize();
  }
  setPathUrlStrategy();
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyByfPcZGmnpwnETBKvDcXFTPRvPDVtthMA",
      appId: "1:57854838415:web:edb5f3f5f43c4f9fd192fa",
      messagingSenderId: "57854838415",
      projectId: "agnomy-001",
      storageBucket: "agnomy-001.appspot.com",
    ));
    // await FacebookAuth.instance.webInitialize(
    //   appId: "637072917840079",
    //   cookie: true,
    //   xfbml: true,
    //   version: "v15.0",
    // );
  } else {
    await Firebase.initializeApp();
    if (defaultTargetPlatform == TargetPlatform.android) {
      await FirebaseMessaging.instance.requestPermission();
    }
  }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  Map<String, Map<String, String>> languages = await di.init();
  NotificationBody? body;
  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {
      body = NotificationHelper.convertNotification(remoteMessage.data);
    }
    await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  } catch (e) {
    if (kDebugMode) {
      print("");
    }
  }
  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBody? body;
  const MyApp({super.key, @required this.languages, @required this.body});
  void _route() async {
    Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
      if (Get.find<LocationController>().getUserAddress() != null) {
        AddressModel addressModel =
            Get.find<LocationController>().getUserAddress()!;
        ZoneResponseModel responseModel = await Get.find<LocationController>()
            .getZone(addressModel.latitude.toString(),
                addressModel.longitude.toString(), false);
        addressModel.availableServiceCountInZone =
            responseModel.totalServiceCount;
        Get.find<LocationController>().saveUserAddress(addressModel);
      }

      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      Get.find<SplashController>().getCookiesData();
      Get.find<CartController>().getCartListFromServer();

      if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<UserController>().getUserInfo();
      }

      if (Get.find<SplashController>().getGuestId().isEmpty) {
        var uuid = const Uuid().v1();
        Get.find<SplashController>().setGuestId(uuid);
      }
      _route();
    }

    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          if ((GetPlatform.isWeb &&
              splashController.configModel.content == null)) {
            return const SizedBox();
          } else {
            return GetMaterialApp(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: false,
              navigatorKey: Get.key,
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
              ),
              initialBinding: InitialBinding(),
              theme: themeController.darkTheme ? dark : light,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                  AppConstants.languages[0].countryCode),
              initialRoute: GetPlatform.isWeb
                  ? RouteHelper.getInitialRoute(fromPage: "main")
                  : RouteHelper.getSplashRoute(body),
              getPages: RouteHelper.routes,
              defaultTransition: Transition.fadeIn,
              transitionDuration: const Duration(milliseconds: 500),
              builder: (context, widget) => MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: Material(
                  child: Stack(
                    children: [
                      widget!,
                      GetBuilder<SplashController>(builder: (splashController) {
                        if (!splashController.savedCookiesData ||
                            !splashController.getAcceptCookiesStatus(
                                splashController
                                        .configModel.content?.cookiesText ??
                                    "")) {
                          return ResponsiveHelper.isWeb()
                              ? const Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CookiesView())
                              : const SizedBox();
                        } else {
                          return const SizedBox();
                        }
                      })
                    ],
                  ),
                ),
              ),
            );
          }
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
