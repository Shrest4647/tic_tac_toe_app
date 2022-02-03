import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_app/tiles_controller.dart';

class SettingDialog extends StatelessWidget {
  const SettingDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Game Mode',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '        AI',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Consumer<TilesProvider>(
                        builder: (context, tilesProvider, child) => Switch(
                            value: tilesProvider.gameModeIsTwoPlayers,
                            onChanged: (bool value) {
                              if (!tilesProvider.tiles.contains(0) &&
                                  !tilesProvider.tiles.contains(1)) {
                                tilesProvider.setGameModeTwoPlayers(value);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Game in Progress'),
                                  ),
                                );
                              }
                            }),
                      ),
                      const Text(
                        '2 Player',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'First Move',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Consumer<TilesProvider>(
                    builder: (context, provider, child) {
                      bool isTwoPlayerMode = provider.gameModeIsTwoPlayers;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isTwoPlayerMode ? 'Player 1' : '    AI',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Switch(
                              value: provider.playerFirst,
                              onChanged: (bool playerFirst) {
                                if (!provider.tiles.contains(0) &&
                                  !provider.tiles.contains(1)) {
                                provider.setPlayerFirst(playerFirst);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Game in Progress'),
                                  ),
                                );
                              }
                              }),
                          const Text(
                            'Player',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
