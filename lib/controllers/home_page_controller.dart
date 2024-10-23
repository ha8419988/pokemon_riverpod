import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemon_riverpod/model/home_page_data.dart';
import 'package:pokemon_riverpod/model/pokemon.dart';
import 'package:pokemon_riverpod/services/http_service.dart';

import '../model/home_page_data.dart';

class HomePageController extends StateNotifier<HomePageData> {
  final GetIt getIt = GetIt.instance;
  late HttpService _httpService;

  HomePageController(super._state) {
    _httpService = getIt<HttpService>();
    _setUp();
  }

  Future<void> _setUp() async {
    await loadData();
  }

  Future<void> loadData() async {
    if (state.data == null) {
      Response? res = await _httpService
          .get('https://pokeapi.co/api/v2/pokemon?limit=20&offset=0');
      if (res != null && res.data != null) {
        PokemonListData pokemonListData = PokemonListData.fromJson(res.data);
        state = HomePageData(data: pokemonListData);
        // state = state.copyWith(data: pokemonListData);
        print(state);
      }
    } else {
      if (state.data?.next != null) {
        Response? res = await _httpService.get(state.data!.next!);
        if (res != null && res.data != null) {
          PokemonListData pokemonListData = PokemonListData.fromJson(
            res.data,
          );
          state = HomePageData(
            data: pokemonListData.copyWith(
              results: [
                ...?state.data?.results,
                ...?pokemonListData.results,
              ],
            ),
          );
        }
      }
    }
  }
}
