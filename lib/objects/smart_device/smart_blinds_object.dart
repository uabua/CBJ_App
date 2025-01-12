import 'package:CyBearJinni/objects/enums.dart';
import 'package:CyBearJinni/objects/smart_device/smart_device_object.dart';
import 'package:connectivity/connectivity.dart';

import 'client/smart_client.dart';

class SmartBlindsObject extends SmartDeviceObject {
  SmartBlindsObject(DeviceType deviceType, String name, String ip)
      : super(deviceType, name, ip);

  Future<String> blindsUp() async {
    final ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi &&
        await getCurrentWifiName() == SmartDeviceObject.homeWifiName) {
      //  If current network is the network of the smart device set using the local method and not the remote
      print('Moving blinds up LAN');
      return SmartClient.setSmartBlindsUp(this);
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      print('Moving blinds up Remote');
      return setBlindStateRemote(WishEnum.SBlindsUp);
    } else {
      print('Not connected to a network');
    }

    return 'Error getting device state';
  }

  Future<String> blindsDown() async {
    final ConnectivityResult connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi &&
        await getCurrentWifiName() == SmartDeviceObject.homeWifiName) {
      //  If current network is the network of the smart device set using the local method and not the remote
      print('Moving blinds Down LAN');
      return SmartClient.setSmartBlindsDown(this);
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      print('Moving blinds down Remote');
      return setBlindStateRemote(WishEnum.SBlindsDown);
    } else {
      print('Not connected to a network');
    }

    return 'Error getting device state';
  }

  Future<String> blindsStop() async {
    final ConnectivityResult connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (connectivityResult == ConnectivityResult.wifi &&
        await getCurrentWifiName() ==
            SmartDeviceObject
                .homeWifiName) { //  If current network is the network of the smart device set using the local method and not the remote
      print('Stopping blinds LAN');
      return SmartClient.setSmartBlindsStop(this);
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      print('Stopping blinds Remote');
      return setBlindStateRemote(WishEnum.SBlindsStop);
    } else {
      print('Not connected to a network');
    }

    return 'Error getting device state';
  }


  Future<String> setBlindStateRemote(WishEnum wish) async {
    return (await fireStoreClass.changeBlindsState(roomName, name, wish))
        .toString();
  }
}
