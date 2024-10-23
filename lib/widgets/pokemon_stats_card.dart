import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_riverpod/providers/pokemon_data_provider.dart';

class PokemonStatsCard extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonStatsCard({super.key, required this.pokemonUrl});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(
      pokemonUrl,
    ));

    return AlertDialog(
      content: pokemon.when(
          data: (data) => Column(
                mainAxisSize: MainAxisSize.min,
                children: data?.stats?.map((s) {
                      return Text(
                        '${s.stat?.name?.toLowerCase()} :${s.baseStat}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList() ??
                    [],
              ),
          error: (error, stackTrace) => Text('error $error'),
          loading: () => const CircularProgressIndicator()),
    );
  }
}
