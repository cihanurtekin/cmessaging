import 'package:example/helper/sentences.dart';
import 'package:example/helper/validator.dart';
import 'package:example/view_model/register_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerForm = GlobalKey<FormState>();

  final double _spacing = 8.0;

  String _nameSurname = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => RegisterViewModel(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            margin: EdgeInsets.only(top: 24.0),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Consumer<RegisterViewModel>(
                  builder: (ctx, viewModel, child) => Form(
                    key: _registerForm,
                    autovalidateMode: viewModel.formAutoValidateMode,
                    child: Column(
                      children: <Widget>[
                        _buildNameSurnameTextField(context),
                        SizedBox(height: _spacing),
                        _buildEmailTextField(context),
                        SizedBox(height: _spacing),
                        _buildPasswordTextField(context),
                        SizedBox(height: _spacing),
                        _buildPasswordAgainTextField(context),
                        SizedBox(height: _spacing),
                        _buildRegisterButton(context),
                        SizedBox(height: _spacing),
                      ],
                    ),
                  ),
                ),
                _buildToLoginPageButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameSurnameTextField(BuildContext context) {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.text,
        autofocus: false,
        maxLength: Validator.NAME_SURNAME_MAX_LENGTH,
        decoration: InputDecoration(
          hintText: Sentences.nameSurname(),
        ),
        validator: Validator.validateNameSurname,
        onSaved: (String? value) {
          if (value != null) {
            _nameSurname = value.trim();
          }
        },
      ),
    );
  }

  Widget _buildEmailTextField(BuildContext context) {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        maxLength: Validator.EMAIL_MAX_LENGTH,
        decoration: InputDecoration(
          hintText: Sentences.email(),
        ),
        validator: Validator.validateEmail,
        onSaved: (String? value) {
          if (value != null) {
            _email = value.trim();
          }
        },
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return Container(
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) => TextFormField(
          keyboardType: TextInputType.text,
          obscureText: !viewModel.showPassword,
          autofocus: false,
          maxLength: Validator.PASSWORD_MAX_LENGTH,
          decoration: InputDecoration(
            hintText: Sentences.password(),
            suffixIcon: IconButton(
              icon: Icon(viewModel.showPassword
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                viewModel.changeShowPassword();
              },
            ),
          ),
          onChanged: (value) => _password = value.trim(),
          validator: Validator.validatePassword,
          onSaved: (String? value) {
            if (value != null) {
              _password = value.trim();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPasswordAgainTextField(BuildContext context) {
    return Container(
      child: Consumer<RegisterViewModel>(
        builder: (context, viewModel, child) => TextFormField(
          keyboardType: TextInputType.text,
          autofocus: false,
          obscureText: !viewModel.showPasswordAgain,
          maxLength: Validator.PASSWORD_MAX_LENGTH,
          decoration: InputDecoration(
            hintText: Sentences.passwordAgain(),
            suffixIcon: IconButton(
              icon: Icon(viewModel.showPassword
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                viewModel.changeShowPasswordAgain();
              },
            ),
          ),
          validator: (String? value) => Validator.validatePasswordAgain(
            _password,
            value,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Consumer<RegisterViewModel>(
        builder: (ctx, viewModel, child) => ElevatedButton(
          child: Text(
            Sentences.register(),
          ),
          onPressed: () {
            FormState? formState = _registerForm.currentState;
            if (formState != null && formState.validate()) {
              formState.save();
              viewModel.signUpWithEmailAndPassword(
                context,
                _email,
                _password,
                _nameSurname,
              );
            } else {
              viewModel.formAutoValidateMode = AutovalidateMode.always;
            }
          },
        ),
      ),
    );
  }

  Widget _buildToLoginPageButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Consumer<RegisterViewModel>(
        builder: (ctx, viewModel, child) => ElevatedButton(
          child: Text(
            Sentences.loginIfHaveAccount(),
          ),
          onPressed: () {
            viewModel.navigateToLoginPage(context);
          },
        ),
      ),
    );
  }
}
