import 'package:client_app/datamodels/driversnearby.dart';

class GeofireHelper {
  static List<DriversNearby> driversNearbyList = [];

  static void removeFromList(String key) {
    int index = driversNearbyList.indexWhere((element) => element.key == key);
    driversNearbyList.removeAt(index);
  }

  static void updateNearbyLocation(DriversNearby driver) {
    int index =
        driversNearbyList.indexWhere((element) => element.key == driver.key);
    driversNearbyList[index].longitude = driver.longitude;
    driversNearbyList[index].latitude = driver.latitude;
  }
}
