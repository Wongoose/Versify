class Feed {
  final String documentID;
  final String userID;
  final String username;
  final String profileImageUrl;
  // final String content;
  final int contentLength;
  final String title;
  final List tags;
  final DateTime postedTimestamp;
  final List listMapContent;
  final int numberOfViews;
  final String content;
  final String featuredTopic;
  final String featuredValue;

  int giftLove;
  int giftBird;

  int numberOfLikes;

  bool initLike;
  bool isLiked;
  bool hasUpdatelike = false;

//not parsed
  bool hasViewed;
  bool isDisableSharing;
  bool isHideInteraction;

  Feed({
    this.hasViewed,
    this.profileImageUrl,
    this.giftLove,
    this.giftBird,
    this.featuredTopic,
    this.featuredValue,
    this.numberOfLikes,
    this.content,
    this.numberOfViews,
    this.documentID,
    this.userID,
    this.username,
    // this.content,
    this.contentLength,
    this.title,
    this.tags,
    this.postedTimestamp,
    this.initLike,
    this.listMapContent,
  });

  void updateLike(bool like) {
    if (like != isLiked && like) {
      numberOfLikes += 1;
    } else if (like == false) {
      numberOfLikes -= 1;
    }
    isLiked = like;
    if (isLiked != initLike) {
      hasUpdatelike = true;
    } else {
      hasUpdatelike = false;
    }
  }

  void swipeUpdatedToFB() {
    initLike = isLiked;
    hasUpdatelike = false;
  }
}
