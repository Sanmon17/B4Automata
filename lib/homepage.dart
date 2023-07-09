import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int button1 = 0, bottomButton = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'B4 : FA Simulation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.deepPurple),
                ),
                onPressed: () {
                  setState(() {
                    ++button1;
                  });
                },
                child: Text(button1.toString()),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.amber),
                ),
                onPressed: () {
                  setState(() {
                    ++button1;
                  });
                },
                child: Text(button1.toString()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple,
        selectedIconTheme: const IconThemeData(color: Colors.amberAccent),
        unselectedIconTheme: const IconThemeData(color: Colors.white),
        selectedItemColor: Colors.amberAccent[100],
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            label: 'Calculate',
            icon: Icon(
              Icons.calculate_outlined,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            label: 'History',
            icon: Icon(
              Icons.history_edu_sharp,
              size: 30,
            ),
          ),
        ],
        currentIndex: bottomButton,
        onTap: (value) {
          setState(() {
            bottomButton = value;
          });
        },
      ),
    );
  }
}
