import 'package:eleaning/data/repository/teacher_repository.dart';
import 'package:eleaning/presentation/cubit/teacher/teacher_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherCubit extends Cubit<TeacherState> {
  final TeacherRepository teacherRepository;
  TeacherCubit({required this.teacherRepository}) : super(TeacherInitial());
  void getTeacher() async {
    emit(TeacherLoading());
    try {
      final teacher = await teacherRepository.getTeacher();
      if (teacher.isEmpty) {
        // Handle empty teacher list case
        emit(TeacherFailure(error: "No teachers found"));
      } else {
        emit(TeacherSucess(teacher: teacher));
      }
    } catch (e) {
      emit(TeacherFailure(error: e.toString()));
    }
  }
}
