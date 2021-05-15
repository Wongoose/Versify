import 'package:cached_network_image/cached_network_image.dart';
import 'package:versify/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePic extends StatelessWidget {
  final Color primary;
  final Color secondary;
  final double size;
  final MyUser userProfile;

  ProfilePic(
      {Key key, this.primary, this.secondary, this.size, this.userProfile});

  @override
  Widget build(BuildContext context) {
    // if (userProfile.profileImageUrl != null) {
    //   CachedNetworkImage(
    //     cacheKey: userProfile.userUID,
    //     imageUrl:
    //         'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Flaugh.png?alt=media&token=dc9a65e8-d2a0-44bd-aa61-7156d20fc335',
    //     progressIndicatorBuilder: (context, url, downloadProgress) =>
    //         CircularProgressIndicator(value: downloadProgress.progress),
    //     errorWidget: (context, url, error) => Icon(Icons.error),
    //   );
    // }

    return userProfile.profileImageUrl == null
        ? SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator(
              strokeWidth: 0.5,
            ),
          )
        : Container(
            padding: EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  primary ?? Color(0xffff548e),
                  secondary ?? Color(0xffff548e)
                ],
                stops: [0, 0.6],
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              height: size == null ? 30 : 30 * size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: CachedNetworkImage(
                  height: size == null ? 30 : 30 * size,
                  fit: BoxFit.cover,
                  useOldImageOnUrlChange: false,
                  // cacheKey: userProfile.userUID,
                  imageUrl: userProfile.profileImageUrl,
                  progressIndicatorBuilder: (context, url, downloadProgress) {
                    return SizedBox(
                      height: 5,
                      width: 5,
                      child: CircularProgressIndicator(
                        strokeWidth: 0.5,
                        value: downloadProgress.progress,
                      ),
                    );
                  },
                  errorWidget: (context, url, error) =>
                      Icon(FontAwesomeIcons.userAltSlash, size: 10),
                ),

                // Image(
                //   height: size == null ? 30 : 30 * size,
                //   image: CachedNetworkImageProvider(
                //     'https://firebasestorage.googleapis.com/v0/b/goconnect-745e7.appspot.com/o/images%2Flaugh.png?alt=media&token=dc9a65e8-d2a0-44bd-aa61-7156d20fc335',
                //   ),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          );
  }
}
