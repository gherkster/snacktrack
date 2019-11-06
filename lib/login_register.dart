import 'package:flutter/material.dart';
import 'package:snacktrack/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginSignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType {
  LOGIN,
  REGISTER
}

class _LoginPageState extends State<LoginSignupPage> {

  String _email = "";
  String _password = "";
  FormType _formType = FormType.LOGIN;

  bool _isLoading;
  String _errorMessage;
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Login Demo')),
      body: Stack(
        children: <Widget>[
          _buildForm(),
          _buildCircularProgress(),
        ],
      ),
    );
  }

  @override
  void initState() {
    _isLoading = false;
    _formType = FormType.LOGIN;
    _errorMessage = "";
    super.initState();
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      switch(_formType) {
        case FormType.LOGIN: {
          _formType = FormType.REGISTER;
        }
        break;
        case FormType.REGISTER: {
          _formType = FormType.LOGIN;
        }
        break;
      }
    });
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      try {
        if (_formType == FormType.LOGIN) {
          // TODO Login
          _loginPressed();
        }
        else {
          // TODO Create new user
          _createAccountPressed();
        }
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }

  Widget _buildCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildLogo(),
            _buildEmailInput(),
            _buildPasswordInput(),
            _buildPrimaryButton(),
            _buildSecondaryButton(),
            _buildGoogleLoginButton(),
            _buildErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Hero(
      tag: 'logo',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 48.0,
        ),
      ),
    );
  }

  Widget _buildEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Email',
          icon: Icon(Icons.mail, color: Colors.grey,
          )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Password',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: Text(_formType == FormType.LOGIN ? 'Login' : 'Create Account', style: TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: validateAndSubmit,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return FlatButton(
      child: Text(
        _formType == FormType.LOGIN ? 'Create an account' : 'Have an account? Sign in',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
      ),
      onPressed: toggleFormMode
    );
  }

  Widget _buildGoogleLoginButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _googleSignIn();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      highlightElevation: 8.0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/google_logo.png'), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
          fontSize: 13.0,
          color: Colors.red,
          height: 1.0,
          fontWeight: FontWeight.w300,
        ),
      );
    }
    else {
      return Container(height: 0.0,);
    }
  }

  void _googleSignIn() {
    var authHandler = new Auth(); // TODO Merge this with login pressed, make auth some sort of abstract class
    authHandler.signInWithGoogle().whenComplete(() { // TODO If google login is cancelled before completion then overview is still shown
      Navigator.pushNamed(context, '/homepage');
    });
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password
  void _loginPressed () {
    var auth = new Auth();
    auth.emailSignIn(_email, _password)
    .then((FirebaseUser user) {
      Navigator.pushNamed(context, '/homepage');
    }).catchError((e) => print(e));
  }
  void _createAccountPressed () {
    print('The user wants to create an accoutn with $_email and $_password');
  }
  void _passwordReset () {
    print("The user wants a password reset request sent to $_email");
  }
}

