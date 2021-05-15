import 'package:versify/screens/feed_screen/create_post_sub/widgets/chip_object.dart';
import 'package:flutter/cupertino.dart';

class SuggestionTopicsProvider extends ChangeNotifier {
  List<ChipObject> _chipFromPeople = [
    ChipObject(topic: 'What I did this morning'),
    ChipObject(topic: 'Today, I\'m grateful for'),
    ChipObject(topic: 'I need healing'),
    ChipObject(topic: 'How God has worked in my life'),

    // ChipObject(topic: 'Anxiety'),
    // ChipObject(topic: 'Doubt'),
    // ChipObject(topic: 'Guilt'),
    // ChipObject(topic: 'Anger'),
    // ChipObject(topic: 'Fear'),
    // ChipObject(topic: 'Stress'),
    // ChipObject(topic: 'Jealousy'),
    // ChipObject(topic: 'Loss'),
  ];
  List<ChipObject> _chipForYou = [
    ChipObject(topic: 'Prayer is powerful'),
    ChipObject(topic: 'My life after I accepted Christ'),
    ChipObject(
        topic:
            'Love always perseveres, my thoughts towards love and how I met God'),
  ];

  List<ChipObject> get chipFromPeople => _chipFromPeople;

  bool get hasSelected {
    List _list = _chipFromPeople.map((chip) {
      print(chip.checked);
      return chip.checked;
    }).toList();

    _chipForYou.map((chip) {
      print(chip.checked);
      _list.add(chip.checked);
    });

    // print(_list);
    return _list.contains(true) == false ? hasSelectedForYou : true;
  }

  List<ChipObject> get chipForYou => _chipForYou;

  bool get hasSelectedForYou {
    List _list = _chipForYou.map((chip) {
      print(chip.checked);
      return chip.checked;
    }).toList();

    // print(_list);
    return _list.contains(true);
  }

  void uncheckAll() {
    _chipFromPeople.forEach((chip) {
      chip.checked = false;
    });
    _chipForYou.forEach((chip) {
      chip.checked = false;
    });
  }

  void updateChips() {
    notifyListeners();
  }
}
