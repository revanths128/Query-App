import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:question_and_answer/components/QuestionRequest.dart';
import 'package:question_and_answer/components/constants.dart';
import 'package:question_and_answer/components/question_message.dart';
import 'package:question_and_answer/components/size_config.dart';
import 'icon_widget.dart';

class Search extends StatefulWidget {
  static String id = "search";

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getQuestionsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var question in _allResults) {
        var title = question[1].toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(question);
        }
      }
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getQuestionsStreamSnapshots() async {
    var collection = FirebaseFirestore.instance.collection('questions');
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      if(data['mainQ']){
        _allResults.add([data['qid'] ,data['question']]);
      }
    }
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: kPrimaryColor),
              height: getProportionateScreenHeight(50),
              child: Padding(
                padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(10),
                    right: getProportionateScreenWidth(20)),
                child: Row(
                  children: [
                    IconWidget(
                        icons: Icons.arrow_back_ios,
                        onPress: () {
                          Navigator.pop(context);
                        }),
                    QuestionRequest(
                        height: 40,
                        width: getProportionateScreenWidth(302),
                        text: "Search your question here..",
                        maxLines: 1,
                        onChange: (value) {},
                        controller: _searchController)
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _resultsList.length,
              itemBuilder: (BuildContext context, int index) =>
                  QuestionMessage(question: _resultsList[index][1], qid: _resultsList[index][0], mainQ: true),
            ),
            ),
          ],
        ),
      ),
    );
  }
}


