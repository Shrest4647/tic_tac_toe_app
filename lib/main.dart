import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_app/setting_dialog.dart';
import 'package:tic_tac_toe_app/settings_page.dart';
import 'package:tic_tac_toe_app/tiles_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TilesProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TilesProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Let's play!"),
          centerTitle: true,
          leading: const Icon(Icons.menu),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()));
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return const ColumnWidget(direction: Axis.horizontal);
          } else {
            return const ColumnWidget(
              direction: Axis.vertical,
            );
          }
        }),
      ),
    );
  }
}

class ColumnWidget extends StatelessWidget {
  final Axis direction;
  const ColumnWidget({Key? key, required this.direction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message =
        Provider.of<TilesProvider>(context, listen: false).gameModeIsTwoPlayers
            ? 'Two Players'
            : 'Vs AI';
    return ListView(
      // scrollDirection: direction,
      children: [
        ExpansionTile(
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: const [
            SettingDialog(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SizedBox(
              height: 400,
              width: 400,
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemBuilder: (context, index) {
                    List texts = ['O', 'X', ''];
                    return Consumer<TilesProvider>(
                      builder: (context, tilesProvider, child) => Tooltip(
                        message: texts[tilesProvider.currentPlayer],
                        child: InkWell(
                          hoverColor: tilesProvider.currentPlayer == 0
                              ? Colors.blue[200]
                              : Colors.green[200],
                          onTap: () async {
                            if (tilesProvider.winner == -1) {
                              if (tilesProvider.tiles[index] == -1) {
                                tilesProvider.setTile(index);

                                if (tilesProvider.gameMode ==
                                        GameMode.computer &&
                                    !tilesProvider.isDraw &&
                                    tilesProvider.winner == -1) {
                                  await Future(
                                      () => const Duration(seconds: 5));
                                  runAI(context);
                                }
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    child: SizedBox(
                                      height: 100.0,
                                      child: Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Text(
                                              'Invalid Move',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Done'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Card(
                            color: tilesProvider.tiles[index] == -1
                                ? Colors.white12
                                : tilesProvider.tiles[index] == 0
                                    ? Colors.blue
                                    : Colors.green,
                            child: FittedBox(
                              child: Text(
                                texts[tilesProvider.tiles[index] < 0
                                    ? 2
                                    : tilesProvider.tiles[index]],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            thickness: 5,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            spacing: 5,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black12,
                    width: 5.0,
                  ),
                ),
                child: Consumer<TilesProvider>(
                  builder: (context, tileProvider, _) => tileProvider.isDraw
                      ? const Text(
                          "It's a Draw",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : tileProvider.winner == -1
                          ? SelectableText(
                              tileProvider.gameMode == GameMode.computer
                                  ? (tileProvider.currentPlayer == 0
                                      ? 'Your Turn'
                                      : "AI's Turn")
                                  : 'Player ${tileProvider.currentPlayer + 1}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: tileProvider.currentPlayer == 0
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                            )
                          : Text(
                              tileProvider.gameMode == GameMode.computer
                                  ? (tileProvider.winner == 0
                                      ? 'Congrats! You Won.'
                                      : 'AI won! Try Again')
                                  : 'Player ${tileProvider.winner + 1} wins',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  TilesProvider tilesProvider =
                      Provider.of<TilesProvider>(context, listen: false);
                  tilesProvider.emptyTiles();
                  await Future.delayed(
                    const Duration(seconds: 1),
                  );

                  await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          children: [
                            const Text(
                              "Who will be starting first?",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Consumer<TilesProvider>(
                              builder: (context, provider, child) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      provider.setPlayerFirst(true);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Player'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      provider.setPlayerFirst(false);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('AI'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      }).then((value) async {
                    tilesProvider.emptyTiles();

                    if (!tilesProvider.playerFirst) {
                      await Future.delayed(
                        const Duration(seconds: 3),
                      );
                      if (tilesProvider.gameMode == GameMode.computer &&
                          !tilesProvider.isDraw &&
                          tilesProvider.winner == -1) {
                        runAI(context);
                      }
                    }
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Restart',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            thickness: 5,
          ),
        ),
      ],
    );
  }
}

runAI(BuildContext context) {
  final tileProvider = Provider.of<TilesProvider>(context, listen: false);
  List<int> tiles = tileProvider.tiles;
  int nextMove = findNextMove(tiles);

  tileProvider.setTile(nextMove);
}

int findNextMove(List<int> tiles) {
  int nextMove = -1;
  List<int> possibleMoves = [];
  for (int i = 0; i < 9; i++) {
    if (tiles[i] == -1) {
      possibleMoves.add(i);
      List<int> tempTiles = [...tiles];
      tempTiles[i] = 1;
      if (checkWinning(1, tempTiles)) {
        nextMove = i;
        break;
      }
      tempTiles[i] = 0;
      if (checkWinning(0, tempTiles)) {
        nextMove = i;
      }
    }
  }
  if (nextMove == -1) {
    nextMove = possibleMoves[Random().nextInt(possibleMoves.length)];
  }

  return nextMove;
}

bool checkWinning(int player, List<int> tiles) {
  return player == tiles[0] && player == tiles[1] && player == tiles[2] ||
      player == tiles[3] && player == tiles[4] && player == tiles[5] ||
      player == tiles[6] && player == tiles[7] && player == tiles[8] ||
      player == tiles[0] && player == tiles[3] && player == tiles[6] ||
      player == tiles[1] && player == tiles[4] && player == tiles[7] ||
      player == tiles[2] && player == tiles[5] && player == tiles[8] ||
      player == tiles[0] && player == tiles[4] && player == tiles[8] ||
      player == tiles[2] && player == tiles[4] && player == tiles[6];
}
