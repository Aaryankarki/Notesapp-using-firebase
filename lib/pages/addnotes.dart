import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/pages/display.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController studentIDController = TextEditingController();
  final TextEditingController studyController = TextEditingController();
  final TextEditingController gpaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //dispose
  @override
  void dispose() {
    nameController.clear();
    studentIDController.clear();
    studyController.clear();
    gpaController.clear();
    super.dispose();
  }

  void createNotes() async {
    final String name = nameController.text;
    final double gpa = double.tryParse(gpaController.text) ?? 0.0;
    final String studentId = studentIDController.text;
    final String studyProgramId = studyController.text;

    await FirebaseFirestore.instance.collection('notes').add({
      'name': name,
      'student_id': studentId,
      'gpa': gpa,
      'study_program_id': studyProgramId,
    });
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Student Added")));

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => StudentListScreen()),
        (route) => false,
      );
    }

    nameController.clear();
    gpaController.clear();
    studentIDController.clear();
    studyController.clear();
  }

  //build context

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add the Notes")),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(onPressed: createNotes, child: Text("Create")),
                ],
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.save),
      // ),
    );
  }
}
