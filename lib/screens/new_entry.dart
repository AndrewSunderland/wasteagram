import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../widgets/waste_scaffold.dart';
import '../widgets/waste_entry_form.dart';

class NewEntry extends StatelessWidget {
  
  static const routeName = 'newEntry';

  final String imagePath;
  final LocationData locationData;
  NewEntry({this.imagePath, this.locationData});

  @override
  Widget build(BuildContext context) {

    return WasteScaffold(
      title: 'New Journal Entry',
      child: WasteEntryForm(imagePath: imagePath),
      backButton: Semantics(
        child: BackButton(),
        button: true,
        enabled: true,
        onTapHint: 'Go back to previous screen',
        ),
    );
  }
}

