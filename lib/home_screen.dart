import 'package:flutter/material.dart';
import 'package:practice_isar_db/course_detail_screen.dart';
import 'package:practice_isar_db/entities/course.dart';
import 'package:practice_isar_db/isar_service.dart';
import 'package:practice_isar_db/modal_screen/course_modal.dart';
import 'package:practice_isar_db/modal_screen/student_modal.dart';
import 'package:practice_isar_db/modal_screen/teacher_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final service = IsarService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isar DB simple APP'),
        actions: [
          IconButton(
            onPressed: () => service.cleanDB(),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => service.createBackUp(),
            icon: const Icon(Icons.backup),
          ),
          // IconButton(
          //   onPressed: () => service.restoreDB(),
          //   icon: const Icon(Icons.restart_alt),
          // ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Course>>(
              stream: service.listenToCourses(),
              builder: (context, snapshot) {
                return GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.hasData
                      ? snapshot.data!.map((course) {
                          return ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseDetailScreen(
                                        course: course, isarService: service),
                                  ));
                            },
                            child: Text(course.title),
                          );
                        }).toList()
                      : [],
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CourseModal(isarService: service);
                },
              );
            },
            child: const Text('Add new Course'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return StudentModal(isarService: service);
                },
              );
            },
            child: const Text('Add new Student'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TeacherModal(isarService: service);
                },
              );
            },
            child: const Text('Add new Teacher'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
