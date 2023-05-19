import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_memory_game/constants/app_colors.dart';
import 'package:flutter_memory_game/utils/sound_manager.dart';

import '../models/cards_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  late SoundManager soundManager;
  List<CardData> cards = [];
  int correctCards = 4;
  int maxCards = 40;
  int maxLives = 3;
  int lives = 3;
  List<int> locations = [];
  bool isGameStarted = false;

  @override
  void initState() {
    super.initState();
    soundManager = SoundManager();
    resetGame();
  }

  @override
  void dispose() {
    soundManager.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.linkWater,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          lives > 0 ? 'Lives: $lives' : 'Game Over',
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.deepPurple.shade800, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: buildCardGrid(),
    );
  }

  void onCardTapped(int cardNumber) {
    bool isCorrectCardTapped = false;
    int tappedCardIndex = -1;

    if (cards.isNotEmpty) {
      int smallestIndex = cards
          .where((card) => card.isVisible)
          .map((card) => card.number)
          .reduce((minValue, value) => minValue < value ? minValue : value);

      if (cardNumber == smallestIndex) {
        isCorrectCardTapped = true;
        tappedCardIndex = cards.indexWhere(
            (card) => card.isVisible && card.number == smallestIndex);
      }
    }

    if (isCorrectCardTapped) {
      soundManager.playCorrectSound();
      isGameStarted = true;
      cards.removeAt(tappedCardIndex);
      int correctCardCount = correctCards - cards.length;
      if (correctCardCount == correctCards) {
        correctCards++;
        goNextStage();
      }
    } else {
      soundManager.playWrongSound();
      lives--;
      if (lives <= 0) {
        showGameOverPopup();
      } else {
        resetCurrentStage();
      }
    }

    setState(() {});
  }

  void resetVisibleState() {
    for (int i = 0; i < cards.length; i++) {
      cards[i].isVisible = true;
    }
  }

  void resetCurrentStage() {
    isGameStarted = false;
    cards = generateCards();
    resetVisibleState();
  }

  void goNextStage() {
    isGameStarted = false;
    cards = generateCards();
    resetVisibleState();
  }

  void showGameOverPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: const Text('You have lost the game.'),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade800),
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void resetGame() {
    isGameStarted = false;
    correctCards = 4;

    lives = maxLives;
    cards = generateCards();
    setState(() {
      resetVisibleState();
    });
  }

  List<CardData> generateCards() {
    List<CardData> cards = [];
    int cardCount = correctCards;
    locations = generateRandomCardLocations(8 * 5, cardCount);

    for (int i = 0; i < cardCount; i++) {
      int location = locations[i];
      CardData card =
          CardData(number: i + 1, location: location, isVisible: true);
      cards.add(card);
    }

    return cards;
  }

  List<int> generateRandomCardLocations(int gridSize, int cardCount) {
    List<int> cardLocations = [];
    Set<int> usedLocations = {};

    while (cardLocations.length < cardCount) {
      int randomLocation = Random().nextInt(gridSize);
      if (!usedLocations.contains(randomLocation)) {
        cardLocations.add(randomLocation);
        usedLocations.add(randomLocation);
      }
    }

    return cardLocations;
  }

  Widget buildCardGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8 * 5,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        CardData card = cards.firstWhere(
          (card) => card.location == index,
          orElse: () => CardData(number: 0, location: -1, isVisible: false),
        );

        return buildCardView(card, context);
      },
    );
  }

  Widget buildCardView(CardData card, BuildContext context) {
    return AnimatedOpacity(
      opacity: card.isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeIn,
      child: InkWell(
        onTap: () => card.isVisible ? onCardTapped(card.number) : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              isGameStarted ? '' : isZero(card.number),
              style: Theme.of(context).textTheme.headline6?.copyWith(
                    color: Colors.deepPurple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  String isZero(int number) {
    return number == 0 ? '' : number.toString();
  }
}
