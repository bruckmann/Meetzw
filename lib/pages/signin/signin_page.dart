import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meetz/core/core.dart';
import 'package:meetz/pages/home/home_page.dart';
import 'package:meetz/pages/signup/signup_page.dart';
import 'package:meetz/shared/widgets/input_widget.dart';
import 'package:meetz/shared/widgets/button_widget.dart';
import 'package:meetz/shared/widgets/snack_bar_widget.dart';
import 'package:meetz/shared/widgets/switch_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppGradients.linear,
                )),
            Form(
                key: _formkey,
                child: Center(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'OpenSans',
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 30.0),

                        InputWidget(
                          obscureText: false,
                          label: "E-mail",
                          placeHolder: "Insira seu e-mail",
                          icon: Icons.email,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return ("O campo e-mail não está preenchido corretamente");
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.0),
                        InputWidget(
                          obscureText: true,
                          label: "Senha",
                          placeHolder: "Insira sua senha",
                          icon: Icons.lock,
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return ("O campo senha não está preenchido corretamente");
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        //RememberMeWidget(),
                        ButtonWidget(
                            text: 'ENTRAR',
                            onPressed: () async {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (_formkey.currentState!.validate()) {
                                var isRight = await signIn();

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                if (isRight) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                } else {
                                  _passwordController.clear();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBarError);
                                }
                              }
                            }),
                        SwitchButtonWidget(
                          text: "Não possui uma conta? ",
                          textButton: "Cadastre-se",
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SingUpPage()));
                          },
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  final snackBarError = SnackBar(
      content: Text("E-mail ou senha inválidos", textAlign: TextAlign.center),
      backgroundColor: Colors.redAccent);

  Future<bool> signIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse("${dotenv.env["URL"]}/login");

    Map data = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };
    String body = json.encode(data);

    http.Response? response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    Map<String, dynamic> map = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String token = map['token'];
      String id = map['id'].toString();
      await sharedPreferences.setStringList('config', [token, id]);
      return true;
    } else {
      return false;
    }
  }
}
