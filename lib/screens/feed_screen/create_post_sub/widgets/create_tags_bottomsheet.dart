import 'package:versify/providers/create_topics_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateTagsBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 40, 30, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 250,
              child: RichText(
                maxLines: 2,
                text: TextSpan(children: [
                  TextSpan(
                    text: '#Edit Tags',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                        height: 1.1),
                  ),
                  //   TextSpan(
                  //     text: '',
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 35,
                  //         fontWeight: FontWeight.bold,
                  //         fontFamily: 'Nunito',
                  //         height: 1.1),
                  //   )
                ]),
              ),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.topLeft,
            child: Consumer<CreateTopicsProvider>(
              builder: (context, topicsProvider, _) {
                return Wrap(
                  spacing: 10,
                  alignment: WrapAlignment.start,
                  children: topicsProvider.chipSnaps
                      .map(
                        (chipData) => FilterChip(
                            selected: chipData.checked,
                            checkmarkColor: Colors.white,
                            selectedColor: Color(0xffff548e),
                            showCheckmark: true,
                            onSelected: ((onSelected) {
                              chipData.checked = onSelected;
                              topicsProvider.updateChips();
                            }),
                            shape: StadiumBorder(
                              side: BorderSide(
                                color: Color(0xffff548e),
                                width: 1.0,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            label: Text(chipData.topic),
                            labelStyle: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: chipData.checked
                                    ? Colors.white
                                    : Color(0xffff548e))),
                      )
                      .toList()
                      .cast<Widget>(),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  backgroundColor: Colors.white,
                ),
                onPressed: () => {},
                label: Text(
                  'help',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Nunito',
                  ),
                ),
                icon: Icon(
                  Icons.help_outline_rounded,
                  size: 14,
                  color: Colors.black54,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'save',
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
