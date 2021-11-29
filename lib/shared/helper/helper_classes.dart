import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:versify/models/user_model.dart';
import 'package:versify/shared/widgets/widgets_all_loading.dart';

// size provider widget
class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size) onChildSize;

  const SizeProviderWidget({Key key, this.onChildSize, this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onChildSize(context.size);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// profile picture widget
class ProfilePic extends StatelessWidget {
  final Color primary;
  final Color secondary;
  final double size;
  final MyUser userProfile;

  ProfilePic(
      {Key key, this.primary, this.secondary, this.size, this.userProfile});

  @override
  Widget build(BuildContext context) {
    if (userProfile.profileImageUrl == null) {
      return SizedBox(
        height: 15,
        width: 15,
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          strokeWidth: 0.5,
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              primary ?? Theme.of(context).primaryColor,
              secondary ?? Theme.of(context).primaryColor
            ],
            stops: const [0, 0.6],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
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
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                    strokeWidth: 0.5,
                    value: downloadProgress.progress,
                  ),
                );
              },
              errorWidget: (context, url, error) =>
                  Icon(FontAwesomeIcons.userAltSlash, size: 10),
            ),
          ),
        ),
      );
    }
  }
}

// Custom Routing
class CustomAppRoute extends StatefulWidget {
  final Widget targetWidget;

  const CustomAppRoute(this.targetWidget);

  @override
  _CustomAppRouteState createState() => _CustomAppRouteState();
}

class _CustomAppRouteState extends State<CustomAppRoute> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.targetWidget),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashLoading();
  }
}

class ReturnValue {
  final bool success;
  final String value;
  final String errorCode;

  // ignore: avoid_positional_boolean_parameters
  const ReturnValue(this.success, this.value, [this.errorCode]);
}
