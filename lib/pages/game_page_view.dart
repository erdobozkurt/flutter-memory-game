import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_memory_game/constants/app_colors.dart';

import '../models/cards_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<CardData> cards = [];
  int correctCards = 4;
  int maxCards = 40;
  int maxLives = 3;
  int lives = 3;
  List<int> locations = [];
  int nextCardNumber = 1;
  bool isCorrectCardTapped = false;

  @override
  void initState() {
    super.initState();
    resetGame();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.turquoise,
      appBar: AppBar(
        backgroundColor: AppColors.turquoise,
        elevation: 0,
        title: Text(
          'Memory Game',
          style: Theme.of(context)
              .textTheme
              .headline6
              ?.copyWith(color: Colors.deepPurple.shade800),
        ),
        centerTitle: true,
      ),
      body: buildCardGrid(),
    );
  }

  void onCardTapped(int cardNumber) {
  bool isCorrectCardTapped = false;
  int tappedCardIndex = -1;

  for (int i = 0; i < cards.length; i++) {
    if (cards[i].number == cardNumber && cards[i].isVisible) {
      isCorrectCardTapped = true;
      tappedCardIndex = i;
      break;
    }
  }

  if (isCorrectCardTapped) {
    cards[tappedCardIndex].isVisible = false;
    int correctCardCount = cards.where((card) => !card.isVisible).length;
    if (correctCardCount == cards.length) {
      correctCards++;
      resetGame();
    }
  } else {
    lives--;
    if (lives <= 0) {
      showGameOverPopup();
    } else {
      resetVisibleState();
    }
  }

  setState(() {});
}

void resetVisibleState() {
  for (int i = 0; i < cards.length; i++) {
    cards[i].isVisible = true;
  }
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
    nextCardNumber = 1;
    lives = maxLives;
    cards = generateCards();
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
        CardData card = cards.firstWhere((card) => card.location == index,
            orElse: () => CardData(number: 0, location: -1, isVisible: false));

        return GestureDetector(
          onTap: () => onCardTapped(card.number),
          child: Container(
            decoration: BoxDecoration(
              color: card.isVisible ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: card.isVisible ? Colors.transparent : Colors.white,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                card.isVisible ? '${card.number}' : '',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: card.isVisible
                          ? Colors.deepPurple.shade800
                          : Colors.white,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
