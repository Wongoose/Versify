import 'package:versify/providers/create_post/create_topics_provider.dart';
import 'package:versify/screens/create_screen/widgets/create_tags_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum TagSelection { remove, cancel }

class MyTags extends StatefulWidget {
  @override
  _MyTagsState createState() => _MyTagsState();
}

class _MyTagsState extends State<MyTags> {
  @override
  Widget build(BuildContext context) {
    final CreateTopicsProvider _topicsProvider =
        Provider.of<CreateTopicsProvider>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(8, 10, 15, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {},
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  primary: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  backgroundColor: Colors.white,
                ),
                label: Text(
                  'My Tags',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600),
                ),
                icon: Icon(Icons.tag, color: Colors.black54),
              ),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      print('BottomSheet built');
                      return ChangeNotifierProvider<CreateTopicsProvider>.value(
                        value: _topicsProvider,
                        child: SingleChildScrollView(
                          child: CreateTagsBottomSheet(
                            ),
                        ),
                      );
                    },
                  );
                  // Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  primary: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  backgroundColor: Colors.white,
                ),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xffff548e),
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                icon: Icon(
                  Icons.edit,
                  color: Color(0xffff548e),
                  size: 14,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 0, 8, 0),
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: _topicsProvider.chipSnaps
                .map(
                  (chipObject) => PopupMenuButton<TagSelection>(
                    onSelected: (selection) {
                      if (selection == TagSelection.remove) {
                        chipObject.checked = false;
                        _topicsProvider.updateChips();
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem<TagSelection>(
                          value: TagSelection.remove,
                          height: 0,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Remove tag',
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuItem<TagSelection>(
                          value: TagSelection.cancel,
                          height: 0,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    child: Visibility(
                      visible: chipObject.checked,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: FittedBox(
                          alignment: Alignment.center,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.fromBorderSide(
                                  BorderSide(color: Color(0xffff548e))),
                              borderRadius: BorderRadius.circular(5),
                              // color: _colorScheme[_colorIndex]['secondary']
                              //     .withOpacity(0.3),
                            ),
                            child: Text(
                              chipObject.topic.toString().contains('#')
                                  ? chipObject.topic
                                  : '#${chipObject.topic.toString()}',
                              style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 11,
                                  // color: Colors.white,
                                  color: Color(0xffff548e)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList()
                .cast<Widget>(),
          ),
        ),
      ],
    );
  }
}
//       ExpansionTile(
//         trailing: Icon(
//           expansionProvider.isExpanded ? Icons.expand_less : Icons.expand_more,
//           color: Color(0xffff548e),
//         ),
//         expansionProvider: expansionProvider,
//         initiallyExpanded: false,
//         maintainState: true,
//         onExpansionChanged: (isExpanded) => {
//           expansionProvider.toggle(isExpanded),
//         },
//         childrenPadding: EdgeInsets.fromLTRB(15, 0, 15, 15),
//         backgroundColor: Colors.white,
//         // b: Colors.white,
//         tilePadding: EdgeInsets.fromLTRB(8, 5, 15, 0),
//         title: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text(
//             expansionProvider.isExpanded
//                 ? 'What is \non your mind ?'
//                 : 'My topics',
//             style: TextStyle(
//                 fontSize: expansionProvider.isExpanded ? 20 : 20,
//                 fontWeight: FontWeight.w600),
//           ),
//         ),
//         subtitle: !expansionProvider.isExpanded
//             ? Padding(
//                 padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
//                 child: Wrap(
//                   spacing: 0,
//                   alignment: WrapAlignment.start,
//                   children: _topicsProvider.chipSnaps
//                       .map(
//                         (chipData) => Visibility(
//                           visible: chipData.checked,
//                           child: Padding(
//                             padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
//                             child: FilterChip(
//                                 selected: chipData.checked,
//                                 checkmarkColor: Colors.white,
//                                 selectedColor: Color(0xffff548e),
//                                 showCheckmark: false,
//                                 onSelected: ((onSelected) {
//                                   chipData.checked = onSelected;
//                                   _topicsProvider.updateChips();
//                                 }),
//                                 shape: StadiumBorder(
//                                   side: BorderSide(
//                                     color: Color(0xffff548e),
//                                     width: 0.2,
//                                   ),
//                                 ),
//                                 backgroundColor: Colors.white,
//                                 label: Text(chipData.topic),
//                                 labelStyle: TextStyle(
//                                     fontSize: 12,
//                                     fontFamily: 'Nunito',
//                                     color: chipData.checked
//                                         ? Colors.white
//                                         : Color(0xffff548e))),
//                           ),
//                         ),
//                       )
//                       .toList()
//                       .cast<Widget>(),
//                 ),
//               )
//             : Container(),
//         children: [
//           Align(
//             alignment: Alignment.topLeft,
//             child: Wrap(
//               spacing: 15,
//               alignment: WrapAlignment.start,
//               children: _topicsProvider.chipSnaps
//                   .map(
//                     (chipData) => FilterChip(
//                         selected: chipData.checked,
//                         checkmarkColor: Colors.white,
//                         selectedColor: Color(0xffff548e),
//                         showCheckmark: true,
//                         onSelected: ((onSelected) =>
//                             chipData.checked = onSelected),
//                         shape: StadiumBorder(
//                           side: BorderSide(
//                             color: Color(0xffff548e),
//                             width: 1.0,
//                           ),
//                         ),
//                         backgroundColor: Colors.white,
//                         label: Text(chipData.topic),
//                         labelStyle: TextStyle(
//                             fontFamily: 'Nunito',
//                             color: chipData.checked
//                                 ? Colors.white
//                                 : Color(0xffff548e))),
//                   )
//                   .toList()
//                   .cast<Widget>(),
//             ),
//           ),
//         ],
//       );
//     });
//   }
// }
