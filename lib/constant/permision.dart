import 'package:permission_handler/permission_handler.dart';

/// Example Flutter Application demonstrating the functionality of the
/// Permission Handler plugin.
class PermissionFun {
  Future storagePermision() async {
    print("status");
    var status = await Permission.storage.status;
    print(status);
    if (status.isGranted == false) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
      status = statuses[Permission.storage];
    }
    return status;
  }

  Future cameraPermision() async {
    var status = await Permission.camera.status;
    if (status.isGranted == false) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
      status = statuses[Permission.camera];
    }
    return status;
  }

  Future micPermision() async {
    var status = await Permission.microphone.status;
    if (status.isGranted == false) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
      ].request();
      status = statuses[Permission.microphone];
    }
    return status;
  }
}
