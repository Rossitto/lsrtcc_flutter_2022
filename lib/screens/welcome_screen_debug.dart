import 'package:flutter/material.dart';
import 'package:lsrtcc_flutter/screens/date_time_picker.dart';
import 'package:lsrtcc_flutter/screens/profile_screen.dart';
import 'package:lsrtcc_flutter/screens/registerBand_screen.dart';
import 'package:lsrtcc_flutter/screens/registerPub_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:lsrtcc_flutter/components/rounded_button.dart';

class WelcomeScreenDebug extends StatefulWidget {
  static const String id = 'welcome_screen_debug';

  @override
  _WelcomeScreenDebugState createState() => _WelcomeScreenDebugState();
}

class _WelcomeScreenDebugState extends State<WelcomeScreenDebug>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

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
          backgroundColor: animation.value,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.067),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // TODO: make this not overflow screen
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Container(
                          child: Image.asset('images/logo.png'),
                          height: 100.0,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      AnimatedTextKit(
                        animatedTexts: [
                          TyperAnimatedText('LSR_TCC',
                            textStyle: TextStyle(
                              fontSize: 35.0,
                              fontWeight: FontWeight.w900,
                            ),),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                ),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    text: 'Log in',
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    }),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    text: 'Cadastrar Usu??rio',
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    }),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    text: 'Cadastrar Banda',
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterBandScreen.id);
                    }),
                RoundedButton(
                    color: Colors.lightBlueAccent,
                    text: 'Cadastrar Pub',
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterPubScreen.id);
                    }),
                // RoundedButton(
                //   color: Colors.lightBlueAccent,
                //   text: 'Agenda (deprecated)',
                //   onPressed: () {
                //     Navigator.pushNamed(context, CalendarScreen.id);
                //   },
                // ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  text: 'Perfil',
                  onPressed: () {
                    Navigator.pushNamed(context, ProfileScreen.id);
                  },
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  text: 'Agendar Evento',
                  onPressed: () {
                    Navigator.pushNamed(context, DateTimePicker.id);
                  },
                ),
                SizedBox(
                  height: 48.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
