import 'package:flutter/material.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/pages/home_switch.dart';

class IntroPage extends StatefulWidget {
  static const routeName = '/intro';
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  bool isInit = false;

  @override
  void initState() {
    if (isInit == false) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          //_acHandler.initAccountInfo();
          setState(() {
            isInit = true;
          });
        },
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: botticelli,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Welcome to',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 24, color: woodsmoke),
              ),
              const Text(
                'TIMPLE',
                style: TextStyle(
                  fontFamily: 'Rubik Mono One',
                  fontSize: 64,
                  color: ebonyclay,
                ),
              ),
              const SizedBox(height: 50),
              AnimatedOpacity(
                opacity: isInit == true ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.elasticIn,
                onEnd: () {
                  // if (isloggedIn) {
                  //   print('set up');
                  //   Future(() {
                  //     _acHandler.setUpAccount();
                  //   }).then((value) {
                  //   });
                  // } else {
                  //   Navigator.pushNamed(context, LoginPage.routeName);
                  // }
                  Navigator.pushReplacementNamed(context, HomeSwitch.routeName);
                },
                child: const Text(
                  'The registration is complete.\nYou can now go to your home page.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
