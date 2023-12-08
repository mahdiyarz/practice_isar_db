import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
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

  Future<void> createBackUp() async {
    final isar = await db;
    final backUpDir = await getApplicationSupportDirectory();

    final File backUpFile = File('${backUpDir.path}/backup_db.isar');
    if (await backUpFile.exists()) {
      await backUpFile.delete();
    }

    await isar.copyToFile('${backUpDir.path}/backup_db.isar');
  }

  Future<void> restoreDB() async {
    final isar = await db;
    final dbDirectory = await getApplicationDocumentsDirectory();

    final Directory backupDirectory = await getApplicationSupportDirectory();

    await isar.close();

    final dbFile = File('${backupDirectory.path}/backup_db.isar');
    final dbPath = p.join(dbDirectory.path, 'default.isar');

    if (await dbFile.exists()) {
      await dbFile.copy(dbPath);
    }
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
    yield* isar.courses.where().watch(
          fireImmediately: true,
        );
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
