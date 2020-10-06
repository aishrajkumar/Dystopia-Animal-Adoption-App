import 'package:dystopia_flutter_app/data/email_sign_in_model.dart';
import 'package:dystopia_flutter_app/data/sign_in_loading_notifier.dart';
import 'package:dystopia_flutter_app/screens/sign_up_form.dart';
import 'package:dystopia_flutter_app/services/auth.dart';

import 'package:dystopia_flutter_app/widgets/platform_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../theme.dart';
import '../widgets/sign_in_helpers/layout.dart';
import '../widgets/sign_in_helpers/signup_or_login.dart';
import '../widgets/sign_in_helpers/social_signin.dart';

class SignInPage extends StatelessWidget {
  final SignInLoadingNotifier block;
  final bool loadingValue;
  const SignInPage({Key key, @required this.block, @required this.loadingValue})
      : super(key: key);
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
          builder: (_, isLoading, __) => Provider<SignInLoadingNotifier>(
                create: (_) =>
                    SignInLoadingNotifier(auth: auth, isLoading: isLoading),
                child: Consumer<SignInLoadingNotifier>(
                  builder: (context, bloc, _) => SignInPage(
                    block: bloc,
                    loadingValue: isLoading.value,
                  ),
                ),
              )),
    );
  }

/* 
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await block.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await block.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }



  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatFormExceptionAlertDialog(title: 'Sign In Failed', exception: exception);
  }

*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: kSignUpColors,
                  stops: [
                    0.1,
                    0.4,
                    0.7,
                    0.9,
                  ],
                ),
              ),
            ),
            Container(
              height: double.infinity,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    SigninFields.create(context),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SigninFields extends StatefulWidget {
  final EmailSignInChangeModel model;
  SigninFields({@required this.model, Key key}) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(builder: (context, model, _) {
        return SigninFields(model: model);
      }),
    );
  }

  @override
  _SigninFieldsState createState() => _SigninFieldsState();
}

class _SigninFieldsState extends State<SigninFields> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      model.formType = EmailSignInFormType.SignIn;
      await model.submit();
    } on PlatformException catch (e) {
      PlatFormExceptionAlertDialog(
        title: 'Sign In Failed',
        exception: e,
      ).show(context);
    }
  }

  void _onEmailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  _displaySignUpForm() {
    _emailController.clear();
    _passwordController.clear();
    PlatformPageRoute.pageRoute(
      widget: SignUpForm(),
      fullScreen: false,
      fromRoot: true,
      context: context,
    );
  }

  Container _buildLoginButton() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 25.0,
      ),
      width: double.infinity,
      child: RaisedButton(
        onPressed: model.canSubmit ? _submit : null,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF565165),
            fontFamily: 'OpenSans',
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Container _buildRememberMe() {
    return Container(
        height: 20.0,
        child: Row(
          children: <Widget>[
            Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white,
              ),
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value;
                  });
                },
                checkColor: Color(0xFFb0abbf),
                activeColor: Colors.white,
              ),
            ),
            Text(
              'Remember Me',
              style: kLabelStyle,
            )
          ],
        ));
  }

  Container _buildForgotPassButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(
          "Forgot Password?",
          style: kLabelStyle,
        ),
        onPressed: () => debugPrint("FORGOT PASSWORD BUTTON PRESSED!"),
      ),
    );
  }

  Column _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            obscureText: true,
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            autocorrect: false,
            onEditingComplete: _submit,
            onChanged: model.updatePassword,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your password',
              hintStyle: kHintTextStyle,
              errorText: model.showPasswordErrorText
                  ? model.invalidPasswordErrorText
                  : null,
              enabled: model.isLoading == false,
            ),
          ),
        )
      ],
    );
  }

  Column _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            focusNode: _emailFocusNode,
            controller: _emailController,
            textInputAction: TextInputAction.next,
            onEditingComplete: () => _onEmailEditingComplete(),
            onChanged: model.updateEmail,
            enabled: model.isLoading == false,
            autocorrect: false,
            maxLines: 1,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your email',
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _buildChildren() {
      return [
        _buildEmail(),
        SizedBox(
          height: 30.0,
        ),
        _buildPassword(),
        _buildForgotPassButton(),
        _buildRememberMe(),
        _buildLoginButton(),
        Layout(),
        SizedBox(
          height: 10.0,
        ),
        SocialSignin(),
        SizedBox(
          height: 10.0,
        ),
        Divider(
          color: Colors.grey,
          height: 10,
          thickness: 2,
        ),
        SizedBox(
          height: 10.0,
        ),
        Center(
          child: SignUpOrIn(
            description: 'Don\'t have an Account? ',
            highlighted: 'Sign Up!',
            action: () => _displaySignUpForm(),
          ),
        )
      ];
    }

    return Column(
      children: _buildChildren(),
      crossAxisAlignment: CrossAxisAlignment.stretch,
    );
  }
}
