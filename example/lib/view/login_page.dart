import 'package:example/helper/sentences.dart';
import 'package:example/helper/validator.dart';
import 'package:example/view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginForm = GlobalKey<FormState>();

  final double _spacing = 8.0;
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    //logAuthInfo();
    return ChangeNotifierProvider(
      create: (ctx) => LoginViewModel(),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Container(
            margin: EdgeInsets.only(top: 48.0),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _loginForm,
                  child: Column(
                    children: <Widget>[
                      _buildEmailTextField(context),
                      SizedBox(height: _spacing),
                      _buildPasswordTextField(context),
                      SizedBox(height: _spacing),
                      _buildLoginButton(context),
                      SizedBox(height: _spacing),
                    ],
                  ),
                ),
                _buildForgotPasswordField(),
                SizedBox(height: _spacing),
                _buildGoogleSignInButton(context),
                SizedBox(height: _spacing),
                _buildToRegisterPageButton(context),
              ],
            ),
          ),
        ),
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
        validator: (String value) =>
            Validator.validateEmail(context, value.trim()),
        onSaved: (String value) => _email = value.trim(),
      ),
    );
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return Container(
      child: Consumer<LoginViewModel>(
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
          validator: (String value) =>
              Validator.validatePassword(context, value.trim()),
          onSaved: (String value) => _password = value.trim(),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Consumer<LoginViewModel>(
        builder: (ctx, viewModel, child) => RaisedButton(
          child: Text(
            Sentences.login(),
          ),
          onPressed: () {
            if (_loginForm.currentState.validate()) {
              _loginForm.currentState.save();
              viewModel.signInWithEmailAndPassword(context, _email, _password);
            } else {
              viewModel.autoValidateForm = true;
            }
          },
        ),
      ),
    );
  }

  Widget _buildForgotPasswordField() {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) => FlatButton(
        child: Text(Sentences.forgotPassword()),
        onPressed: () {
          _showPasswordResetDialog(context).then((value) {
            if (value != null && value.trim().isNotEmpty) {
              viewModel.sendPasswordResetEmail(context, value);
            }
          });
        },
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    const double iconWidth = 24;
    return Container(
      width: double.infinity,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) => RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                'assets/images/google_logo.png',
                width: iconWidth,
              ),
              Text(
                Sentences.singInWithGoogle(),
              ),
              SizedBox(width: iconWidth),
            ],
          ),
          //color: Color.fromARGB(255, 211, 72, 54),
          onPressed: () {
            viewModel.signInWithGoogle(context);
          },
        ),
      ),
    );
  }

  Widget _buildToRegisterPageButton(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) =>RaisedButton(
          child: Text(
            Sentences.registerIfNoAccount(),
          ),
          onPressed: () {
            viewModel.navigateToRegisterPage(context);
          }
        ),
      ),
    );
  }

  Future<String> _showPasswordResetDialog(BuildContext context) {
    /*return DialogHelper.show<String>(
        context,
        PasswordResetDialog(
          titleText: Sentences.resetPassword(),
          emailHint: Sentences.email(),
          acceptButtonText: Sentences.accept(),
          cancelButtonText: Sentences.cancel(),
        ));*/
  }
}
