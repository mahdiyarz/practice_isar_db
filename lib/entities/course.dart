import 'package:isar/isar.dart';
import 'package:practice_isar_db/entities/student.dart';
import 'package:practice_isar_db/entities/teacher.dart';

part 'course.g.dart';

// TODO: Create your class with [Collection] annotation
// TODO: Add the backlink to the subclasses [Student, Teacher] with Backlink annotation

@Collection()
class Course {
  Id id = Isar.autoIncrement;
  late String title;

  @Backlink(to: 'course')
  final teacher = IsarLink<Teacher>();

  @Backlink(to: 'courses')
  final students = IsarLinks<Student>();
}
