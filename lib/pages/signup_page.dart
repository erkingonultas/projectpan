import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectpan/backend/auth_handler.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/backend/post_handler.dart';
import 'package:projectpan/pages/home_switch.dart';
import 'package:projectpan/widgets/components.dart';
import 'package:projectpan/widgets/textfield.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;
  late TextEditingController _userNameController;
  late FocusNode focusNode;

  Uint8List? _userImg;
  bool _isPicSelected = false;
  bool _isOkay = true;
  bool _isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    _userNameController = TextEditingController();
    focusNode = FocusNode();
    rootBundle
        .load('assets/img/defaultUser.png')
        .then((data) => setState(() => _userImg = data.buffer.asUint8List()));

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _userNameController.dispose();
    super.dispose();
  }

  void selectImg() async {
    Uint8List _img = await PostHandler().imgPicker(ImageSource.gallery);
    if (_img.isEmpty) {
      rootBundle.load('assets/img/defaultUser.png').then(
          (data) => setState(() => {_userImg = data.buffer.asUint8List()}));
    } else {
      setState(() {
        _userImg = _img;
        _isPicSelected = true;
      });
    }
  }

  void deSelectImg() async {
    rootBundle
        .load('assets/img/defaultUser.png')
        .then((data) => setState(() => {
              _userImg = data.buffer.asUint8List(),
              _isPicSelected = false,
            }));
  }

  void signUp() async {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    if (_passwordConfirmController.text == _passwordController.text) {
      setState(() {
        _isLoading = true;
      });
      final res = await AuthHandler().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _userNameController.text.toLowerCase(),
        userPic: _userImg!,
      );
      setState(() {
        _isOkay = true;
      });
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print(res);
      }
      if (res == 'success') {
        bildirim('Account created successfully', context);
        Navigator.of(context).pushReplacementNamed(HomeSwitch.routeName);
      } else {
        bildirim(res, context);
      }
    } else {
      setState(() {
        _isOkay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      bottom: true,
      top: true,
      child: Scaffold(
        backgroundColor: botticelli,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.topLeft,
                  child: BackButton(color: balihai)),
              const Spacer(flex: 1),
              const Text(
                'Create Your Account',
                style: TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 24, color: balihai),
              ),
              const Spacer(flex: 1),
              Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1500),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    child: _userImg == null
                        ? const CircleAvatar(
                            radius: 54,
                            child: CircularProgressIndicator.adaptive(),
                            backgroundColor: botticelli,
                          )
                        : CircleAvatar(
                            radius: 54,
                            backgroundImage: MemoryImage(_userImg!),
                            backgroundColor: botticelli,
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                        color: woodsmoke.withOpacity(.95),
                        type: MaterialType.circle,
                        child: IconButton(
                          onPressed: () =>
                              _isPicSelected ? deSelectImg() : selectImg(),
                          icon: _isPicSelected
                              ? const Icon(Icons.close,
                                  color: botticelli, size: 21)
                              : const Icon(Icons.add_a_photo_rounded,
                                  color: botticelli, size: 21),
                        )),
                  ),
                ],
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextContainer(
                    controller: _userNameController,
                    hintText: 'Enter your name',
                    textInputType: TextInputType.name),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextContainer(
                    controller: _emailController,
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextContainer(
                    controller: _passwordController,
                    hintText: 'Enter your password',
                    textInputType: TextInputType.visiblePassword,
                    isPass: true),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: TextContainer(
                    controller: _passwordConfirmController,
                    hintText: 'Confirm your password',
                    textInputType: TextInputType.visiblePassword,
                    isPass: true,
                    focusNode: focusNode),
              ),
              const Spacer(flex: 1),
              if (!_isOkay)
                Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 5),
                  child: SizedBox(
                      width: size.width,
                      child: Text('the passwords should match!',
                          style: TextStyle(color: Colors.red.shade700))),
                ),
              if (!_isOkay) const Spacer(flex: 2),
              GestureDetector(
                onTap: () => signUp(),
                child: Container(
                  child: !_isLoading
                      ? const Text(
                          'CREATE YOUR ACCOUNT',
                          style: TextStyle(
                              fontSize: 18,
                              color: botticelli,
                              fontWeight: FontWeight.w500),
                        )
                      : const CircularProgressIndicator(
                          backgroundColor: balihai,
                          color: botticelli,
                          strokeWidth: 2,
                        ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: balihai,
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
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
