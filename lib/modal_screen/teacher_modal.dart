import 'package:flutter/material.dart';

import '../entities/course.dart';
import '../entities/teacher.dart';
import '../isar_service.dart';

class TeacherModal extends StatefulWidget {
  final IsarService isarService;
  const TeacherModal({required this.isarService, super.key});

  @override
  State<TeacherModal> createState() => _TeacherModalState();
}

class _TeacherModalState extends State<TeacherModal> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Course? selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _textController,
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Teacher name is not allowed to be empty';
                }
                return null;
              },
            ),
            FutureBuilder<List<Course>>(
              future: widget.isarService.getAllCourses(),
              builder: (context, AsyncSnapshot<List<Course>> snapshot) {
                if (snapshot.hasData) {
                  List<Course> data = snapshot.data!;
                  selectedCourse = data.first;

                  final courses = data.map((course) {
                    return DropdownMenuItem<Course>(
                        value: course, child: Text(course.title));
                  }).toList();

                  return DropdownButton<Course>(
                    items: courses,
                    value: selectedCourse,
                    onChanged: (value) {
                      setState(() {
                        selectedCourse = value;
                      });
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.isarService.saveTeacher(
                      Teacher()
                        ..name = _textController.text
                        ..course.value = selectedCourse,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'New Teacher *${_textController.text}* saved in DB')));

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add new Teacher'))
          ],
        ));
  }
}
