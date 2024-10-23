import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/controllers/home_page_controller.dart';
import 'package:pokemon_riverpod/model/home_page_data.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_provider.dart';
import 'package:pokemon_riverpod/widgets/pokemon_card.dart';
import 'package:pokemon_riverpod/widgets/pokemon_list_tile.dart';

final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData(data: null));
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomePageController _homePageController;
  late HomePageData _homePageData;
  late List<String> _favoritePokemons;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _homePageController.loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(
      homePageControllerProvider.notifier,
    );
    _homePageData = ref.watch(
      homePageControllerProvider,
    );
    _favoritePokemons = ref.watch(
      favoritePokemonsProvider,
    );
    return Scaffold(
        body: _buildUI(
      context,
    ));
  }

  Widget _buildUI(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _favoritePokemonLists(context),
            _allPokemonList(context),
          ],
        ),
      ),
    );
  }

  Widget _favoritePokemonLists(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorites',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                if (_favoritePokemons.isNotEmpty)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.48,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: _favoritePokemons.length,
                        itemBuilder: (context, index) {
                          return PokemonCard(
                              pokemonUrl: _favoritePokemons[index]);
                        }),
                  ),
                if (_favoritePokemons.isEmpty)
                  const Text('No favorite pokemons yet!')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allPokemonList(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ALL POKEMON LIST',
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: screenHeight * 0.6,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _homePageData.data?.results?.length,
                  itemBuilder: (context, index) {
                    return PokemonListTile(
                      pokemonUrl: _homePageData.data?.results?[index].url ?? '',
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
