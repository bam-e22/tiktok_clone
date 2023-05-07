import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/features/authentication/widgets/form_button.dart';
import 'package:tiktok_clone/router.dart';

import '../../constants/sizes.dart';

class LoginFormScreen extends StatefulWidget {
  const LoginFormScreen({Key? key}) : super(key: key);

  @override
  State<LoginFormScreen> createState() => _LoginFormScreenState();
}

class _LoginFormScreenState extends State<LoginFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formData = {};

  void _onSubmitTap(BuildContext context) {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.save();
      context.goNamed(Routes.interestsScreen);
    }
  }

  String? _isEmailValid(String? email) {
    final regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email == null || !regExp.hasMatch(email)) {
      return "Email not valid";
    }
    return null;
  }

  String? _isPasswordValid(String? password) {
    if (password == null || password.isEmpty || password.length < 8) {
      return "Password not valid";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size40,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Gaps.v28,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
                validator: (value) {
                  return _isEmailValid(value);
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['email'] = newValue;
                  }
                },
              ),
              Gaps.v16,
              TextFormField(
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
                validator: (value) {
                  return _isPasswordValid(value);
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    formData['password'] = newValue;
                  }
                },
              ),
              Gaps.v28,
              FormButton(
                enabled: true,
                text: 'Log in',
                onClick: _onSubmitTap,
              )
            ],
          ),
        ),
      ),
    );
  }
}
