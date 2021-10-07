import 'package:versify/providers/providers_feeds/view_post_gift_provider.dart';
import 'package:versify/screens/blogs_feed/widget_view_post/gift_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

// enum GiftType { love, bird }

class ViewGiftWidget extends StatelessWidget {
  final String image;
  final Color color;
  final String text;
  final GiftType giftType;

  const ViewGiftWidget({this.image, this.color, this.text, this.giftType});

  @override
  Widget build(BuildContext context) {
    final GiftProvider _giftProvider =
        Provider.of<GiftProvider>(context, listen: true);

    return GestureDetector(
      onTap: () {
        // switch (giftType) {
        //   case GiftType.love:
        //     _giftProvider.incrementLove();
        //     break;
        //   case GiftType.bird:
        //     _giftProvider.incrementBird();
        //     break;
        // }
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 120,
          child: AspectRatio(
            aspectRatio: 1 / 1.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                overflow: Overflow.clip,
                clipBehavior: Clip.antiAlias,
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: -90,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 15),
                      Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: color),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 1,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              height: 32,
                              width: 32,
                              image: AssetImage(image),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        child: Text(
                          text,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 2),
                          Text(
                            giftType == GiftType.love
                                ? _giftProvider.initialGiftLove.toString()
                                : _giftProvider.initialGiftBird.toString(),
                            // (['12', '129', '56', '83', '11']..shuffle()).first,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            FontAwesomeIcons.gift,
                            size: 10,
                            color: color,
                          )
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
