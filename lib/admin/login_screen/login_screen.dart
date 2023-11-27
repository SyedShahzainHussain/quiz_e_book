import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/extension/sizedbox_extension/sizedbox_extension.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/utils/utils.dart';
import 'package:quiz_e_book/widget/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenAdmin extends StatefulWidget {
  const LoginScreenAdmin({super.key});

  @override
  State<LoginScreenAdmin> createState() => _LoginScreenAdminState();
}

class _LoginScreenAdminState extends State<LoginScreenAdmin> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final _loginMode = FocusNode();
  final _passwordMode = FocusNode();
  final _form = GlobalKey<FormState>();

  ValueNotifier<bool> isObsecure = ValueNotifier<bool>(false);
  String? email;
  String? password;
  bool? isLogin;
  bool _isLoading = false;

  Future<void> getEmailPasswordFromSharedPreference() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    email = sp.getString("email") ?? '';
    password = sp.getString("password") ?? '';
    isLogin = sp.getBool('isLogin') ?? false;
  }

  addEmailToSharedPreferences() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setString("email", "Admin@gmail.com");
    sp.setString("password", "admin12345");
  }

  @override
  void initState() {
    addEmailToSharedPreferences();
    getEmailPasswordFromSharedPreference()
        .then((value) => chechUserIsLoginOrNot(isLogin!));

    super.initState();
  }

  void chechUserIsLoginOrNot(bool isLogin) {
    if (isLogin == false) {
      context.go(RouteName.adminLoginScreen);
    } else {
      context.go(RouteName.adminScreen);
    }
  }

  void onSave() async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (emailcontroller.text == email && passwordcontroller.text == password) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setBool('isLogin', true);
      await Future.delayed(const Duration(seconds: 5), () {
        setState(() {
          _isLoading = false;
        });

        context.go(RouteName.adminScreen);
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      Utils.flushBarErrorMessage("Wrong Credentials ", context);
    }
  }

  @override
  void dispose() {
    _loginMode.dispose();
    _passwordMode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin"),
        leading: IconButton(
            onPressed: () {
              context.go(RouteName.homeScreen);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body:  WillPopScope(
      onWillPop: ()  async {


        context.go(RouteName.homeScreen);
        return false;
        
        
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/3728455.png',
                      width: double.infinity,
                      height: context.screenheight * .3,
                    ),
                    TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordMode),
                      focusNode: _loginMode,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                        ),
                      ),
                    ),
                    10.height,
                    ValueListenableBuilder(
                      valueListenable: isObsecure,
                      builder: (context, value, child) {
                        return TextFormField(
                          controller: passwordcontroller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a valid password";
                            }
                            return null;
                          },
                          focusNode: _passwordMode,
                          obscuringCharacter: "*",
                          obscureText: isObsecure.value,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  isObsecure.value = !isObsecure.value;
                                },
                                icon: Icon(isObsecure.value
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                            labelText: "Password",
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.0),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    10.height,
                    Buttonwidget(
                      onTap: () {
                        onSave();
                      },
                      text: "Login",
                      isLoading: _isLoading,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
