import 'package:versify/models/feed_model.dart';
import 'package:flutter/material.dart';

class ReviewPostOptions extends StatefulWidget {
  final Feed reviewFeed;

  ReviewPostOptions({this.reviewFeed});

  @override
  _ReviewPostOptionsState createState() => _ReviewPostOptionsState();
}

class _ReviewPostOptionsState extends State<ReviewPostOptions> {
  bool _publicValue = true;
  bool _allowShare = true;
  bool _allowInteractions = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white.withOpacity(0.3),
        child: Container(
          alignment: Alignment.topLeft,
          height: MediaQuery.of(context).size.height * 0.48,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, -0.5),
                blurRadius: 5,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(30, 20, 0, 10),
                child: Text(
                  'Post options',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Divider(thickness: 0.5, color: Colors.black54),

              // SizedBox(height: 30),

              Padding(
                padding: EdgeInsets.fromLTRB(30, 25, 30, 0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '#Tags',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.help_outline_rounded,
                                size: 14,
                                color: Colors.black54,
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xffff548e),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(width: 15),
                            ],
                          ),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: widget.reviewFeed.tags
                                    .map(
                                      (individualTag) => Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: FittedBox(
                                          alignment: Alignment.center,
                                          child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(6, 3, 6, 3),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              border: Border.fromBorderSide(
                                                  BorderSide(
                                                      color: Color(0xffff548e)
                                                          .withOpacity(0.9))),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              // color: _colorScheme[_colorIndex]['secondary']
                                              //     .withOpacity(0.3),
                                            ),
                                            child: Text(
                                              individualTag
                                                      .toString()
                                                      .contains('#')
                                                  ? individualTag
                                                      .toString()
                                                      .replaceRange(
                                                          individualTag
                                                                  .toString()
                                                                  .length -
                                                              2,
                                                          individualTag
                                                              .toString()
                                                              .length,
                                                          '')
                                                  : '#${individualTag.toString().replaceRange(individualTag.toString().length - 2, individualTag.toString().length, '')}',
                                              style: TextStyle(
                                                  fontFamily: 'Nunito',
                                                  fontSize: 11,
                                                  // color: Colors.white,
                                                  color: Color(0xffff548e)
                                                      .withOpacity(0.9)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(thickness: 0.5),
                      SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _publicValue ? 'Public' : 'Only I can see',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.help_outline_rounded,
                            size: 14,
                            color: Colors.black54,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Switch(
                            value: _publicValue,
                            onChanged: (bool value) {
                              setState(() => _publicValue = value);
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(thickness: 0.5),
                      SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Allow reshare',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.help_outline_rounded,
                            size: 14,
                            color: Colors.black54,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Switch(
                            value: _allowShare,
                            onChanged: (bool value) {
                              setState(() => _allowShare = value);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(thickness: 0.5),
                      SizedBox(height: 5),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Allow interactions',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.help_outline_rounded,
                            size: 14,
                            color: Colors.black54,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Switch(
                            value: _allowInteractions,
                            onChanged: (bool value) {
                              setState(() => _allowInteractions = value);
                            },
                          ),
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }
}
