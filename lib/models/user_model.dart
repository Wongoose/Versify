class MyUser {
  final String userUID;
  final Map socialLinks;
  final bool completeLogin;
  List<dynamic> myPublicDocIds = [];

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

  bool isPrivateAccount;
  bool isDisableSharing;
  bool isHideContentInteraction;

  MyUser({
    this.myPublicDocIds,
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
    this.isPrivateAccount,
    this.isDisableSharing,
    this.isHideContentInteraction,
  });
}
