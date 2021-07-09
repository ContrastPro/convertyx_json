class Review {
  String uid;
  String uidOwner;
  String displayName;
  String message;
  double rating;

  Review({
    this.uid,
    this.uidOwner,
    this.displayName,
    this.message,
    this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'uidOwner': uidOwner,
      'uidLastUser': null,
      'displayName': displayName,
      'message': message,
      'rating': rating,
      'likes': [],
      'subRev': [],
    };
  }

  @override
  String toString() {
    return 'Review{uid: $uid, '
        'uidOwner: $uidOwner, '
        'displayName: $displayName, '
        'message: $message, '
        'rating: $rating}';
  }
}
