import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_location_picker/models/place.dart';
// Get sqlite package to store the data
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

// Get package Get Image Path and Save it
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;

Future<Database> _getDatebase() async {
  // Making the request to save data on device
  final dbPath = await sql.getDatabasesPath();
  // NOTE: The path below is import from library
  // The below command opens the dbPath is exist or else created if not
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );

  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatebase();
    // Make a db query and fetch the data
    final data = await db.query('user_places ');

    final places = data
        .map(
          (item) => Place(
            id: item['id'] as String,
            title: item['title'] as String,
            image: File(item['image'] as String),
            location: PlaceLocation(
                latitiude: item['lat'] as double,
                longitude: item['lng'] as double,
                address: item['address'] as String),
          ),
        )
        .toList();

    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    // Saving the Images & other data to a Location using Path Provider Package
    // Get the Directory Location
    final appDir = await syspaths.getApplicationDocumentsDirectory();

    // Get the file path
    final filename = path.basename(image.path);

    // print('${appDir.path}/$filename');

    final copiedImage = await image
        .copy('${appDir.path}/$filename'); // File method to save image

    final newPlace = Place(
      title: title,
      image: copiedImage,
      location: location,
    );

    final db = await _getDatebase();

    // Inserting the data to db
    db.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitiude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address,
    });

    state = [newPlace, ...state];
  }
}

final userPlaceProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
