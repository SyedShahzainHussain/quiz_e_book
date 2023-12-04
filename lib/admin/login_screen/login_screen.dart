import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_e_book/extension/mediaquery_extension/mediaquery_extension.dart';
import 'package:quiz_e_book/extension/sizedbox_extension/sizedbox_extension.dart';
import 'package:quiz_e_book/resources/routes/route_name/route_name.dart';
import 'package:quiz_e_book/viewModel/login_view_model/login_view_model.dart';
import 'package:quiz_e_book/widget/button_widget.dart';

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
  
  @override
  void initState() {
    super.initState();
    // checkAuthentication(context);
  }

  void onSave() async {
    final validate = _form.currentState!.validate();
    if (!validate) {
      return;
    }
    if (validate) {
      _form.currentState!.save();
      
      final body = {
        "email": emailcontroller.text,
        "password": passwordcontroller.text,
      };
      context.read<LoginViewModel>().loginApi(body, context);
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
      body: WillPopScope(
        onWillPop: () async {
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
                        prefixIcon: Icon(Icons.admin_panel_settings),
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
                            prefixIcon: const Icon(Icons.security),
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
                    Consumer<LoginViewModel>(
                      builder: (context, value, chil) => Buttonwidget(
                        onTap: () {
                          onSave();
                        },
                        text: "Login",
                        isLoading: value.isLoading,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
