import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lsrtcc_flutter/model/band.dart';
import 'package:lsrtcc_flutter/screens/profile_screen.dart';
import 'package:lsrtcc_flutter/screens/registerBand_screen.dart';
import 'package:lsrtcc_flutter/services/api_data.dart';
import 'package:provider/provider.dart';
import 'package:lsrtcc_flutter/components/rounded_button.dart';
import 'package:lsrtcc_flutter/constants.dart';

class MyBands extends StatefulWidget {
  static const String id = 'my_bands';

  @override
  _MyBandsState createState() => _MyBandsState();
}

class _MyBandsState extends State<MyBands> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  final userdata = GetStorage();

  @override
  void initState() {
    var msgRegisterBand = userdata.read('msg_register_band');
    if (msgRegisterBand != null) {
      Future(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(msgRegisterBand),
              duration: const Duration(seconds: 5),
            ),
          );
        },
      );
    }
    userdata.remove('msg_register_band');

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);

    controller.forward();

    controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userId = userdata.read('userId');
    // var userName = userdata.read('userName') ?? '';

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<ApiData>(context, listen: false).apiGetUserBands(userId);
      // Provider.of<ApiData>(context, listen: false).apiGetUserPubs(userId);
    });
    var userBandsResponseBody = userdata.read('userBandsResponseBody');
    var userBandsCount = userdata.read('userBandsCount');
    print('MyBands userBandsCount: $userBandsCount');

    var userBands = userBandsCount == 0
        ? null
        : bandFromJson(userBandsResponseBody); // List<Band>

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return
        // ? Aqui tinha aquele SingleChildScrollableWidget usando o screenHeight e ScreenWidth. Removi em 03/07/2021 11h45. Se der ruim, incluir novamente.
        Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Minhas Bandas',
          style: TextStyle(color: Colors.white70),
        ),
        elevation: 5.0,
        backgroundColor: Colors.blueAccent[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            // Navigator.pop(context);
            Navigator.pushNamed(context, ProfileScreen.id);
          },
        ),
      ),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.067),
        // TODO: reaproveitar todo esse container para Pubs
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: userBandsCount == 0
                    ? const Center(
                        child: Text(
                          'Voc?? n??o pertence a nenhuma banda ainda... $sadEmoji',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: userBands!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              selected: true,
                              isThreeLine: true,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(
                                        userBands[index].name! +
                                            ' ?? uma banda sua! $rockAndRollHandEmoji$badassEmoji',
                                        textAlign: TextAlign
                                            .center), // come??a no 1 e n??o no 0
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              title: Text(userBands[index].name!),
                              subtitle: Text(
                                '$musicalNotesEmoji ${userBands[index].style}\n$personEmoji ${userBands[index].membersNum}',
                                style: const TextStyle(
                                  height: 1.25,
                                  wordSpacing: 1.0,
                                  letterSpacing: 1.0,
                                ),
                              ),
                              leading: CircleAvatar(
                                child: Image.asset('images/logo_not_alpha.png'),
                              ),
                              trailing: const Icon(Icons
                                  .star_outline_sharp), // * em PUB usar = Icons.nightlife
                            ),
                          );
                        },
                      ),
              ),
            ),
            // TODO: add bot??o cadastrar nova banda

            RoundedButton(
              color: Colors.blueAccent,
              text: 'Cadastrar Banda',
              onPressed: () {
                Navigator.pushNamed(context, RegisterBandScreen.id);
              },
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
          ],
        ),
      ),
    );
  }
}
