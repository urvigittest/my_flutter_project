import '../models/idstringname_model.dart';

class StaticArrays {
  static List<IdStringNameModel> getAlertList() {
    return [
      IdStringNameModel(id: 2, name: 'Wrong Question', isSelected: false),
      IdStringNameModel(id: 3, name: 'Formatting issue', isSelected: false),
      IdStringNameModel(
          id: 4, name: 'Que & options both not visible', isSelected: false),
      IdStringNameModel(
          id: 5, name: 'Options visible, ques not visible', isSelected: false),
      IdStringNameModel(id: 6, name: 'Out of syllabus', isSelected: false),
      IdStringNameModel(id: 7, name: 'Wrong translation', isSelected: false),
      IdStringNameModel(id: 1, name: 'Other', isSelected: false),
    ];
  }
}
