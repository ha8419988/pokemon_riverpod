import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_riverpod/model/pokemon.dart';
import 'package:pokemon_riverpod/services/database_service.dart';
import 'package:pokemon_riverpod/services/http_service.dart';

final pokemonDataProvider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService httpService = GetIt.instance.get<HttpService>();
  Response? res = await httpService.get(url);
  if (res != null && res.data != null) {
    return Pokemon.fromJson(res.data);
  }
  return null;
});

final favoritePokemonsProvider =
    StateNotifierProvider<FavoritePokemonsProvider, List<String>>((ref) {
  return FavoritePokemonsProvider(
    [],
  );
});

class FavoritePokemonsProvider extends StateNotifier<List<String>> {
  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();

  String favoritePokemonsListKey = 'FavoritePokemonsListKey';
  FavoritePokemonsProvider(
    super._state,
  ) {
    _setUp();
  }
  Future<void> _setUp() async {
    List<String>? result =
        await _databaseService.getList(favoritePokemonsListKey);
    state = result ?? [];
  }

  void addFavorite(String url) {
    state = [
      ...state,
      url,
    ];
    _databaseService.saveList(
      favoritePokemonsListKey,
      state,
    );
  }

  void removeFavorite(String url) {
    state = state.where((e) => e != url).toList();
    _databaseService.saveList(
      favoritePokemonsListKey,
      state,
    );
  }
}
