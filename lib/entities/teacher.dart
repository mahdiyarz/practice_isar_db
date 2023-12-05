import 'package:isar/isar.dart';
import 'package:practice_isar_db/entities/course.dart';

part 'teacher.g.dart';

// TODO: Create your class with [Collection] annotation
// TODO: Atleast, create an [IsarLink] and refer to your mainclass

@Collection()
class Teacher {
  Id id = Isar.autoIncrement;
  late String name;
  final course = IsarLink<Course>();
}
