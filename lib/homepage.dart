import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int bottomButton = 0, currentStep = 1;
  int? stateAmount = 1, keyAmount = 1;
  bool? epsilon = false;
  String? initialState, finalState, currentState;

  @override
  Widget build(BuildContext context) {
    Widget? buttonRow;
    List<String> stateFieldValues = List.filled(stateAmount!, '');
    List<String> keyFieldValues = List.filled(keyAmount!, '');

    if (currentStep == 1) {
      buttonRow = FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => Colors.amber,
          ),
        ),
        onPressed: () {
          setState(() {
            ++currentStep;
          });
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(7),
              child: Text('Next'),
            ),
          ],
        ),
      );
    } else {
      buttonRow = Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
              visible: currentStep > 1,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.amber,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    --currentStep;
                  });
                },
                child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(7),
                        child: Text('Back'),
                      ),
                    ]),
              ),
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.amber,
                ),
              ),
              onPressed: () {
                setState(() {
                  ++currentStep;
                });
              },
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text('Next'),
                    ),
                  ]),
            ),
          ],
        ),
      );
    }

    List<Widget> renderStep1() {
      return [
        const Text('Choose amount of State:'),
        DropdownButton<int>(
          value: stateAmount,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          isExpanded: true,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (int? newValue) {
            setState(() {
              stateAmount = newValue;
            });
          },
          items: List<DropdownMenuItem<int>>.generate(10, (index) {
            final value = index + 1;
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        const Text('Choose amount of Key:'),
        DropdownButton<int>(
          value: keyAmount,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          isExpanded: true,
          style: const TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (int? newValue) {
            setState(() {
              keyAmount = newValue;
            });
          },
          items: List<DropdownMenuItem<int>>.generate(10, (index) {
            final value = index + 1;
            return DropdownMenuItem<int>(
              value: value,
              child: Text(value.toString()),
            );
          }).toList(),
        ),
      ];
    }

    List<Widget> stateFieldList = List.generate(
      stateAmount!,
      (index) => [
        TextField(
          decoration: InputDecoration(
            hintText: 'State Value ${index + 1}',
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
          onChanged: (value) {
            setState(() {
              stateFieldValues[index] = value;
              print(stateFieldValues);
            });
          },
        ),
        const SizedBox(height: 15),
      ],
    ).expand((widgets) => widgets).toList();

    List<DropdownMenuItem<String>> dropdownItems = stateFieldValues
    .map((value) => DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        ))
    .toList();

    List<Widget> keyFieldList = List.generate(
        keyAmount!,
        (index) => [
              const SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Key Value ${index + 1}',
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
                onChanged: (value) {
                  setState(() {
                    keyFieldValues[index] = value;
                  });
                },
              ),
            ]).expand((widgets) => widgets).toList();

    List<Widget> renderStep2() {
      return [
        Column(
          children: stateFieldList,
        ),
        Column(
          children: [
            const Divider(
              color: Colors.deepPurple,
              thickness: 2.5,
            ),
            ...keyFieldList
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Include Epsilon?'),
                DropdownButton<bool>(
                  value: epsilon,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (bool? newValue) {
                    setState(() {
                      epsilon = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: true,
                      child: Text('Yes'),
                    ),
                    DropdownMenuItem(
                      value: false,
                      child: Text('No'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ];
    }

    List<Widget> renderStep3() {
      return [
        Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text('Choose Start State:'),
              DropdownButton<String>(
                value: initialState,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    initialState = newValue;
                  });
                },
                items: dropdownItems,
              )
            ],
          ),
        ]),
        const SizedBox(height: 15),
      ];
    }

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (currentStep == 1) ...renderStep1(),
                          if (currentStep == 2) ...renderStep2(),
                          if (currentStep == 3) ...renderStep3(),
                          const SizedBox(height: 15),
                        ],
                      ),
                      buttonRow,
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
