import 'package:versify/models/feed_model.dart';
import 'package:flutter/cupertino.dart';

class ViewPostLikeProvider extends ChangeNotifier {
  final Feed feed;
  bool _likedPost = false;
  bool _savedPost = false;

  ViewPostLikeProvider({this.feed});

  bool get isLiked => _likedPost;
  bool get isSaved => _savedPost;

  void initialLike() {
    _likedPost = feed.initLike ?? false;
    feed.isLiked = feed.initLike;
  }

  void likeTrigger() {
    _likedPost = !_likedPost;
    feed.updateLike(_likedPost);
    notifyListeners();
  }

  void doubleTap() {
    _likedPost = true;
    feed.updateLike(_likedPost);
    notifyListeners();
  }

//save ------------------------- (not used)

  void initialSave(bool initSave) {
    _savedPost = initSave;
  }

  void updateSave(bool save) {
    _savedPost = save;
    notifyListeners();
  }
}
