class FoodWastePost {
  DateTime date;
  String imageURL;
  double latitude;
  double longitude;
  int quantity;
  
  FoodWastePost({this.date, this.imageURL, this.latitude, this.longitude, this.quantity});

  factory FoodWastePost.fromMap(Map m) {
    return new FoodWastePost(
      date: m['date'],
      imageURL: m['imageURL'],
      latitude: m['latitude'],
      longitude: m['longitude'],
      quantity: m['quantity']
    );
  }

}