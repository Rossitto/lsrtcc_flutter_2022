import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lsrtcc_flutter/model/event.dart';
import 'package:lsrtcc_flutter/screens/profile_screen.dart';
import 'package:lsrtcc_flutter/services/api_data.dart';
import 'package:provider/provider.dart';
import 'package:lsrtcc_flutter/components/rounded_button.dart';
import 'package:lsrtcc_flutter/constants.dart';

class MyEvents extends StatefulWidget {
  static const String id = 'my_events';

  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  final userdata = GetStorage();
  var _selectedIndexConfirmed;
  var _selectedIndexPending;
  var _selectedIndexAwaiting;
  var selectedEventJson;
  int? selectedShowId;

  var userId;
  var userName;
  var userEventsResponseBody;
  var userPendingEventsResponseBody;
  var userConfirmedEventsResponseBody;
  var userAwaitingEventsResponseBody;
  var userEventsCount;
  var userConfirmedEventsCount;
  var userAwaitingEventsCount;
  var userPendingEventsCount;
  var userEvents;
  var userConfirmedEvents;
  var userPendingEvents;
  var userAwaitingEvents;

  @override
  void initState() {
    var msgRegisterEvent = userdata.read('msg_register_event');
    if (msgRegisterEvent != null) {
      Future(
        () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(msgRegisterEvent),
              duration: Duration(seconds: 5),
            ),
          );
        },
      );
      _getData();
    }
    userdata.remove('msg_register_event');

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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void fetchUserEvents() async {
    userId = userdata.read('userId');
    userName = userdata.read('userName') ?? '';

    setState(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Provider.of<ApiData>(context, listen: false).apiGetUserEvents(userId);
        Provider.of<ApiData>(context, listen: false).apiGetUserPendingEvents(userId);
        Provider.of<ApiData>(context, listen: false).apiGetUserAwaitingEvents(userId);
        Provider.of<ApiData>(context, listen: false).apiGetUserConfirmedEvents(userId);
      });
      userEventsResponseBody = userdata.read('userEventsResponseBody');

      userEventsCount = userdata.read('userEventsCount');

      userEvents = userEventsCount == 0
          ? null
          : eventFromJson(userEventsResponseBody); // List<Event>

      // userConfirmedEvents = userEventsCount == 0
      //     ? null
      //     : userEvents.where((i) => i.confirmed == true).toList();

      // PENDING
      userPendingEventsResponseBody = userdata.read('userPendingEventsResponseBody');

      userPendingEventsCount = userdata.read('userPendingEventsCount');

      userPendingEvents = userPendingEventsCount == 0
          ? null
          : eventFromJson(userPendingEventsResponseBody).toList(); // List<Event>

      // Awaiting
      userAwaitingEventsResponseBody = userdata.read('userAwaitingEventsResponseBody');

      userAwaitingEventsCount = userdata.read('userAwaitingEventsCount');

      userAwaitingEvents = userAwaitingEventsCount == 0
          ? null
          : eventFromJson(userAwaitingEventsResponseBody).toList(); // List<Event>

      // Confirmed
      userConfirmedEventsResponseBody = userdata.read('userConfirmedEventsResponseBody');

      userConfirmedEventsCount = userdata.read('userConfirmedEventsCount');

      userConfirmedEvents = userConfirmedEventsCount == 0
          ? null
          : eventFromJson(userConfirmedEventsResponseBody).toList(); // List<Event>
    });
  }

  Future<void> _getData() async {
    setState(() {
      fetchUserEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchUserEvents();

    // void refreshVariables() {
    //   _selectedIndexConfirmed = null;
    //   _selectedIndexPending = null;
    //   selectedShowId = null;
    //   selectedEventJson = null;
    // }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return
        // ? Aqui tinha aquele SingleChildScrollableWidget usando o screenHeight e ScreenWidth. Removi em 03/07/2021 11h45. Se der ruim, incluir novamente.
        Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Meus Eventos',
          style: TextStyle(color: Colors.white70),
        ),
        elevation: 5.0,
        backgroundColor: Colors.blueAccent[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, ProfileScreen.id);
          },
        ),
      ),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.067),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: userEventsCount == 0
                    ? Center(
                        child: Text(
                          'Você não tem nenhum Evento ainda... $sadEmoji',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                      child: Column(
                          children: [
                            Text("Confirmados"),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            userConfirmedEventsCount == 0
                                ? Center(
                                    child: Text(
                                      '\n',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: userConfirmedEventsCount,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: ListTile(
                                          selected:
                                              index == _selectedIndexConfirmed,
                                          selectedTileColor: Colors.lightBlue[50],
                                          isThreeLine: true,
                                          onTap: () {
                                            setState(() {
                                              _selectedIndexAwaiting = null;
                                              _selectedIndexPending = null;
                                              _selectedIndexConfirmed = index;
                                              selectedShowId = userConfirmedEvents[index].id;
                                            });

                                            selectedEventJson =
                                                userConfirmedEvents[index]
                                                    .toJson();
                                            userdata.remove('selectedEventJson');
                                            userdata.write('selectedEventJson',
                                                selectedEventJson);

                                            // var selectedEventName = userEvents[index].name;
                                            // userdata.write(
                                            //     'selectedBandName', selectedBandName);

                                            // ScaffoldMessenger.of(context).showSnackBar(
                                            //   SnackBar(
                                            //     behavior: SnackBarBehavior.floating,
                                            //     // Text(userEvents[index].showDatetime.toString().substring(0, 16) + 'pressionado') // começa no 1 e não no 0
                                            //     content: Text(
                                            //         '${userEvents[index].band.name} no ${userEvents[index].pub.name}??\nEsse show vai ser TOP!!! $fireEmoji',
                                            //         textAlign: TextAlign.center),
                                            //     duration: Duration(seconds: 1),
                                            //   ),
                                            // );
                                          },
                                          title: Text(userConfirmedEvents[index]
                                              .showDatetime
                                              .toString()
                                              .substring(0, 16)),
                                          subtitle: Text(
                                            '$guitarEmoji ${userConfirmedEvents[index].band.name}\n$addressEmoji ${userConfirmedEvents[index].pub.name}',
                                            style: TextStyle(
                                              height: 1.25,
                                              wordSpacing: 1.0,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.green,
                                            child: Icon(Icons.event,
                                                color: Colors.white),
                                          ),
                                          trailing: Icon(Icons
                                              .nightlife), // * em EVENT usar = Icons.nightlife
                                        ),
                                      );
                                    },
                                  ),
                            Text("Pendentes"),
                            userPendingEventsCount == 0
                                ? Center(
                              child: Text(
                                '\n',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            )
                            :
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: userPendingEventsCount,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    selected: index == _selectedIndexPending,
                                    selectedTileColor: Colors.lightBlue[50],
                                    isThreeLine: true,
                                    onTap: () {
                                      setState(() {
                                        _selectedIndexAwaiting = null;
                                        _selectedIndexConfirmed = null;
                                        _selectedIndexPending = index;
                                        selectedShowId = userPendingEvents[index].id;
                                      });

                                      selectedEventJson =
                                          userPendingEvents[index].toJson();
                                      userdata.remove('selectedEventJson');
                                      userdata.write(
                                          'selectedEventJson', selectedEventJson);

                                      // var selectedEventName = userEvents[index].name;
                                      // userdata.write(
                                      //     'selectedBandName', selectedBandName);

                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(
                                      //     behavior: SnackBarBehavior.floating,
                                      //     // Text(userEvents[index].showDatetime.toString().substring(0, 16) + 'pressionado') // começa no 1 e não no 0
                                      //     content: Text(
                                      //         '${userEvents[index].band.name} no ${userEvents[index].pub.name}??\nEsse show vai ser TOP!!! $fireEmoji',
                                      //         textAlign: TextAlign.center),
                                      //     duration: Duration(seconds: 1),
                                      //   ),
                                      // );
                                    },
                                    title: Text(userPendingEvents[index]
                                        .showDatetime
                                        .toString()
                                        .substring(0, 16)),
                                    subtitle: Text(
                                      '$guitarEmoji ${userPendingEvents[index].band.name}\n$addressEmoji ${userPendingEvents[index].pub.name}',
                                      style: TextStyle(
                                        height: 1.25,
                                        wordSpacing: 1.0,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      // backgroundColor: Colors.blue,
                                      child: Icon(Icons.event),
                                    ),
                                    trailing: Icon(Icons
                                        .nightlife), // * em EVENT usar = Icons.nightlife
                                  ),
                                );
                              },
                            ),
                            Text("Aguardando"),
                            userAwaitingEventsCount == 0
                                ? Center(
                              child: Text(
                                '\n',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                            )
                           :
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: userAwaitingEventsCount,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    selected: index == _selectedIndexAwaiting,
                                    selectedTileColor: Colors.lightBlue[50],
                                    isThreeLine: true,
                                    onTap: () {
                                      setState(() {
                                        _selectedIndexPending = null;
                                        _selectedIndexConfirmed = null;
                                        _selectedIndexAwaiting = index;
                                        selectedShowId = userAwaitingEvents[index].id;
                                      });

                                      selectedEventJson = userAwaitingEvents[index].toJson();
                                      userdata.remove('selectedEventJson');
                                      userdata.write('selectedEventJson', selectedEventJson);

                                      // var selectedEventName = userEvents[index].name;
                                      // userdata.write(
                                      //     'selectedBandName', selectedBandName);

                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(
                                      //     behavior: SnackBarBehavior.floating,
                                      //     // Text(userEvents[index].showDatetime.toString().substring(0, 16) + 'pressionado') // começa no 1 e não no 0
                                      //     content: Text(
                                      //         '${userEvents[index].band.name} no ${userEvents[index].pub.name}??\nEsse show vai ser TOP!!! $fireEmoji',
                                      //         textAlign: TextAlign.center),
                                      //     duration: Duration(seconds: 1),
                                      //   ),
                                      // );
                                    },
                                    title: Text(userAwaitingEvents[index]
                                        .showDatetime
                                        .toString()
                                        .substring(0, 16)),
                                    subtitle: Text(
                                      '$guitarEmoji ${userAwaitingEvents[index].band.name}\n$addressEmoji ${userAwaitingEvents[index].pub.name}',
                                      style: TextStyle(
                                        height: 1.25,
                                        wordSpacing: 1.0,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      // backgroundColor: Colors.blue,
                                      child: Icon(Icons.event),
                                    ),
                                    trailing: Icon(Icons
                                        .nightlife), // * em EVENT usar = Icons.nightlife
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ),
              ),
            ),
            RoundedButton(
              color: Colors.green,
              text: 'Confirmar',
              onPressed: () {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Provider.of<ApiData>(context, listen: false)
                      .apiConfirmEvent(selectedShowId);
                  // refreshVariables();
                  // _getData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Evento CONFIRMADO com sucesso"),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pushNamed(context, MyEvents.id);
                });
              },
            ),
            RoundedButton(
              color: Colors.redAccent,
              text: 'Deletar',
              onPressed: () {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  Provider.of<ApiData>(context, listen: false)
                      .apiDeleteUserEvent(selectedShowId);
                  // refreshVariables();
                  // _getData();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text("Evento DELETADO com sucesso"),
                      duration: Duration(seconds: 2),
                    ),
                  );

                  Navigator.pushNamed(context, MyEvents.id);
                });
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
