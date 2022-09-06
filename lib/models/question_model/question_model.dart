class QuestionModel {
  final String? qid;
  final String? question;
  final String? countAns;
  final List<String>? aid;
  final bool? mainQ;
  final String? mainAid;
  final String? asked;

  QuestionModel(
      {this.qid,
      this.aid,
      this.countAns,
      this.question,
      this.mainQ, this.asked, this.mainAid});

  factory QuestionModel.fromMap(map) {
    return QuestionModel(
      qid: map['qid'],
      question: map['question'],
      countAns: map['countAns'],
      aid: map['aid'].cast<String>(),
      mainQ: map['mainQ'],
      asked: map['asked'],
      mainAid: map['mainAid'],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'qid': qid,
      'question': question,
      'countAns': countAns,
      'aid': aid,
      'mainQ': mainQ,
      'asked': asked,
      'mainAid': mainAid,
    };
  }
}
