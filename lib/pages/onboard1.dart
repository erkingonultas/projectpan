import 'package:flutter/material.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/pages/login_page.dart';
import 'package:projectpan/pages/signup_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';

class Onboard1 extends StatefulWidget {
  const Onboard1({Key? key}) : super(key: key);

  @override
  State<Onboard1> createState() => _Onboard1State();
}

class _Onboard1State extends State<Onboard1> {
  final CarouselSliderController _pageController = CarouselSliderController();

  bool _isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: woodsmoke,
        body: Stack(
          children: [
            CarouselSlider(
              controller: _pageController,
              viewportFraction: .998,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              slideTransform: const BackgroundToForegroundTransform(),
              unlimitedMode: true,
              enableAutoSlider: true,
              autoSliderTransitionTime: const Duration(seconds: 1),
              autoSliderTransitionCurve: Curves.decelerate,
              children: [
                onb1Img,
                onb2Img,
                onb3Img,
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  //height: size.height * .35,
                  width: size.width * .98,

                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'TIMPLE',
                        style: TextStyle(
                          fontFamily: 'Rubik Mono One',
                          fontSize: 32,
                          color: Colors.white.withOpacity(.75),
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: CarouselSlider(
                          controller: _pageController,
                          slideTransform: const TabletTransform(),
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          viewportFraction: .99,
                          unlimitedMode: true,
                          enableAutoSlider: true,
                          autoSliderTransitionTime: const Duration(seconds: 1),
                          autoSliderTransitionCurve: Curves.decelerate,
                          slideIndicator: SequentialFillIndicator(
                            padding: const EdgeInsets.only(bottom: 32),
                            currentIndicatorColor: balihai,
                            indicatorRadius: 8.0,
                            indicatorBorderColor: Colors.grey,
                            indicatorBackgroundColor: Colors.grey,
                            indicatorBorderWidth: 2.0,
                            itemSpacing: 25.0,
                          ),
                          children: [
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper consequat ante.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Vestibulum vel semper tellus. Quisque justo quam, mattis id neque quis, rhoncus hendrerit risus.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Pellentesque lobortis ligula nibh, ac rhoncus turpis mollis in.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 23,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTapDown: (details) {
                          setState(() {
                            _isButtonPressed = true;
                          });
                        },
                        onTapUp: (details) {
                          setState(() {
                            _isButtonPressed = false;
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            _isButtonPressed = false;
                          });
                        },
                        onTap: () => {
                          Navigator.push(
                            context,
                            defaultPageAnim(
                                page: const SignupPage(),
                                alignment: Alignment.bottomCenter),
                          ),
                        },
                        child: Container(
                          height: _isButtonPressed
                              ? size.height * .06
                              : size.height * .075,
                          width: _isButtonPressed
                              ? size.width * .75
                              : size.width * .85,
                          // height: size.height * .06,
                          // width: size.width * .75,
                          alignment: Alignment.center,
                          child: Text(
                            'JOIN THE COMMUNITY',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: balihai.withOpacity(.7),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: woodsmoke.withOpacity(.25),
                                offset: const Offset(0, 5),
                                blurRadius: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        //onTap: (() => Navigator.pushNamed(context, SignupPage.routeName)),
                        onTap: () => Navigator.push(
                          context,
                          defaultPageAnim(page: const LoginPage()),
                        ),
                        child: const Text('I have an account',
                            style: TextStyle(color: botticelli)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
