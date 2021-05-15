import 'package:flutter/material.dart';

class ViewPostQuote extends StatelessWidget {
  final String value;
  final String topic;

  ViewPostQuote({this.value, this.topic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 0, 26, 0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: Colors.deepPurpleAccent,
          ),
        ),
        color: Colors.deepPurpleAccent.withOpacity(0.07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 14,
                      fontFamily: 'Libre',
                      fontStyle: FontStyle.italic,
                      height: 1.35,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 0, 12),
                  height: 25,
                  child: FittedBox(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.deepPurpleAccent,
                      ),
                      child: Text(
                        topic ?? 'Quote',
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
              ],
            ),
          ),
          Icon(
            Icons.format_quote,
            color: Colors.deepPurpleAccent.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
