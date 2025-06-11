import 'package:evently_c14_online_sun/core/extensions/emailvalidator.dart';
import 'package:evently_c14_online_sun/core/resources/assets_manager.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_elevated_button.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_text_form_field.dart';
import 'package:evently_c14_online_sun/fbservices/fbservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/resources/diaglogs.dart';
import '../../core/routes_manager/routes_manager.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool securePassword = true;
  bool secureRePassword = true;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController repassController;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    repassController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repassController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.sign_up,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: Image.asset(ImageAssets.logo)),
          Expanded(
            flex: 4,
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SingleChildScrollView(
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextFormField(
                          validation: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return "Please, enter your name";
                            }
                            return null;
                          },
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          label: AppLocalizations.of(context)!.name,
                          prefixIcon: Icons.person),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomTextFormField(
                          validation: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return "Please, enter your e-mail";
                            }
                            if (!input.isValidEmail) {
                              return "please enter a valid e-mail";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          label: AppLocalizations.of(context)!.email,
                          prefixIcon: Icons.email),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomTextFormField(
                        validation: (input) {
                          if (input == null || input.trim().isEmpty) {
                            return "Please, enter password";
                          }
                          if (input.length < 6) {
                            return "Sorry, password at least 6 characters";
                          }
                          return null;
                        },
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        label: AppLocalizations.of(context)!.password,
                        prefixIcon: Icons.lock,
                        suffixIcon: securePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        isSecure: securePassword,
                        onPress: _onPasswordIconClicked,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomTextFormField(
                        controller: repassController,
                        validation: (input) {
                          if (input == null || input.trim().isEmpty) {
                            return "Please, enter re-password";
                          }
                          if (input != passwordController.text) {
                            return "password not match";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        label: AppLocalizations.of(context)!.re_password,
                        prefixIcon: Icons.lock,
                        suffixIcon: secureRePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        isSecure: secureRePassword,
                        onPress: _onRePasswordIconClicked,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomElevatedButton(
                          title: AppLocalizations.of(context)!.sign_up,
                          onPress: _signup),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.already_have_account,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, RoutesManager.signIn);
                              },
                              child: Text(
                                AppLocalizations.of(context)!.sign_in,
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onPasswordIconClicked() {
    setState(() {
      securePassword = !securePassword;
    });
  }

  void _onRePasswordIconClicked() {
    setState(() {
      secureRePassword = !secureRePassword;
    });
  }
  void _signup() async {
    if (!(formkey.currentState!.validate())) return;
    try {
      DialogUtils.showLoadingDialog(context, message: "Waiting...");
      await fbservices.signUp(
          emailController.text, passwordController.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessageDialog(context,
          content: "User Registered Successfully",
          postTitle: "Ok", posAction: () {
            Navigator.pushReplacementNamed(context, RoutesManager.signIn);
          });
    } on FirebaseAuthException catch (e) {
      DialogUtils.hideDialog(context);
      if (e.code =="weak-password") {
        DialogUtils.showMessageDialog(context,
            content: 'The password provided is too weak.',
            postTitle: "try again");
      } else if (e.code =="email-already-in-use") {
        DialogUtils.showMessageDialog(context,
            content: 'The account already exists for that email.',
            postTitle: "try again");
      }
    } catch (e) {
      DialogUtils.hideDialog(context);
      DialogUtils.showMessageDialog(context,
          content: e.toString(), postTitle: "try again");
    }
  }
}

