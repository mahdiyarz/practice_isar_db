import 'package:flutter/material.dart';
import 'package:practice_isar_db/isar_service.dart';

import 'entities/course.dart';
import 'entities/student.dart';
import 'entities/teacher.dart';

class CourseDetailScreen extends StatelessWidget {
  final IsarService isarService;
  final Course course;
  const CourseDetailScreen({
    required this.course,
    required this.isarService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(course.title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<Teacher?>(
              future: isarService.getTeacherFor(course),
              builder: (context, snapshot) {
                return Row(children: [
                  const Text("Teacher: "),
                  Text(snapshot.hasData
                      ? snapshot.data!.name
                      : "No teacher yet for this course.")
                ]);
              },
            ),
            const SizedBox(height: 8),
            const Text("Students:"),
            Expanded(
              child: FutureBuilder<List<Student>>(
                future: isarService.getStudentsFor(course),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text(snapshot.error.toString());
                  if (snapshot.hasData) {
                    final students = snapshot.data!;
                    if (students.isEmpty) {
                      return const Text("No students in this course");
                    }

                    List<Text> studentsWidget = [];

                    for (int i = 0; i < students.length; i++) {
                      final student = students[i];
                      studentsWidget.add(Text("$i. ${student.name}"));
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [...studentsWidget],
                      ),
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
