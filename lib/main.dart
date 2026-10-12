import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_egypt/Screens/Culture/cubit/cubit.dart';
import 'package:visit_egypt/Screens/Culture/noSqlHelper/favourite_culture_model.dart';
import 'package:visit_egypt/Screens/Weather/cubit/cubit.dart';
import 'package:visit_egypt/Screens/companies/cubit/cubit.dart';
import 'package:visit_egypt/Screens/companies/noSqlHelper/favourite_company_model.dart';
import 'package:visit_egypt/Screens/events/noSqlHelper/favourite_event_model.dart';
import 'package:visit_egypt/Screens/inEgypt/cubit/cubit.dart';
import 'package:visit_egypt/Screens/inEgypt/noSqlHelper/favourite_place_model.dart';
import 'package:visit_egypt/constants/constants.dart';
import 'package:visit_egypt/shared/bloc_observer.dart';
import 'package:visit_egypt/shared/network/local/cache_helper.dart';
import 'package:visit_egypt/shared/network/remote/dio_helper.dart';
import 'Screens/WelcomeScreens/SplashScreen.dart';
import 'Screens/WelcomeScreens/onboarding_screen.dart';
import 'Screens/events/cubit/cubit.dart';
import 'controller/app_theme.dart';
import 'constants/translations.dart';

int initScreen=0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  await Hive.initFlutter();
  Hive.registerAdapter(DataAdapter());
  Hive.registerAdapter(DataEventAdapter());
  Hive.registerAdapter(DataAdapterPlaces());
  await Hive.openBox<DataFavPlaces>('favPlacesBox');

  Hive.registerAdapter(DataAdapterCuluture());

  await Hive.openBox<DataFav>('favBox');
  await Hive.openBox<DataFavCuluture>('favCultureBox');

  await Hive.openBox<EventFav>('favEventBox');

  await init();
  await save_loggedIn();
  await read_loggedIn();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isArabic= prefs.getBool('isArabic') ?? false;

  runApp(MyApp(isArabic));
}
FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

Future<int?> read_loggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  initScreen = prefs.getInt("initScreen")!;

  return initScreen;
}
Future<void> save_loggedIn() async {
  final prefs = await SharedPreferences.getInstance();

  prefs.setInt("initScreen", 1);

}


Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if(enableNotification){
    handleNotifications();
  }
}

handleNotifications() async {
  await firebaseMessaging.requestPermission(sound: true);
  await firebaseMessaging.subscribeToTopic("all");
}
class MyApp extends StatefulWidget {
  final bool isArabic;

  MyApp(this.isArabic);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState(isArabic);
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeProvider = ThemeProvider();

  _MyAppState(bool isArabic);

  void getCurrentTheme() async {
    themeProvider.darkTheme = await themeProvider.preference.getTheme();
  }

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => themeProvider,
    child: Consumer<ThemeProvider>(
    builder: (context, value, child){
    return MultiBlocProvider(
      providers: [
        BlocProvider(create:(context)=> TransportationCubit()),
        BlocProvider(create:(context)=> EventsCubit()),
        BlocProvider(create:(context)=> CultureCubit()),
        BlocProvider(create:(context)=> inEgyptCubit()),

      ],
      child: GetMaterialApp(
        title: 'Visit Egypt',
        theme:themeProvider.darkTheme == false ? ThemeData.light().copyWith(primaryColor: primaryColor) : ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        locale: widget.isArabic ? Locale('ar','DZ') : Locale('en','US'),
        fallbackLocale:Locale('en','US'),
        translations: Translation(),
        initialRoute: CacheHelper.getData(key: "firstOpen") == null ? "first" : "/",
        routes: {
          '/': (context) => SplashPage(),
          "first": (context)=> WelcomeScreen(),
        },    ),
    );
    }));



}

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }
}
