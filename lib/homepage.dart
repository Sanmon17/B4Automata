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
        // centerTitle: true,
        flexibleSpace: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 22.0),
              child: Center(
                child: Image.asset(
                  'images/cadtwhiteNoBg.png',
                  width: MediaQuery.of(context).size.width * 0.17,
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.only(right: 30.0),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'B4 : FA Simulation',
                  // textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // const Spacer(),
          ],
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.87,
                  padding: const EdgeInsets.all(32),
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.asset(
                          'images/automata.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Enter Informations!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Amount of States',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Amount of States',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Amount of States',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Amount of States',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.deepPurpleAccent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.amber),
                        ),
                        onPressed: () {
                          setState(() {
                            ++button1;
                          });
                        },
                        child: Text('Amount pressed: $button1'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.black54,
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
