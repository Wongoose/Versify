import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BadgeWidget extends StatelessWidget {
  final String image;
  final Color color;
  final String text;
  // final int value;
  const BadgeWidget({this.image, this.color, this.text});

  @override
  Widget build(BuildContext context) {
    // final GiftProvider _giftProvider =
    //     Provider.of<GiftProvider>(context, listen: true);

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
      child: Container(
        height: 150,
        child: AspectRatio(
          aspectRatio: 1 / 1.3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                Image(
                  height: 60,
                  width: 60,
                  image: AssetImage(image),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     SizedBox(width: 2),
                //     Text(
                //       'Getting started',
                //       // (['12', '129', '56', '83', '11']..shuffle()).first,
                //       style: TextStyle(
                //         fontSize: 11,
                //         fontWeight: FontWeight.w600,
                //       ),
                //     ),
                //     SizedBox(width: 2),
                //     Icon(
                //       FontAwesomeIcons.gift,
                //       size: 10,
                //       color: color,
                //     )
                //   ],
                // ),
                SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
