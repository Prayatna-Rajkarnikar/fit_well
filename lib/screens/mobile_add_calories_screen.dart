import 'package:flutter/material.dart';

class AddCalorieScreen extends StatefulWidget {
  @override
  AddCaloriesScreenState createState() => AddCaloriesScreenState();
}

class AddCaloriesScreenState extends State<AddCalorieScreen> {
  String selectedActivity = 'Running';
  int selectedHour = 1;
  int selectedMinute = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back arrow and title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Add Calorie",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),

            Spacer(),

            // Weight display
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'Weight ',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  children: [
                    TextSpan(
                      text: '70',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: ' kg',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // Activity label
            Center(
              child: Text(
                'Activity',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            SizedBox(height: 10),

            // Activity dropdown
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButton<String>(
                  dropdownColor: Colors.grey[900],
                  value: selectedActivity,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                  underline: SizedBox(),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedActivity = newValue!;
                    });
                  },
                  items: <String>['Running', 'Walking', 'Cycling']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Duration
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Duration ', style: TextStyle(color: Colors.white, fontSize: 18)),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Text('$selectedHour', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  SizedBox(width: 5),
                  Text('h', style: TextStyle(color: Colors.grey, fontSize: 18)),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      shape: BoxShape.circle,
                    ),
                    child: Text('$selectedMinute', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                  SizedBox(width: 5),
                  Text('m', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            ),

            Spacer(),

            // Done button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () {
                    // Handle Done
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),

            // Bottom navigation bar
            BottomNavigationBar(
              backgroundColor: Colors.grey[900],
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  label: 'Report',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
