import 'package:isar/isar.dart';
import 'package:practice_isar_db/entities/course.dart';

part 'student.g.dart';

// TODO: Create your class with [Collection] annotation
// TODO: Atleast, create an [IsarLinks] and refer to your mainclass

@Collection()
class Student {
  Id id = Isar.autoIncrement;
  late String name;
  final courses = IsarLinks<Course>();
}
