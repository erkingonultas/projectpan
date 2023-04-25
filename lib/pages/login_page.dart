import 'package:flutter/material.dart';
import 'package:projectpan/backend/auth_handler.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/pages/home_page.dart';
import 'package:projectpan/widgets/components.dart';
import 'package:projectpan/widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late FocusNode focusNode;
  bool _isLoading = false;
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    setState(() {
      _isLoading = true;
    });
    String res = await AuthHandler().loginUser(
        password: _passwordController.text, email: _emailController.text);

    if (res == 'Success.') {
      // bildirim('Login successful', context);
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    } else {
      bildirim(res, context);
    }
    setState(() {
      _isLoading = false;
    });
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
                  child: BackButton(color: ebonyclay)),
              const Spacer(flex: 5),
              const Text(
                'Welcome to',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 24,
                    color: woodsmoke),
              ),
              const Text(
                'TIMPLE',
                style: TextStyle(
                  fontFamily: 'Rubik Mono One',
                  fontSize: 64,
                  color: ebonyclay,
                ),
              ),
              const Spacer(flex: 2),
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
                    isPass: true,
                    focusNode: focusNode),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 5),
                child: SizedBox(
                    width: size.width,
                    child: const Text('Forgot my password',
                        style: TextStyle(color: ebonyclay))),
              ),
              const Spacer(flex: 2),
              GestureDetector(
                onTap: () => loginUser(),
                child: Container(
                  child: !_isLoading
                      ? const Text(
                          'LOGIN',
                          style: TextStyle(
                              fontSize: 24,
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
                    color: ebonyclay,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Spacer(flex: 4),
              // GestureDetector(
              //   //onTap: (() => Navigator.pushNamed(context, SignupPage.routeName)),
              //   onTap: () => Navigator.push(
              //     context,
              //     defaultPageAnim(page: const Onboard1()),
              //   ),
              //   child: const Text('Create an account', style: TextStyle(color: balihai)),
              // ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
