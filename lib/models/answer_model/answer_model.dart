class AnswerModel {
  final String? answer;
  final String? aid;
  final List<String>? subQid;
  final String? countSub;
  final String? qid;
  final bool? mainA;
  final String? answered;

  AnswerModel({this.aid, this.answer, this.qid, this.countSub, this.subQid, this.mainA, this.answered});

  factory AnswerModel.fromMap(map) {
    return AnswerModel(
      answer: map['answer'],
      aid: map['aid'],
      qid: map['qid'],
      countSub: map['countSub'],
      subQid: map['subQid'].cast<String>(),
      mainA: map['mainA'],
      answered: map['answered'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'aid': aid,
      'qid': qid,
      'countSub': countSub,
      'subQid': subQid,
      'mainA': mainA,
      'answered': answered,
    };
  }
}
