import 'package:versify/models/feed_model.dart';
import 'package:flutter/cupertino.dart';

class GiftProvider extends ChangeNotifier {
  int initialGiftLove;
  int initialGiftBird;

  GiftProvider({this.initialGiftBird, this.initialGiftLove});

  int giftLove = 0;
  int giftBird = 0;

  int totalGiftValue = 0;

  void updateTotal() {
    totalGiftValue = (giftLove * 10) + (giftBird * 100);
    notifyListeners();
  }

  void incrementLove() {
    giftLove++;
    updateTotal();
  }

  void incrementBird() {
    giftBird++;
    updateTotal();
  }

  void clearGifts() {
    giftLove = 0;
    giftBird = 0;
    updateTotal();
  }

  void confirmGifts(Feed feed) {
    initialGiftLove += giftLove;
    initialGiftBird += giftBird;

    feed.giftLove = initialGiftLove;
    feed.giftBird = initialGiftBird;
    notifyListeners();

    clearGifts();
  }
}
