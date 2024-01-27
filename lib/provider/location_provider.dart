import 'dart:async';

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier{
  late Future<LocationData> _location;

  Future<LocationData> getLocation() async {
    var location = Location();
    try {
      return await location.getLocation();
    } catch (e) {
      print('Error getting location: $e');
      throw e;
    }
  }

  getUserLocation() async {
    _location = getLocation();
    notifyListeners();
  }
}
