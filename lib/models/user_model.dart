class MyUser {
  final String userUID;
  final Map socialLinks;
  final bool completeLogin;

  String profileImageUrl;
  String description;
  String username;
  String phoneNumber;
  String email;

  final int totalFollowers;
  final int totalFollowing;

  bool isFollowing;
  String usersPublicFollowID;
  DateTime lastUpdated;
  DateTime lastBlogsUpdated;

  MyUser({
    this.completeLogin,
    this.profileImageUrl,
    this.socialLinks,
    this.email,
    this.phoneNumber,
    this.totalFollowers,
    this.totalFollowing,
    this.userUID,
    this.description,
    this.username,
    this.isFollowing,
    this.usersPublicFollowID,
    this.lastUpdated,
    this.lastBlogsUpdated,
  });
}
