class CardData {
  int number;
  int location;

  CardData({required this.number, required this.location});

  @override
  String toString() {
    return 'CardData{number: $number, location: $location}';
  }
}
