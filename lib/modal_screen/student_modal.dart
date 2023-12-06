import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../entities/course.dart';
import '../entities/student.dart';
import '../isar_service.dart';

class StudentModal extends StatefulWidget {
  final IsarService isarService;
  const StudentModal({required this.isarService, super.key});

  @override
  State<StudentModal> createState() => _StudentModalState();
}

class _StudentModalState extends State<StudentModal> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Course> selectedCourses = [];

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
                  return 'Student name is not allowed to be empty';
                }
                return null;
              },
            ),
            FutureBuilder<List<Course>>(
              future: widget.isarService.getAllCourses(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<MultiSelectItem<Course>> courses = snapshot.data!
                      .map((e) => MultiSelectItem<Course>(e, e.title))
                      .toList();

                  return MultiSelectDialogField<Course>(
                    items: courses,
                    onConfirm: (value) {
                      selectedCourses = value;
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
                    widget.isarService.saveStudent(
                      Student()
                        ..name = _textController.text
                        ..courses.addAll(selectedCourses),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'New Student *${_textController.text}* saved in DB')));

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add new Student'))
          ],
        ));
  }
}
