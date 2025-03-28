import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_react_button/animated_react_button.dart';
import 'package:banpay/api/repository/pokemons/model/pokemons.dart';

import '../provider/favorite_widget_provider.dart';

class FavoriteWidgetPage extends ConsumerWidget {
  final Pokemons pokemon;

  const FavoriteWidgetPage({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoriteWidgetProvider(pokemon));
    final controller = ref.read(favoriteWidgetProvider(pokemon).notifier);

    if (isFavorite == null) {
      return const SizedBox(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return SizedBox(
      width: 48,
      height: 48,
      child: AnimatedReactButton(
        defaultColor: isFavorite ? Colors.red : Colors.grey,
        defaultIcon: isFavorite ? Icons.favorite : Icons.favorite_border,
        reactColor:  isFavorite ? Colors.grey : Colors.red,
        onPressed: () async {
          await controller.toggleFavorite();
        },
      ),
    );
  }
}
