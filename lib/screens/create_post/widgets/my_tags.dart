import 'package:versify/providers/providers_create_post/create_topics_provider.dart';
import 'package:versify/providers/providers_home/theme_data_provider.dart';
import 'package:versify/screens/create_post/widgets/create_tags_bottomsheet.dart';
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
    final ThemeProvider _themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

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
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  backgroundColor: Theme.of(context).backgroundColor,
                  primary: Theme.of(context).backgroundColor,
                ),
                label: Text(
                  'My Tags',
                  style: TextStyle(
                      fontSize: 20,
                      color: _themeProvider.secondaryTextColor,
                      // fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600),
                ),
                icon: Icon(Icons.tag, color: _themeProvider.secondaryTextColor),
              ),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Theme.of(context).backgroundColor,
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
                          child: CreateTagsBottomSheet(),
                        ),
                      );
                    },
                  );
                  // Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  backgroundColor: Theme.of(context).backgroundColor,
                  primary: Theme.of(context).backgroundColor,
                ),
                label: Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.normal,
                  ),
                ),
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
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
                              border: Border.fromBorderSide(BorderSide(
                                  color: Theme.of(context).primaryColor)),
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
                                  color: Theme.of(context).primaryColor),
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
//           color: Theme.of(context).primaryColor,
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
//                                 selectedColor: Theme.of(context).primaryColor,
//                                 showCheckmark: false,
//                                 onSelected: ((onSelected) {
//                                   chipData.checked = onSelected;
//                                   _topicsProvider.updateChips();
//                                 }),
//                                 shape: StadiumBorder(
//                                   side: BorderSide(
//                                     color: Theme.of(context).primaryColor,
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
//                                         : Theme.of(context).primaryColor)),
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
//                         selectedColor: Theme.of(context).primaryColor,
//                         showCheckmark: true,
//                         onSelected: ((onSelected) =>
//                             chipData.checked = onSelected),
//                         shape: StadiumBorder(
//                           side: BorderSide(
//                             color: Theme.of(context).primaryColor,
//                             width: 1.0,
//                           ),
//                         ),
//                         backgroundColor: Colors.white,
//                         label: Text(chipData.topic),
//                         labelStyle: TextStyle(
//                             fontFamily: 'Nunito',
//                             color: chipData.checked
//                                 ? Colors.white
//                                 : Theme.of(context).primaryColor)),
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
