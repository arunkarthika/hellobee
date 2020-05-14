import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class BliveConfig {
  static final BliveConfig instance = BliveConfig._internal();
  var name;
  var profilePic;
  var gold;
  var level;
  var username;
  var broadcasterProfileName;
  var broadcastUsername;
  var broadprofilePic;
  var diamond;
  var broadcasterId;
  var userId;
  var entranceEffect;
  var userType;

  BliveConfig._internal() {
    SharedPreferences.getInstance().then((config) {
      this.name = config.getString('profileName');
      this.profilePic = config.getString('profile_pic');
      this.level = config.getString('level');
      this.username = config.getString('username');
      this.diamond = int.tryParse(config.getString("diamond"));
      this.gold = config.getString('over_all_gold');
      this.broadcasterId = config.getString('broadcasterId');
      this.broadcasterProfileName = config.getString('broadcasterProfileName');
      this.broadprofilePic = config.getString('broadprofilePic');
      this.broadcastUsername = config.getString('broadcastUsername');
      this.userId = config.getString('user_id');
      this.entranceEffect = config.getString('entranceEffect');
      this.userType = config.getString("userType");
    });
  }

  Future<void> saveConfig() async {
    SharedPreferences config = await SharedPreferences.getInstance();
    config.setString('profileName', this.name);
    config.setString('profile_pic', this.profilePic);
    config.setString('level', this.level);
    config.setString('username', this.username);
    config.setString("diamond", this.diamond.toString());
    config.setString('over_all_gold', this.gold);
    config.setString('broadcasterId', this.broadcasterId);
    config.setString("broadcasterProfileName", this.broadcasterProfileName);
    config.setString('broadprofilePic', this.broadprofilePic);
    config.setString('broadcastUsername', this.broadcastUsername);
    config.setString('user_id', this.userId);
    config.setString('entranceEffect', this.entranceEffect);
    config.setString("userType", this.userType);
  }
}
