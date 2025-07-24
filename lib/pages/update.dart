import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/pages/display.dart';
//update the notes
class UpdateNote extends StatefulWidget {
  final String name;
  final String studentId;
  final String studyId;
  final double gpa;
  final String docsId;
  const UpdateNote({
    super.key,
    required this.studentId,
    required this.gpa,
    required this.name,
    required this.studyId,
    required this.docsId,
  });

  @override
  State<UpdateNote> createState() => _UpdateNoteState();
}

class _UpdateNoteState extends State<UpdateNote> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController studyController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
//init state
  @override
  void initState() {
    nameController.text = widget.name;
    gpaController.text = widget.gpa.toString();
    studentIDController.text = widget.studentId;
    studyController.text = widget.studyId;
    super.initState();
  }
//dispose
  @override
  void dispose() {
    nameController.clear();
    studentIDController.clear();
    studyController.clear();
    gpaController.clear();
    super.dispose();
  }

  void updateNotes() async {
    final String name = nameController.text;
    final double gpa = double.tryParse(gpaController.text) ?? 0.0;
    final String studentId = studentIDController.text;
    final String studyProgramId = studyController.text;

    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.docsId)
        .update({
          'name': name,
          'student_id': studentId,
          'gpa': gpa,
          'study_program_id': studyProgramId,
        });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Student Details Updated")));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => StudentListScreen()),
        (Route<dynamic> route) => false, 
      );
    }

    nameController.clear();
    gpaController.clear();
    studentIDController.clear();
    studyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    log(widget.name);
    return Scaffold(
      appBar: AppBar(title: Text("Update the Notes")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",

                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: studentIDController,
                decoration: InputDecoration(
                  labelText: "StudentID",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: studyController,
                decoration: InputDecoration(
                  labelText: "Study Program ID",
                  fillColor: Colors.white,

                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: gpaController,
                decoration: InputDecoration(
                  labelText: "GPA",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(height: 30),
              FilledButton(onPressed: updateNotes, child: Text("Update")),
            ],
          ),
        ),
      ),
    );
  }
}
