import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/pages/home_switch.dart';
import 'package:projectpan/pages/login_page.dart';
import 'package:projectpan/pages/explore_page.dart';
import 'package:projectpan/pages/home_page.dart';
import 'package:projectpan/pages/intro_page.dart';
import 'package:projectpan/pages/share_page.dart';
import 'package:projectpan/pages/signup_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    systemStatusBarContrastEnforced: true,
    systemNavigationBarColor: Colors.black,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountInfoHandler()),
        ChangeNotifierProvider(create: (_) => PostHandler()),
      ],
      child: MaterialApp(
        //debugShowMaterialGrid: true,
        debugShowCheckedModeBanner: false,
        title: 'TIMPLE',
        theme: ThemeData(
          fontFamily: 'Rubik',
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
          backgroundColor: botticelli,
          primaryColor: woodsmoke,
          // pageTransitionsTheme: const PageTransitionsTheme(
          //   builders: {
          //     TargetPlatform.android: ZoomPageTransitionsBuilder(),
          //     // TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
          //     //   transitionType: SharedAxisTransitionType.horizontal,
          //     // ),
          //   },
          // ),
        ),

        initialRoute: IntroPage.routeName,

        routes: {
          HomePage.routeName: (ctx) => const HomePage(),
          IntroPage.routeName: (ctx) => const IntroPage(),
          ExplorePage.routeName: (ctx) => const ExplorePage(),
          //FullpostPage.routeName: (ctx) => const FullpostPage(),
          LoginPage.routeName: (ctx) => const LoginPage(),
          SignupPage.routeName: (ctx) => const SignupPage(),
          SharePage.routeName: (ctx) => const SharePage(),
          HomeSwitch.routeName: (ctx) => const HomeSwitch(),
          //SearchPage.routeName: (ctx) => const SearchPage(),
          //ProfilePage.routeName: (ctx) => const ProfilePage(),
        },
        //onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
