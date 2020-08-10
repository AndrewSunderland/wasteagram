import 'package:flutter_test/flutter_test.dart';
import 'package:wasteagram/models/food_waste_post.dart';

void main() {
  test('Post created from Map should have appropriate property values', () {
    final date = DateTime.parse('2020-01-01');
    const url = 'FAKE';
    const quantity = 1;
    const latitude = 1.0;
    const longitude = 2.0;

    final foodWastePost = FoodWastePost.fromMap({
      'date' : date,
      'imageURL' : url,
      'quantity' : quantity,
      'latitude' : latitude,
      'longitude' : longitude
    });

    expect(foodWastePost.date, date);
    expect(foodWastePost.imageURL, url);
    expect(foodWastePost.quantity, quantity);
    expect(foodWastePost.latitude, latitude);
    expect(foodWastePost.longitude, longitude);

  });

  test('Post with regular constructor should have appropriate values', () {
    final date = DateTime.parse('2020-01-01');
    const url = 'FAKE';
    const quantity = 1;
    const latitude = 1.0;
    const longitude = 2.0;

    final foodWastePost = FoodWastePost(
      date: date,
      imageURL: url,
      quantity: quantity,
      latitude: latitude,
      longitude: longitude
      );

    expect(foodWastePost.date, date);
    expect(foodWastePost.imageURL, url);
    expect(foodWastePost.quantity, quantity);
    expect(foodWastePost.latitude, latitude);
    expect(foodWastePost.longitude, longitude);

  });
}