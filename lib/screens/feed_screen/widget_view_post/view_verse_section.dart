import 'package:flutter/material.dart';

class VerseInScroll extends StatelessWidget {
  const VerseInScroll({
    Key key,
    @required this.colorScheme,
    @required this.themeIndex,
  }) : super(key: key);

  final List<Map<String, Color>> colorScheme;
  final int themeIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 28,
                child: FittedBox(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: colorScheme[themeIndex]['secondary'],
                    ),
                    child: Text(
                      'John 3:16',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xfffffcfe),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Container(
                margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                padding: EdgeInsets.fromLTRB(8, 0, 26, 2),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        width: 2, color: colorScheme[themeIndex]['primary']),
                  ),
                ),
                child: Text(
                  '"For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life."',
                  overflow: TextOverflow.clip,
                  maxLines: 10,
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    height: 1.2,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    fontStyle: FontStyle.italic,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 2),
        //   child: ClipRRect(
        //     borderRadius: BorderRadius.circular(8.0),
        //     child: Image(
        //       height: 100,
        //       image: AssetImage('assets/images/philipians_4_13.png'),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
