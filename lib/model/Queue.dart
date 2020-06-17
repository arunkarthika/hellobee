class Giftqueue {
  String giftName;

  Giftqueue(this.giftName);
}

class NormalGiftqueue {
  String name;
  String giftName;
  String image;
  String compo;

  NormalGiftqueue(this.name, this.giftName, this.image, this.compo);
}

class Bulletqueue {
  String name;
  String message;
  String image;

  Bulletqueue(this.name, this.message, this.image);
}

class Arrivedqueue {
  String name;
  String image;

  Arrivedqueue(this.name, this.image);
}

class InviteRequest {
  String name;
  String image;
  String level;
  String userId;
  String username;
  InviteRequest(this.name, this.image, this.level, this.userId, this.username);
}

class GuestData {
  String userId;
  String name;
  String username;
  String image;
  String level;
  int points;
  GuestData(this.userId, this.name, this.username, this.image, this.level,this.points);

  GuestData.fromJson(Map json)
      : userId=json["userId"],
        name=json["name"],
        username=json["username"],
        image=json["image"],
        level=json["level"],
        points=json["points"];


  Map<String,dynamic> toJson(){
    return {
      "userId": this.userId,
      "name": this.name,
      "username": this.username,
      "image": this.image,
      "level":this.level,
      "points":this.points
    };
  }
}
