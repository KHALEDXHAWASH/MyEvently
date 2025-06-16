import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';
import '../resources/colors_manager.dart';
import '../widgets/custom_text_form_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(ImageAssets.forgetpass),
            SizedBox(height: 20),
            CustomTextFormField(
              controller: _emailController,
              label: 'Email',
              prefixIcon: Icons.email,

            ),

          ],
        ),
      ),
    );
  }
}
