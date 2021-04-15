class Company {
  final String uid;
  final String displayName;
  final String siteURL;
  final String photoURL;
  final String category;
  final List<String> keyName;
  final List<String> keySite;
  final List<String> keyTranslit;


  Company({
    this.uid,
    this.displayName,
    this.photoURL,
    this.category,
    this.siteURL,
    this.keyName,
    this.keySite,
    this.keyTranslit,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "displayName": displayName,
      "photoURL": photoURL,
      "category": category,
      "siteURL": siteURL,
      "phone": null,
      "address": null,
      "email": null,
      "rating": {
        "totalRating": null,
        "numOfReviews": null,
      },
      "validUntil": null,
      "lastUpdate": null,
      "keyName": keyName,
      "keySite": keySite,
      "keyTranslit": keyTranslit,
    };
  }
}
