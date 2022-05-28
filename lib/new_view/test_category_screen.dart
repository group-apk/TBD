import 'package:flutter/material.dart';
import 'package:map_proj/new_api/test_api.dart';
import 'package:map_proj/new_model/test_model.dart';
import 'package:map_proj/new_notifier/test_notifier.dart';
import 'package:map_proj/new_view/add_test.dart';
import 'package:map_proj/new_view/question_manager.dart';
import 'package:provider/provider.dart';

class HealthTestCategoryScreen extends StatefulWidget {
  const HealthTestCategoryScreen({Key? key}) : super(key: key);

  @override
  _HealthTestCategoryScreenState createState() =>
      _HealthTestCategoryScreenState();
}

class _HealthTestCategoryScreenState extends State<HealthTestCategoryScreen> {
  int i = 0;

  @override
  void initState() {
    TestNotifier testNotifier =
        Provider.of<TestNotifier>(context, listen: false);
    getTest(testNotifier);
    super.initState();
  }

  int checkTestName(String name) {
    int index = 0;
    TestNotifier testNotifier =
        Provider.of<TestNotifier>(context, listen: false);
    for (int i = 0; i < testNotifier.testList.length; i++) {
      if (name == testNotifier.testList[i].testName) {
        index = i;
      }
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    TestNotifier testNotifier =
        Provider.of<TestNotifier>(context, listen: false);
    var testProvider = context.read<TestNotifier>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddTestScreen()));
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Health Assessment Manager'),
        titleTextStyle: const TextStyle(
            color: Colors.blue, fontSize: 20.0, fontWeight: FontWeight.bold),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF0069FE),
          ),
          onPressed: () {
            // passing this to root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: FutureBuilder(
            future: getTestFuture(testProvider),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return Consumer<TestNotifier>(
                builder: (context, value, child) => GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  crossAxisCount: 2,
                  children: testProvider.testList
                      .map((e) => InkWell(
                            onTap: () {
                              testNotifier.currentTestModel = testNotifier
                                  .testList[checkTestName('${e.testName}')];
                              // getQuestion(testNotifier.currentTestModel);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditTestScreen(
                                          testName: '${e.testName}')));
                            },
                            child: Card(
                              elevation: 5,
                              shadowColor: Colors.blue,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${e.testName}'),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
