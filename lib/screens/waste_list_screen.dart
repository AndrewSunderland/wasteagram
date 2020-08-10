import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:wasteagram/models/food_waste_post.dart';
import 'package:wasteagram/screens/waste_post_screen.dart';
import '../widgets/waste_scaffold.dart';
import 'new_entry.dart';


class WasteListScreen extends StatefulWidget {

  static const routeName = '/';

  @override
  _WasteListScreenState createState() => _WasteListScreenState();
}

class _WasteListScreenState extends State<WasteListScreen> {

  final _picker = ImagePicker();
  PickedFile imageFile;
  

  Future getImage() async {

    imageFile = await _picker.getImage(source: ImageSource.gallery);
    File image = File(imageFile.path);
    return image;
    
  }

  LocationData locationData;
  var locationService = Location();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return WasteScaffold(
      title: 'Wasteagram',
      fab: Semantics(
        child: newPostButton(context),
        button: true,
        enabled: true,
        onTapHint: 'Select an image',
        ),
      child: wasteList(context));
  }

  Widget wasteList(BuildContext context) {
    if (locationData == null) {
      return Center(child: CircularProgressIndicator());
    } else {
    return StreamBuilder(
          stream: Firestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
          builder: (content, snapshot) {
            if (snapshot.hasData && snapshot.data.documents != null && snapshot.data.documents.length > 0) {
              return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          var post = snapshot.data.documents[index];
                          return Semantics(
                            child: ListTile(
                              title: Text(DateFormat.yMMMMEEEEd().format(DateTime.parse(post['date']))),
                              trailing: Text(post['quantity'].toString()),
                              onTap: () {
                                displayWastePost(context, index, post);
                              },
                              ),
                            link: true,
                            onTapHint: 'Goes to post details screen',
                            enabled: true,
                          );
                          }
                      ),
                    ),
                
                  ]
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          });
    }
  }

  FloatingActionButton newPostButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.camera_alt),
      onPressed: () {
        Future future = getImage();
        future.then((value) => goToNewEntry(context, value));
      },
    );
  }

  void goToNewEntry(BuildContext context, File image) {
    Navigator.push(context, new MaterialPageRoute(
      builder: (context) => new NewEntry(imagePath: image.path, locationData: locationData)),
      ).then((value) {
        setState(() {});
        
      });
  }


  void displayWastePost(BuildContext context, int index, dynamic post) {
    FoodWastePost wastePost = new FoodWastePost(
      date: DateTime.parse(post['date']), 
      imageURL: post['imageURL'],
      latitude: post['latitude'],
      longitude: post['longitude'],
      quantity: post['quantity']
      );

    Navigator.of(context).pushNamed(
      WasteListPostScreen.routeName, arguments: wastePost);
  }
}

