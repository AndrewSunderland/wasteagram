import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import '../widgets/waste_scaffold.dart';
import '../models/food_waste_post.dart';

class WasteListPostScreen extends StatefulWidget {

  static const routeName = 'wastePost';
  final FoodWastePost current;
  WasteListPostScreen({this.current});

  @override
  _WasteListPostScreenState createState() => _WasteListPostScreenState();
}

class _WasteListPostScreenState extends State<WasteListPostScreen> {

  @override
  Widget build(BuildContext context) {

    FoodWastePost current;
    if (this.widget.current == null) {
      current = ModalRoute.of(context).settings.arguments;
    } else {
      current = this.widget.current;
    }

    return WasteScaffold(
      title: 'Wasteagram',
      child: wastePostContents(context, current),
      backButton: Semantics(
        child: BackButton(),
        button: true,
        enabled: true,
        onTapHint: 'Go back to previous screen'
        ),
    );
  }

  Widget wastePostContents(BuildContext context, FoodWastePost current) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text('${DateFormat.yMMMEd().format(current.date)}', 
              style: Theme.of(context).textTheme.headline4),
          ),
          Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
          FadeInImage.memoryNetwork(
            placeholder: kTransparentImage, 
            image: current.imageURL),
          Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
          Text('${current.quantity.toString()} items',
              style: Theme.of(context).textTheme.headline4),
          Flexible(child: FractionallySizedBox(heightFactor: 0.1)),
          Align(
              alignment: Alignment.bottomCenter,
              child: Text('Location: (${current.latitude.toString()}, ${current.longitude.toString()})',
                style: Theme.of(context).textTheme.subtitle1),
            ),
        ],
      ),
    );
  }
}