class CardData {
  int number;
  int location;
  bool isVisible;

  CardData({required this.number, required this.location, this.isVisible = true});

  @override
  String toString() {
    return 'CardData(number: $number, location: $location, isVisible: $isVisible)';
  }
}

