import 'package:flutter/material.dart';
import 'package:practice_isar_db/entities/course.dart';

import '../isar_service.dart';

class CourseModal extends StatefulWidget {
  final IsarService isarService;
  final Course? editedCourse;
  const CourseModal({required this.isarService, this.editedCourse, super.key});

  @override
  State<CourseModal> createState() => _CourseModalState();
}

class _CourseModalState extends State<CourseModal> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                  return 'Course name is not allowed to be empty';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    widget.editedCourse != null
                        ? widget.isarService.saveCourse(
                            widget.editedCourse!..title = _textController.text)
                        : widget.isarService
                            .saveCourse(Course()..title = _textController.text);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'New Course *${_textController.text}* saved in DB')));

                    Navigator.pop(context);
                  }
                },
                child: const Text('Add new Course'))
          ],
        ));
  }
}
