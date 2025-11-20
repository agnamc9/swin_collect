import 'package:location/location.dart';
import 'package:tax_collect/src/data/data.dart';

class LocationUtils {
  static Future<AppLocation?> getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return null;
    }
    return AppLocation(lat: locationData.latitude!, lng: locationData.longitude!);
  }
}
