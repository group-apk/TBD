import 'dart:collection';

import '../new_model/test_model.dart';
import 'package:flutter/cupertino.dart';

class TestNotifier with ChangeNotifier {
  List<TestModel> _testList = [];
  TestModel? _currentTestModel;

  UnmodifiableListView<TestModel> get testList =>
      UnmodifiableListView(_testList);

  TestModel get currentTestModel => _currentTestModel!;

  set testList(List<TestModel> testList) {
    _testList = testList;
    notifyListeners();
  }

  set currentTestModel(TestModel testmodel) {
    _currentTestModel = testmodel;
    notifyListeners();
  }

  addTest(TestModel test) {
    _testList.add(test);
    notifyListeners();
  }

  deleteTest(TestModel test) {
    _testList.removeWhere((element) => element.id == test.id);
    notifyListeners();
  }

  deleteQuestion(TestModel test, int index) {
    _currentTestModel!.questions!
        .removeWhere((element) => element.qid == test.questions![index].qid);
    notifyListeners();
  }
}
