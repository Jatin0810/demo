import 'package:demo_project/src/module/courses/courses_model.dart';
import 'package:demo_project/src/module/courses/courses_view.dart';

class CoursesPresenter {
  set signInView(CoursesView value) {}
}

class BasicCoursesPresenter implements CoursesPresenter {
  late CoursesView view;
  late CoursesScreeenModel model;
  BasicCoursesPresenter() {
    view = CoursesView();
    model = CoursesScreeenModel();
  }

  @override
  set signInView(CoursesView value) {
    view = value;
    view.refreshModel(model);
  }
}
