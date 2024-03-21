import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:occupational_health/services/Auth/auth_service.dart';

class LocationService {
  final Geolocator geolocator = Geolocator();

  // Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Position> getCurrentLocation() async {
    try {
      Position p = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.lowest, forceAndroidLocationManager: true, timeLimit: const Duration(seconds: 10));
      return p;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> setLoggedInPosition() async {
    try {
      Position p = await getCurrentLocation();
      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'location': GeoPoint(p.latitude, p.longitude),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(e);
    }
  }


  // Handle permissions
  Future<bool> checkPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
        if (permission == LocationPermission.deniedForever) {
          return false;
        }
      }

      return true;
    } catch (e) {
      throw Exception(e);
    }
  }
}
