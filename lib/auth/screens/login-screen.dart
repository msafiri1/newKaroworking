import 'dart:io';

import 'package:karostreammemories/auth/auth-input-decoration.dart';
import 'package:karostreammemories/auth/auth-screen-wrapper.dart';
import 'package:karostreammemories/auth/auth-state.dart';
import 'package:karostreammemories/auth/screens/forgot-password-screen.dart';
import 'package:karostreammemories/auth/social-buttons/social-login-button.dart';
import 'package:karostreammemories/config/app-config.dart';
import 'package:karostreammemories/drive/http/backend-error.dart';
import 'package:karostreammemories/drive/screens/file-list/root-screen.dart';
import 'package:karostreammemories/utils/text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  static const ROUTE = 'login';
  final Map<String, String> backendErrors = {};
  final _loginFormKey = GlobalKey<FormState>();
  final Map<String, String?> formPayload = {};

  @override
  Widget build(BuildContext context) {
    final bool loading = context.select((AuthState s) => s.loading);
    final bool showGoogleBtn = context
        .select((AppConfig c) => c.backendConfig?['social.google.enable']) ?? true;
    return AuthScreenWrapper(
      title: text('Sign in to your account', size: 18),
      screen: Form(
          key: _loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                onSaved: (v) => formPayload['email'] = v,
                keyboardType: TextInputType.emailAddress,
                decoration: authInputDecoration(Icons.email_outlined, 'Email'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return trans('This field cannot be empty.');
                  } else if (!EmailValidator.validate(value)) {
                    return trans('This field requires a valid email address.');
                  } else if (backendErrors['email'] != null) {
                    return backendErrors['email'];
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              TextFormField(
                onSaved: (v) => formPayload['password'] = v,
                obscureText: true,
                decoration: authInputDecoration(Icons.lock_outline, 'Password'),
                textInputAction: TextInputAction.done,
                onFieldSubmitted: loading ? null : (_) => _login(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return trans('This field cannot be empty.');
                  } else if (backendErrors['password'] != null) {
                    return backendErrors['password'];
                  }
                  return null;
                },
              ),
              Align(
                child: TextButton(
                  child: text('Forgot password?',
                      color: Theme.of(context).accentColor),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ForgotPasswordScreen.ROUTE);
                  },
                ),
                alignment: Alignment.centerRight,
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: RaisedButton(
                  child: text('Sign In'),
                  onPressed: loading ? null : () => _login(context),
                ),
              ),
              SizedBox(height: 10),
              Platform.isAndroid && showGoogleBtn
                  ? LoginWithGoogleButton(SocialLoginProvider.google)
                  : Container(),
              SizedBox(height: 10),
            ],
          )),
      footer: AuthScreenWrapperFooter.toRegister,
    );
  }

  _login(BuildContext context) async {
    backendErrors.clear();
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      try {
        await context.read<AuthState>().login(formPayload);
        Navigator.of(context)
            .pushNamedAndRemoveUntil(RootScreen.ROUTE, (_) => false);
      } on BackendError catch (e) {
        if (e.errors.isNotEmpty) {
          backendErrors.addAll(e.errors);
          _loginFormKey.currentState!.validate();
        }
      }
    }
  }
}
