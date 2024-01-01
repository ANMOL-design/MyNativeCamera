import 'package:flutter/material.dart';
import 'package:image_location_picker/models/place.dart';
import 'package:image_location_picker/screens/map.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({super.key, required this.place});

  final Place place;

  // Making a Funciton to show the Location on Map Using Google Static API
  String get locationImage {
    // final lat = place.location.latitiude;
    // final lng = place.location.longitude;

    // Map API
    return 'https://www.google.com/maps/d/thumbnail?mid=1xBGkX5K7_o1tYGP3mDAhtuCx8hQ&hl=en_US';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => MapScreen(
                          location: place.location,
                          isSelected: false,
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(locationImage),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
