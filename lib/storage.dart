import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<bool> isFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorites = prefs.getStringList('favorites');
    bool isFavorite = false;
    if (favorites != null) {
      for (var item in favorites) {
        if (item == id) {
          isFavorite = true;
        }
      }
    }

    return isFavorite;
  }

  setFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(id);
    prefs.remove('favorites');
    prefs.setStringList('favorites', favorites);
  }

  removeFavorite(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(id);
    prefs.remove('favorites');
    prefs.setStringList('favorites', favorites);
  }
}
