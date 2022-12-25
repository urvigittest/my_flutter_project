// To parse this JSON data, do
//
//     final subjectAnalysisModel = subjectAnalysisModelFromJson(jsonString);

import 'dart:convert';

SubjectAnalysisModel subjectAnalysisModelFromJson(String str) =>
    SubjectAnalysisModel.fromJson(json.decode(str));

String subjectAnalysisModelToJson(SubjectAnalysisModel data) =>
    json.encode(data.toJson());

class SubjectAnalysisModel {
  SubjectAnalysisModel({
    this.status,
    this.message,
    this.chapterBreakdown,
    this.questionBreakdown,
  });

  bool? status;
  String? message;
  ChapterBreakdown? chapterBreakdown;
  QuestionBreakdown? questionBreakdown;

  factory SubjectAnalysisModel.fromJson(Map<String, dynamic> json) =>
      SubjectAnalysisModel(
        status: (json["status"] == null) ? null : json["status"],
        message: (json["message"] == null) ? null : json["message"],
        chapterBreakdown: json["chapter_breakdown"] == null
            ? null
            : ChapterBreakdown.fromJson(json["chapter_breakdown"]),
        questionBreakdown: json["question_breakdown"] == null
            ? null
            : QuestionBreakdown.fromJson(json["question_breakdown"]),
      );

  Map<String, dynamic> toJson() => {
        "status": (status == null) ? null : status,
        "message": (message == null) ? null : message,
        "chapter_breakdown":
            chapterBreakdown == null ? null : chapterBreakdown!.toJson(),
        "question_breakdown":
            questionBreakdown == null ? null : questionBreakdown!.toJson(),
      };
}

class ChapterBreakdown {
  ChapterBreakdown({
    this.totalOngoingTopic,
    this.totalCompletedTopic,
    this.totalTopic,
    this.totalUnseenTopic,
  });

  int? totalOngoingTopic;
  int? totalCompletedTopic;
  int? totalTopic;
  int? totalUnseenTopic;

  factory ChapterBreakdown.fromJson(Map<String, dynamic> json) =>
      ChapterBreakdown(
        totalOngoingTopic: (json["total_ongoing_topic"] == null)
            ? 0
            : json["total_ongoing_topic"],
        totalCompletedTopic: (json["total_completed_topic"] == null)
            ? 0
            : json["total_completed_topic"],
        totalTopic: (json["total_topic"] == null) ? 0 : json["total_topic"],
        totalUnseenTopic: (json["total_unseen_topic"] == null)
            ? 0
            : json["total_unseen_topic"],
      );

  Map<String, dynamic> toJson() => {
        "total_ongoing_topic":
            (totalOngoingTopic == null) ? 0 : totalOngoingTopic,
        "total_completed_topic":
            (totalCompletedTopic == null) ? 0 : totalCompletedTopic,
        "total_topic": (totalTopic == null) ? 0 : totalTopic,
        "total_unseen_topic": (totalUnseenTopic == null) ? 0 : totalUnseenTopic,
      };
}

class QuestionBreakdown {
  QuestionBreakdown({
    this.totalCorrect,
    this.totalIncorrect,
    this.totalSkip,
    this.totalCorrectTime,
    this.totalIncorrectTime,
    this.totalSkipTime,
    this.totalQuestion,
    this.progress,
    this.accuracy,
    this.perhourQuestion,
  });

  int? totalCorrect;
  int? totalIncorrect;
  int? totalSkip;
  int? totalCorrectTime;
  int? totalIncorrectTime;
  int? totalSkipTime;
  int? totalQuestion;
  dynamic progress;
  dynamic accuracy;
  int? perhourQuestion;

  factory QuestionBreakdown.fromJson(Map<String, dynamic> json) =>
      QuestionBreakdown(
        totalCorrect:
            (json["total_correct"] == null) ? 0 : json["total_correct"],
        totalIncorrect:
            (json["total_incorrect"] == null) ? 0 : json["total_incorrect"],
        totalSkip: (json["total_skip"] == null) ? 0 : json["total_skip"],
        totalCorrectTime: (json["total_correct_time"] == null)
            ? 0
            : json["total_correct_time"],
        totalIncorrectTime: (json["total_incorrect_time"] == null)
            ? 0
            : json["total_incorrect_time"],
        totalSkipTime:
            (json["total_skip_time"] == null) ? 0 : json["total_skip_time"],
        totalQuestion:
            (json["total_question"] == null) ? 0 : json["total_question"],
        progress: (json["progress"] == null) ? 0 : json["progress"].toDouble(),
        accuracy: (json["accuracy"] == null) ? 0.0 : json["accuracy"],
        perhourQuestion:
            (json["perhour_question"] == null) ? 0 : json["perhour_question"],
      );

  Map<String, dynamic> toJson() => {
        "total_correct": (totalCorrect == null) ? null : totalCorrect,
        "total_incorrect": (totalIncorrect == null) ? null : totalIncorrect,
        "total_skip": (totalSkip == null) ? null : totalSkip,
        "total_correct_time":
            (totalCorrectTime == null) ? null : totalCorrectTime,
        "total_incorrect_time":
            (totalIncorrectTime == null) ? null : totalIncorrectTime,
        "total_skip_time": (totalSkipTime == null) ? null : totalSkipTime,
        "total_question": (totalQuestion == null) ? null : totalQuestion,
        "progress": (progress == null) ? null : progress,
        "accuracy": (accuracy == null) ? null : accuracy,
        "perhour_question": (perhourQuestion == null) ? null : perhourQuestion,
      };
}
