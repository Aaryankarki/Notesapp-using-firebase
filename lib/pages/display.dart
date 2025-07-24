import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/constant/const.dart';
import 'package:noteapp/pages/addnotes.dart';
import 'package:noteapp/pages/update.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  Stream<String> timeStream() async* {
    const apiKey = OPENWEATHER_API_KEY;
    const city = "Kathmandu";
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey";

    while (true) {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timestamp = data['dt'] as int;

        final dateTime = DateTime.fromMillisecondsSinceEpoch(
          timestamp * 1000,
        ).toLocal();

        final timeString = DateFormat.Hms().format(dateTime);
        yield timeString;
      } else {
        yield "Error";
      }

      await Future.delayed(Duration(minutes: 1));
    }
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: StreamBuilder<String>(
          stream: timeStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading time...');
            } else if (snapshot.hasError) {
              return const Text('Error fetching time');
            } else {
              return Text('Time: ${snapshot.data}');
            }
          },
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('notes').snapshots(),
        builder: (context, snapshots) {
          if (!snapshots.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          final data = snapshots.data!.docs;
          log(data.toString());

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final doc = data[index];

              final student = doc.data() as Map<String, dynamic>;
              final docId = doc.id;
              log(student.toString());

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student['name'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('GPA: ${student['gpa'] ?? 'N/A'}'),
                      Text('Student ID: ${student['student_id'] ?? 'N/A'}'),
                      Text(
                        'Program ID: ${student['study_program_id'] ?? 'N/A'}',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateNote(
                                    docsId: docId,
                                    gpa: student['gpa'],
                                    name: student['name'],
                                    studentId: student['student_id'],
                                    studyId: student['study_program_id'],
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.edit),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('notes')
                                  .doc(docId)
                                  .delete();
                            },
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddNote()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
