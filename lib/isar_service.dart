import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practice_isar_db/entities/course.dart';
import 'package:practice_isar_db/entities/student.dart';
import 'package:practice_isar_db/entities/teacher.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();

      return await Isar.open(
        [
          CourseSchema,
          StudentSchema,
          TeacherSchema,
        ],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> cleanDB() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<void> saveCourse(Course newCourse) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.courses.putSync(newCourse));
  }

  Future<List<Course>> getAllCourses() async {
    final isar = await db;
    return await isar.courses.where().findAll();
  }

  Stream<List<Course>> listenToCourses() async* {
    final isar = await db;
    yield* isar.courses.where().watch();
  }

  Future<void> saveStudent(Student newStudent) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.students.putSync(newStudent));
  }

  Future<List<Student>> getStudentsFor(Course course) async {
    final isar = await db;
    return await isar.students
        .filter()
        .courses((q) => q.idEqualTo(course.id))
        .findAll();
  }

  Future<void> saveTeacher(Teacher newTeacher) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.teachers.putSync(newTeacher));
  }

  Future<Teacher?> getTeacherFor(Course course) async {
    final isar = await db;
    return await isar.teachers
        .filter()
        .course((q) => q.idEqualTo(course.id))
        .findFirst();
  }
}
