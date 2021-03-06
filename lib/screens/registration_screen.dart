import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:lsrtcc_flutter/constants.dart';
import 'package:flutter/material.dart';
import 'package:lsrtcc_flutter/components/rounded_button.dart';
import 'package:lsrtcc_flutter/model/user.dart';
import 'package:lsrtcc_flutter/screens/login_screen.dart';
import 'package:lsrtcc_flutter/services/backend_api.dart';
import 'package:emojis/emojis.dart'; // to use Emoji collection

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _showPassword = false;
  var sadEmoji = Emojis.cryingFace;
  final userdata = GetStorage();

  String? name;
  String? email;
  String? phone;
  String? password;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: screenHeight,
          maxWidth: screenWidth,
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.fromLTRB(24, 80, 24, 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 150.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 48.0,
                  ),
                  TextField(
                    onChanged: (value) {
                      name = value.trim();
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Nome completo',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value.trim();
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      if (value.isNotEmpty && isNumeric(value)) {
                        phone = value.trim();
                      }
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      labelText: 'Celular',
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    obscureText: !this._showPassword,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      password = value.trim();
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        labelText: 'Senha',
                        prefixIcon: Icon(
                          Icons.security,
                          color: Colors.blueGrey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: this._showPassword
                                ? Colors.blueAccent
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(
                                () => this._showPassword = !this._showPassword);
                          },
                        )),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  RoundedButton(
                    color: Colors.blueAccent,
                    text: 'Cadastrar',
                    onPressed: () async {
                      print(
                          "Name: $name. Email: $email. Phone: $phone. Pwd: $password.");
                      User currentUser = User(
                          id: null,
                          name: name,
                          email: email,
                          phone: phone,
                          password: password);
                      String jsonUser = jsonEncode(currentUser);
                      var response = await Backend.postUser(jsonUser);
                      String responseBody = response.body;
                      var responseTitle =
                          jsonDecode(responseBody)['title'] ?? "";
                      if (response.statusCode == 201) {
                        print('Usu??rio cadastrado! ' +
                            'Status Code: ${response.statusCode}');
                        userdata.writeInMemory('msg_login',
                            'Usu??rio Cadastrado com Sucesso! $happyEmoji');
                        Navigator.pushNamed(context, LoginScreen.id);
                      } else {
                        print('ERRO! ' + 'Status Code: ${response.statusCode}');
                        print(responseTitle);
                        setState(
                          () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title:
                                    Text('Ops... Algo deu errado. $sadEmoji'),
                                content: Text(
                                    '$responseTitle\n\nStatusCode: ${response.statusCode}'),
                                elevation: 24.0,
                              ),
                              barrierDismissible: true,
                            );
                          },
                        );
                      }
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "voltar",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
