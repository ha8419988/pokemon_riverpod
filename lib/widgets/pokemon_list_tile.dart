import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/model/pokemon.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'pokemon_stats_card.dart';

class PokemonListTile extends ConsumerWidget {
  PokemonListTile({super.key, required this.pokemonUrl});
  final String pokemonUrl;
  late FavoritePokemonsProvider _favoritePokemonsProvider;
  late List<String> favorites;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonsProvider = ref.watch(
      favoritePokemonsProvider.notifier,
    );
    favorites = ref.watch(favoritePokemonsProvider);
    final pokemon = ref.watch(pokemonDataProvider(
      pokemonUrl,
    ));
    return pokemon.when(data: (data) {
      return _tile(
        context,
        false,
        data,
      );
    }, loading: () {
      return _tile(
        context,
        true,
        null,
      );
    }, error: (Object error, StackTrace stackTrace) {
      return Text(
        'error $error',
      );
    });
  }

  Widget _tile(
    BuildContext context,
    bool isLoading,
    Pokemon? pokemon,
  ) {
    return Skeletonizer(
      enabled: isLoading,
      child: InkWell(
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
        child: ListTile(
          trailing: IconButton(
            onPressed: () {
              if (favorites.contains(pokemonUrl)) {
                _favoritePokemonsProvider.removeFavorite(
                  pokemonUrl,
                );
              } else {
                _favoritePokemonsProvider.addFavorite(
                  pokemonUrl,
                );
              }
            },
            icon: favorites.contains(pokemonUrl)
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border),
            color: Colors.red,
          ),
          leading: pokemon != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    pokemon.sprites!.frontDefault!,
                  ),
                )
              : const CircleAvatar(),
          subtitle: Text(
            'Has ${pokemon?.moves?.length} moves',
          ),
          title: Text(
            pokemon != null
                ? pokemon.name!.toUpperCase()
                : 'Currently loading name for Pokemon',
          ),
        ),
      ),
    );
  }
}
