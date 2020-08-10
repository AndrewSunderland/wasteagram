import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/food_waste_post.dart';

class WasteEntryForm extends StatefulWidget {
  
  final String imagePath;
  WasteEntryForm({this.imagePath});

  @override
  _WasteEntryFormState createState() => _WasteEntryFormState();
}

class _WasteEntryFormState extends State<WasteEntryForm> {

  final formKey = GlobalKey<FormState>();
  final wastePost = FoodWastePost();
  File image;
  
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData locationData;

  @override
    void initState() {
      super.initState();
      retrieveLocation();
    }

  void retrieveLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
  }


  @override
  Widget build(BuildContext context) {

    if (widget.imagePath == null) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Form(
        key: formKey,
        child: SizedBox.expand(
          child: Container(
                child: Column(
                  children: [
                    SizedBox(child: loadImage()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Semantics(
                        child: TextFormField(
                          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Number of Wasted Items', border: UnderlineInputBorder()),
                          onSaved: (value) {
                            wastePost.quantity = int.parse(value);
                          },
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'Please enter the number of items';
                            } else {
                              return null;
                            }
                          },
                        ),
                      focusable: true,
                      textField: true,
                      onTapHint: 'Can enter number of wasted items',
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Semantics(
                          child: saveButton(context),
                          button: true,
                          enabled: true,
                          onTapHint: 'Upload post to database',
                          )
                        ),
                    )
                  ],
                ),
            ),
          ),
        
    );
    }

  }

  Widget loadImage() {
    image = new File(widget.imagePath);
    if (widget.imagePath == null) {
      return CircularProgressIndicator();
    } else {
      return Image.file(image);
    }
  }

  Widget saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 100.0,
      child: new RaisedButton(
        child: Icon(Icons.cloud_upload, size: 70.0),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            saveData();
            Navigator.pop(context);
          }
        },
      )
    );
  }

  void saveData() async {
    wastePost.date = DateTime.now();
    wastePost.latitude = locationData.latitude;
    wastePost.longitude = locationData.longitude;
    wastePost.imageURL = await saveImage();
    Firestore.instance.collection('posts').add({
      'date' : wastePost.date.toString(),
      'imageURL' : wastePost.imageURL,
      'latitude' : wastePost.latitude,
      'longitude' : wastePost.longitude,
      'quantity' : wastePost.quantity
    });

  }
  // How to get the image to Firebase Storage and get URL.
  Future<String> saveImage() async {
    StorageReference storageReference = 
      FirebaseStorage.instance.ref().child('IMG${DateTime.now().toIso8601String()}.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    final url = await storageReference.getDownloadURL();
    return url;
  }
}