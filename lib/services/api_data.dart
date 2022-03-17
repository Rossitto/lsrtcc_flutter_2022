import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lsrtcc_flutter/model/band.dart';
import 'package:lsrtcc_flutter/model/event.dart';
import 'package:lsrtcc_flutter/model/pub.dart';
import 'package:lsrtcc_flutter/services/backend_api.dart';

class ApiData extends ChangeNotifier {
  // VALORES INICIAIS:
  final _userdata = GetStorage();

  void apiGetUserBands(int? userId) async {
    var response = await Backend.getBandsByUser(userId);

    String userBandsResponseBody = response.body;
    // print('apiGetBandsByUser responseBody: $userBandsResponseBody');

    // var userBand_1_name = userBands[1].name;
    // var userBand_1_style = userBands[1].style;
    // print('apiGetBandsByUser userBand_1_name: $userBand_1_name');
    // print('apiGetBandsByUser userBand_1_style: $userBand_1_style');

    // && responseBody != '[]'
    if (response.statusCode == 200 && userBandsResponseBody != '[]') {
      _userdata.write('userBandsResponseBody', userBandsResponseBody);

      var userBands = bandFromJson(userBandsResponseBody);
      var userBandsCount = userBands.length;
      // print('apiGetBandsByUser userBandsCount: $userBandsCount');

      // var UserBandsCountInitial = _userdata.read('userBandsCount');
      // print('UserBandsCountInitial: $UserBandsCountInitial');

      _userdata.write('userBandsCount', userBandsCount);

      notifyListeners();
    } else {
      // _userdata.write('userBands', null);
      _userdata.write('userBandsCount', 0);
    }
    notifyListeners();
  }

  void apiGetUserPubs(int? userId) async {
    var response = await Backend.getPubsByUser(userId);

    String userPubsResponseBody = response.body;
    // print('apiGetPubsByUser responseBody: $userPubsResponseBody');

    if (response.statusCode == 200 && userPubsResponseBody != '[]') {
      _userdata.write('userPubsResponseBody', userPubsResponseBody);

      var userPubs = pubFromJson(userPubsResponseBody);
      var userPubsCount = userPubs.length;
      // print('apiGetPubsByUser userPubsCount: $userPubsCount');

      _userdata.write('userPubsCount', userPubsCount);

      notifyListeners();
    } else {
      _userdata.write('userPubsCount', 0);
    }

    notifyListeners();
  }

  void apiGetUserEvents(int? userId) async {
    print("userId: $userId");
    var response = await Backend.getEventsByUser(userId);

    String userEventsResponseBody = response.body;

    if (response.statusCode == 200 && userEventsResponseBody != '[]') {
      _userdata.write('userEventsResponseBody', userEventsResponseBody);

      var userEvents = eventFromJson(userEventsResponseBody);
      var userEventsCount = userEvents.length;

      _userdata.write('userEventsCount', userEventsCount);

      notifyListeners();
    } else {
      _userdata.write('userEventsCount', 0);
      _userdata.write('userEventsResponseBody', '');
    }

    notifyListeners();
  }

  void apiGetUserPendingEvents(int? userId) async {
    print("userId: $userId");
    var response = await Backend.getPendingEventsByUser(userId);

    String userPendingEventsResponseBody = response.body;

    if (response.statusCode == 200 && userPendingEventsResponseBody != '[]') {
      _userdata.write('userPendingEventsResponseBody', userPendingEventsResponseBody);

      var userPendingEvents = eventFromJson(userPendingEventsResponseBody).toList();
      print(userPendingEvents);

      _userdata.write('userPendingEvents', userPendingEvents);

      var userPendingEventsCount = userPendingEvents.length;

      _userdata.write('userPendingEventsCount', userPendingEventsCount);

      notifyListeners();
    } else {
      _userdata.write('userPendingEventsCount', 0);
      _userdata.write('userPendingEventsResponseBody', '');
    }

    notifyListeners();
  }

  void apiGetUserAwaitingEvents(int? userId) async {
    print("userId: $userId");
    var response = await Backend.getAwaitingEventsByUser(userId);

    String userAwaitingEventsResponseBody = response.body;

    if (response.statusCode == 200 && userAwaitingEventsResponseBody != '[]') {
      _userdata.write('userAwaitingEventsResponseBody', userAwaitingEventsResponseBody);

      var userAwaitingEvents = eventFromJson(userAwaitingEventsResponseBody);
      var userAwaitingEventsCount = userAwaitingEvents.length;

      _userdata.write('userAwaitingEventsCount', userAwaitingEventsCount);

      notifyListeners();
    } else {
      _userdata.write('userAwaitingEventsCount', 0);
      _userdata.write('userAwaitingEventsResponseBody', '');
    }

    notifyListeners();
  }

  void apiGetUserConfirmedEvents(int? userId) async {
    print("userId: $userId");
    var response = await Backend.getConfirmedEventsByUser(userId);

    String userConfirmedEventsResponseBody = response.body;

    if (response.statusCode == 200 && userConfirmedEventsResponseBody != '[]') {
      _userdata.write('userConfirmedEventsResponseBody', userConfirmedEventsResponseBody);

      var userConfirmedEvents = eventFromJson(userConfirmedEventsResponseBody);
      var userConfirmedEventsCount = userConfirmedEvents.length;

      _userdata.write('userConfirmedEventsCount', userConfirmedEventsCount);

      notifyListeners();
    } else {
      _userdata.write('userConfirmedEventsCount', 0);
      _userdata.write('userConfirmedEventsResponseBody', '');
    }

    notifyListeners();
  }

  void apiGetAllPubs() async {
    var response = await Backend.getAllPubs();

    String allPubsResponseBody = response.body;

    if (response.statusCode == 200 && allPubsResponseBody != '[]') {
      _userdata.write('allPubsResponseBody', allPubsResponseBody);

      var allPubs = pubFromJson(allPubsResponseBody);
      var allPubsCount = allPubs.length;

      _userdata.write('allPubsCount', allPubsCount);

      notifyListeners();
    } else {
      _userdata.write('allPubsCount', 0);
    }

    notifyListeners();
  }

  void apiGetAllBands() async {
    var response = await Backend.getAllBands();

    String allBandsResponseBody = response.body;

    if (response.statusCode == 200 && allBandsResponseBody != '[]') {
      _userdata.write('allBandsResponseBody', allBandsResponseBody);

      var allBands = bandFromJson(allBandsResponseBody);
      var allBandsCount = allBands.length;

      _userdata.write('allBandsCount', allBandsCount);

      notifyListeners();
    } else {
      _userdata.write('allBandsCount', 0);
    }

    notifyListeners();
  }

  void apiDeleteUserEvent(int? showId) async {
    print("showId: $showId");

    var response = await Backend.deleteShow(showId);

    String responseBody = response.body;
    int responseCode = response.statusCode;

    print("responseBody: $responseBody");
    print("responseCode: $responseCode");

    notifyListeners();
  }

  void apiConfirmEvent(int? showId) async {
    print("showId to confirm: $showId");

    var userPendingEvents = _userdata.read('userPendingEvents');
    print('apiConfirmEvent userPendingEvents = $userPendingEvents');

    if (userPendingEvents.any((item) => item.id == showId)) {
      var response = await Backend.confirmShow(showId);

      String responseBody = response.body;
      int responseCode = response.statusCode;

      print("responseBody: $responseBody");
      print("responseCode: $responseCode");
      _userdata.write('eventWasConfirmed', true);
    } else {
      _userdata.write('eventWasConfirmed', false);
    }

    notifyListeners();
  }
}
