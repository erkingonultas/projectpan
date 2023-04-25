import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectpan/pages/home_page.dart';
import '../backend/constants.dart';
import 'login_page.dart';
import 'onboard1.dart';

class HomeSwitch extends StatelessWidget {
  static const routeName = '/switcher';
  const HomeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     if (postProvider.isloggedIn == true) {
    //       return const HomePage();
    //     } else if (postProvider.isloggedIn == false) {
    //       return const LoginPage();
    //     } else {
    //       return const ExplorePage();
    //     }
    //   },
    // );
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const Onboard1();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: botticelli,
            ),
          );
        }
        return const LoginPage();
      },
    );
  }
}
