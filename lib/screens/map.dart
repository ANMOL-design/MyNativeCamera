import 'package:flutter/material.dart';
import 'package:image_location_picker/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitiude: 37.422,
      longitude: -122.084,
      address: '',
    ),
    this.isSelected = true,
  });

  final PlaceLocation location;
  final bool isSelected;

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelected ? 'Pick your location' : 'Your Location'),
        actions: [
          if (widget.isSelected)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(
                  const PlaceLocation(
                    latitiude: 38.492,
                    longitude: -128.064,
                    address: "299 Bedford Avenue, California 12431, USA",
                  ),
                );
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      // Must be include GooleMap() Package
      // body: GooleMap(),
      body: Image.network(
        'https://www.google.com/maps/d/thumbnail?mid=1xBGkX5K7_o1tYGP3mDAhtuCx8hQ&hl=en_US',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
