class Gift {
  String id;
  String url;
  String type;
  String price;
  String name;
  String icon;
  String comboFlag;
  String comboPacks;
  String giftLocal;
  String giftIconLocal;
  String audioLocal;
  String audioURL;

  Gift(
    this.id,
    this.url,
    this.name,
    this.price,
    this.type,
    this.icon,
    this.comboFlag,
    this.comboPacks,
    this.giftLocal,
    this.giftIconLocal,
    this.audioLocal,
    this.audioURL,
  );

  Gift.map(dynamic obj) {
    this.id = obj["id"];
    this.url = obj["url"];
    this.name = obj["name"];
    this.type = obj["type"];
    this.price = obj["price"];
    this.icon = obj["icon"];
    this.comboFlag = obj["comboFlag"];
    this.comboPacks = obj["comboPacks"];
    this.giftLocal = obj["giftLocal"];
    this.giftIconLocal = obj["giftIconLocal"];
    this.audioLocal = obj["audioLocal"];
    this.audioURL = obj["audioURL"];
  }

  // String get firstName => _firstName;

  // String get lastName => _lastName;

  // String get dob => _dob;
  // String get mob => _mob;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["id"] = id;
    map["url"] = url;
    map["name"] = name;
    map["price"] = price;
    map["type"] = type;
    map["icon"] = icon;
    map["comboFlag"] = comboFlag;
    map["comboPacks"] = comboPacks;
    map["giftLocal"] = giftLocal;
    map["giftIconLocal"] = giftIconLocal;
    map["audioLocal"] = audioLocal;
    map["audioURL"] = audioURL;

    return map;
  }

  // void setUserId(int id) {
  //   this.id = id;
  // }
}
