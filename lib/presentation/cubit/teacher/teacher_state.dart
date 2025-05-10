import 'package:eleaning/data/models/teacher_model.dart';

class TeacherState {}

class TeacherInitial extends TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherSucess extends TeacherState {
  final List<TeacherModel> teacher;

  TeacherSucess({required this.teacher});
}

class TeacherFailure extends TeacherState {
  final String error;
  TeacherFailure({required this.error});
}
