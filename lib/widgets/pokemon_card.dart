import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/model/pokemon.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'pokemon_stats_card.dart';

class PokemonCard extends ConsumerWidget {
  final String pokemonUrl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;
  PokemonCard({super.key, required this.pokemonUrl});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(
      favoritePokemonsProvider.notifier,
    );

    final pokemon = ref.watch(
      pokemonDataProvider(
        pokemonUrl,
      ),
    );

    return pokemon.when(
        data: (data) => _card(
              context,
              false,
              data,
            ),
        error: (e, stackTrace) => Text(
              'eror $e',
            ),
        loading: () => _card(
              context,
              true,
              null,
            ));
  }

  Widget _card(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      ignoreContainers: true,
      enabled: isLoading,
      child: InkWell(
        // overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        onTap: () {
          if (!isLoading) {
            showDialog(
                context: context,
                builder: (_) {
                  return PokemonStatsCard(
                    pokemonUrl: pokemonUrl,
                  );
                });
          }
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.width * 0.01,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.width * 0.01,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green[300]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? 'Pokemon',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '#${pokemon?.id.toString()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: CircleAvatar(
                radius: MediaQuery.of(context).size.height * 0.05,
                backgroundImage: pokemon != null
                    ? NetworkImage(pokemon.sprites!.frontDefault!)
                    : null,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${pokemon?.moves?.length} Moves',
                    style: const TextStyle(color: Colors.white),
                  ),
                  InkWell(
                    onTap: () {
                      _favoritePokemonsProvider.removeFavorite(
                        pokemonUrl,
                      );
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
