import 'package:evently_c14_online_sun/core/extensions/emailvalidator.dart';
import 'package:evently_c14_online_sun/core/resources/assets_manager.dart';
import 'package:evently_c14_online_sun/core/routes_manager/routes_manager.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_button.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_divider.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_elevated_button.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_text_button.dart';
import 'package:evently_c14_online_sun/core/widgets/custom_text_form_field.dart';
import 'package:evently_c14_online_sun/fbservices/fbservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/forget pass/forget_password.dart';
import '../../core/resources/diaglogs.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool secure = true;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(child: Image.asset(ImageAssets.logo)),
              Expanded(
                flex: 4,
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 24.h,
                      ),
                      CustomTextFormField(
                          controller: emailController,
                          validation: (input) {
                            if (input == null || input.trim().isEmpty) {
                              return "Please, enter your email";
                            }
                            if (!input.isValidEmail) {
                              return "Sorry, email bad format";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          label: AppLocalizations.of(context)!.email,
                          prefixIcon: Icons.email_rounded),
                      SizedBox(
                        height: 16.h,
                      ),
                      CustomTextFormField(
                        validation: (input) {
                          if (input == null || input.trim().isEmpty) {
                            return "Please, enter your password";
                          }
                          if (input.length < 6) {
                            return "Sorry, password should be at least 6 characters";
                          }
                        },
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        isSecure: secure,
                        label: AppLocalizations.of(context)!.password,
                        prefixIcon: Icons.lock,
                        suffixIcon:
                            secure ? Icons.visibility_off : Icons.visibility,
                        onPress: _onClick,
                      ),
                      CustomTextButton(
                          title: AppLocalizations.of(context)!.forget_password,
                          onPress: () {
                            Navigator.pushNamed(context,RoutesManager.forgetPassword);
                          }),
                      CustomElevatedButton(
                          title: AppLocalizations.of(context)!.sign_in,
                          onPress: _signin),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.dont_have_account,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          CustomTextButton(
                              title:
                                  AppLocalizations.of(context)!.create_account,
                              onPress: () {
                                Navigator.pushReplacementNamed(
                                    context, RoutesManager.signUp);
                              })
                        ],
                      ),
                      CustomDivider(
                        title: AppLocalizations.of(context)!.or,
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      CustomButton(
                          title:
                              AppLocalizations.of(context)!.login_with_google,
                          onTap:_googlesignIn)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onClick() {
    setState(() {
      secure = !secure;
    });
  }


  void _signin() async
  {
    if (!(formkey.currentState!.validate())) return;
    try
    {
      DialogUtils.showLoadingDialog(context, message: "waiting...");
      await fbservices.signin(
          emailController.text, passwordController.text);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessageDialog(context,
          content: "User Logged-In", postTitle: "Ok", posAction: ()
          {
            Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
          });
    } on FirebaseAuthException catch (e)
    {
      DialogUtils.hideDialog(context);

      if (e.code == "invalid-credential")
      {
        DialogUtils.showMessageDialog(context,
            content: "Wrong Email or Password", postTitle: "try again");
      }
    } catch (e) {
      DialogUtils.hideDialog(context);
      DialogUtils.showMessageDialog(context,
          content: e.toString(), postTitle: "Try again");
    }
  }
  _googlesignIn() async {
    try {
      await fbservices.loginWithGoogle();
      DialogUtils.hideDialog(context);
      DialogUtils.showMessageDialog(context,
          content: "User Logged-In", postTitle: "Ok", posAction:()
          {
            Navigator.pushReplacementNamed(context, RoutesManager.mainLayout);
          });
    } catch (e) {
       DialogUtils.hideDialog(context);
      DialogUtils.showMessageDialog(context, content: e.toString(), postTitle: "Try again");
    }
  }

}



