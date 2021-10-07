import 'package:versify/screens/create_post/widgets/chip_object.dart';
import 'package:flutter/cupertino.dart';

class CreateTopicsProvider extends ChangeNotifier {
  List<ChipObject> _chipSnapshot = [
    ChipObject(topic: 'Love'),
    ChipObject(topic: 'Peace'),
    ChipObject(topic: 'Joy'),
    ChipObject(topic: 'Hope'),
    ChipObject(topic: 'Grateful'),
    ChipObject(topic: 'Healing'),
    ChipObject(topic: 'Patience'),
    ChipObject(topic: 'Anxiety'),
    ChipObject(topic: 'Doubt'),
    ChipObject(topic: 'Prayer'),
    ChipObject(topic: 'Lies'),
    ChipObject(topic: 'Grace'),
    ChipObject(topic: 'Stress'),
    ChipObject(topic: 'Kindness'),
    ChipObject(topic: 'Self-control'),
  ];

  List<ChipObject> get chipSnaps => _chipSnapshot;

  bool get hasSelected {
    List _list = _chipSnapshot.map((chip) {
      print(chip.checked);
      return chip.checked;
    }).toList();

    print(_list);
    return _list.contains(true);
  }

  void updateChips() {
    notifyListeners();
  }
}
