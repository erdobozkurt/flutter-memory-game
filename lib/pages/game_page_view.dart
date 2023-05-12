import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_memory_game/constants/app_colors.dart';

import '../models/cards_model.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  List<CardData> cards = [];
  int correctCards = 4;
  int maxCards = 40;
  int lives = 3;
  List<int> locations = [];

  @override
  void initState() {
    super.initState();
    cards = generateCards();
  }

  //TODO: Create a function to generate random locations for the cards.

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
              .titleLarge
              ?.copyWith(color: Colors.deepPurple.shade800),
        ),
        centerTitle: true,
      ),
      body: //A 5x8 gridview. and the cards are randomly generated in the gridview.
          buildCardGrid(),
    );
  }

  void onCardTapped(int index) {}

  List<CardData> generateCards() {
  List<CardData> cards = [];
  int cardCount = 4;
  locations = generateRandomCardLocations(5 * 8, cardCount);

  for (int i = 0; i < cardCount; i++) {
    int location = locations[i];
    CardData card = CardData(number: i + 1, location: location);
    cards.add(card);
  }
  print(cards.toString());
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
    } else {
      continue; // Aynı lokasyon tekrarlandığı için döngüyü devam ettir
    }
  }

  return cardLocations;
}



  Widget buildCardGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8, // Sütun sayısı
      ),
      itemCount: 5 * 8, // Grid hücre sayısı
      itemBuilder: (context, index) {
        CardData matchingCard = cards.firstWhere(
          (card) => card.location == index,
          orElse: () =>
              CardData(number: -1, location: -1), // Dummy kart oluştur
        );

        if (matchingCard.number != -1) {
          return buildCardView(matchingCard.number);
        } else {
          return buildEmptyContainer();
        }
      },
    );
  }

  Widget buildCardView(int cardNumber) {
    return Card(
      child: Center(
        child: Text(
          cardNumber.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget buildEmptyContainer() {
    return Container();
  }
}
