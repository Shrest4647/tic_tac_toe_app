import 'package:flutter/cupertino.dart';

enum GameMode { computer, twoPlayers }

class TilesProvider with ChangeNotifier {
  List<int> _tiles = List.filled(9, -1);
  int _currentPlayer = 0;
  int _winner = -1;
  bool _isDraw = false;
  bool playerFirst = true;
  GameMode _gameMode = GameMode.twoPlayers;

  List<int> get tiles => _tiles;
  int get currentPlayer => _currentPlayer;
  int get winner => _winner;
  bool get isDraw => _isDraw;

  GameMode get gameMode => _gameMode;

  bool get gameModeIsTwoPlayers => _gameMode == GameMode.twoPlayers;

  setPlayerFirst(bool value) {
    playerFirst = value;
    notifyListeners();
  }

  setGameModeTwoPlayers(bool value) {
    if (value) {
      _gameMode = GameMode.twoPlayers;
    } else {
      _gameMode = GameMode.computer;
    }
    notifyListeners();
  }

  void emptyTiles() {
    _tiles = List.filled(9, -1);
    _currentPlayer = playerFirst? 0: 1;
    _winner = -1;
    _isDraw = false;
    notifyListeners();
  }

  int getTile(int index) {
    return _tiles[index];
  }

  void setTile(
    int index,
  ) {
    _tiles[index] = _currentPlayer;
    if (checkWinning(_currentPlayer)) {
      _winner = _currentPlayer;
    } else {
      if (winner == -1 && !tiles.contains(-1)) {
        _isDraw = true;
      }
    }
    _currentPlayer = 1 - _currentPlayer;
    notifyListeners();
  }

  bool checkWinning(int i) {
    return i == _tiles[0] && i == _tiles[1] && i == _tiles[2] ||
        i == _tiles[3] && i == _tiles[4] && i == _tiles[5] ||
        i == _tiles[6] && i == _tiles[7] && i == _tiles[8] ||
        i == _tiles[0] && i == _tiles[3] && i == _tiles[6] ||
        i == _tiles[1] && i == _tiles[4] && i == _tiles[7] ||
        i == _tiles[2] && i == _tiles[5] && i == _tiles[8] ||
        i == _tiles[0] && i == _tiles[4] && i == _tiles[8] ||
        i == _tiles[2] && i == _tiles[4] && i == _tiles[6];
  }
}
