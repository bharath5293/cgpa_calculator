import 'package:flutter/material.dart';

void main() {
  runApp(GPACalculator());
}

class GPACalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GPAHomePage(),
    );
  }
}

class GPAHomePage extends StatefulWidget {
  @override
  _GPAHomePageState createState() => _GPAHomePageState();
}

class _GPAHomePageState extends State<GPAHomePage> {
  final List<Map<String, dynamic>> subjects = [];
  final Map<String, int> gradePoints = {
    "O": 10,
    "A+": 9,
    "A": 8,
    "B+": 7,
    "B": 6,
    "C": 5,
    "D": 4,
    "F": 0,
  };

  double gpa = 0.0;
  String selectedGrade = "O";
  final creditController = TextEditingController();

  void calculateGPA() {
    int totalCredits = 0;
    int totalPoints = 0;

    for (var subject in subjects) {
      int gradePoint = gradePoints[subject['grade']]!;
      int credit = subject['credits'];
      totalPoints += gradePoint * credit;
      totalCredits += credit;
    }

    setState(() {
      gpa = totalCredits > 0 ? totalPoints / totalCredits : 0.0;
    });
  }

  void addSubject() {
    final credits = int.tryParse(creditController.text.trim()) ?? 0;
    if (credits > 0 && gradePoints.containsKey(selectedGrade)) {
      setState(() {
        subjects.add({'grade': selectedGrade, 'credits': credits});
      });
      creditController.clear();
    }
  }

  void deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPA Calculator'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              "GPA Calculator",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Dropdown for grade selection
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blueAccent),
              ),
              child: DropdownButton<String>(
                value: selectedGrade,
                isExpanded: true,
                underline: SizedBox(),
                items: gradePoints.keys.map((String grade) {
                  return DropdownMenuItem<String>(
                    value: grade,
                    child:
                        Text(grade, style: TextStyle(color: Colors.blueAccent)),
                  );
                }).toList(),
                onChanged: (String? newGrade) {
                  setState(() {
                    selectedGrade = newGrade!;
                  });
                },
              ),
            ),
            SizedBox(height: 10),

            // Credit input field
            TextFormField(
              controller: creditController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Credits',
                labelStyle: TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                hintText: 'Enter credit hours',
              ),
            ),
            SizedBox(height: 20),

            // Add subject button
            ElevatedButton(
              onPressed: addSubject,
              child: Text('Add Subject'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            // Show added subjects with delete button
            Expanded(
              child: ListView.builder(
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        'Grade: ${subject['grade']} - Credits: ${subject['credits']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteSubject(index),
                      ),
                    ),
                  );
                },
              ),
            ),

            // GPA Result
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Card(
                color: Colors.blue[50],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Your GPA is:',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      Text(
                        gpa.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Calculate GPA button
            ElevatedButton(
              onPressed: calculateGPA,
              child: Text('Calculate GPA'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
