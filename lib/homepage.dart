import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'fa.dart';

class Homepage extends StatefulWidget {
  final FA faInstance;

  const Homepage({Key? key, required this.faInstance}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with AutomaticKeepAliveClientMixin {
  FA faInstance = FA();
  int bottomButton = 0, currentStep = 1;
  int? stateAmount = 1, keyAmount = 1, transitionAmount;
  bool? epsilon = false;
  String? initialState, userInput;
  List<Widget> transitionFieldList = [];
  List<String> stateFieldValues = [],
      keyFieldValues = [],
      finalState = [],
      fromState = [],
      byKey = [];
  List<List<String>> toState = [];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Widget? buttonRow;
    FA faInstance = widget.faInstance;

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
      stateFieldValues = []; //reset values if user come back to step 1
      keyFieldValues = [];
      finalState = [];
      initialState = null;

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
                    if (!stateFieldValues.contains(value)) {
                      if (index >= stateFieldValues.length) {
                        stateFieldValues.add(value);
                      } else {
                        stateFieldValues[index] = value;
                      }
                      print(stateFieldValues);
                    } else {
                      // stateFieldValues[index] = '';
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please insert a unique state value!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 15),
            ]).expand((widgets) => widgets).toList();

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
                      if (!keyFieldValues.contains(value)) {
                        if (index >= keyFieldValues.length) {
                          keyFieldValues.add(value);
                        } else {
                          keyFieldValues[index] = value;
                        }
                        print(keyFieldValues);
                      } else {
                        // keyFieldValues[index] = '';
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please insert a unique key value!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    });
                  }),
            ]).expand((widgets) => widgets).toList();

    List<Widget> renderStep2() {
      toState = [];
      return [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Choose Start State:'),
                DropdownButton<String>(
                  value: initialState != null &&
                          stateFieldValues.contains(initialState)
                      ? initialState
                      : null,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: initialState != null
                      ? Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        )
                      : null,
                  onChanged: (String? newValue) {
                    setState(() {
                      initialState = newValue;
                      print(initialState);
                    });
                  },
                  items: stateFieldValues.map<DropdownMenuItem<String>>(
                    (String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: MultiSelectDialogField<String>(
                    initialValue: finalState,
                    buttonText: const Text('Choose Final State:'),
                    selectedColor: Colors.deepPurple,
                    selectedItemsTextStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    items: stateFieldValues
                        .map((value) => MultiSelectItem(value, value))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      setState(() {
                        finalState = values;
                        print(finalState);
                      });
                    },
                    chipDisplay: MultiSelectChipDisplay(
                        chipColor: Colors.amber,
                        // scroll: true,
                        textStyle: const TextStyle(color: Colors.white),
                        onTap: (value) {
                          setState(() {
                            // finalState.remove(value);
                            finalState = finalState
                                .where((item) => item != value)
                                .toList();
                            print(finalState);
                          });
                        }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
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
      ];
    }

    List<Widget> renderStep3() {
      userInput = null;
      if (toState.length < stateAmount! * keyAmount!) {
        // Fill with empty lists if not enough elements
        toState = List.generate(stateAmount! * keyAmount!, (index) => []);
      }
      // Generate the transitionFieldList directly using nested loops
      List<Widget> transitionFieldList =
          List.generate(stateAmount!, (stateIndex) {
        Map<String, String> inputMap = {};
        return Column(
          children: List.generate(keyAmount!, (keyIndex) {
            int index = stateIndex * keyAmount! + keyIndex;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        "State ${stateFieldValues[stateIndex]} transition by ${keyFieldValues[keyIndex]}")
                  ],
                ),
                MultiSelectDialogField<String>(
                  buttonText: const Text('To'),
                  selectedColor: Colors.deepPurple,
                  selectedItemsTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  items: stateFieldValues
                      .map((value) => MultiSelectItem(value, value))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    setState(() {
                      toState[index] = values;
                      inputMap[keyFieldValues[keyIndex]] = values.toString();
                      String key = keyFieldValues[keyIndex];
                      if (faInstance.T
                          .containsKey(stateFieldValues[stateIndex])) {
                        // If the state already exists in the map, concatenate the values
                        faInstance.T[stateFieldValues[stateIndex]]![key] =
                            (faInstance.T[stateFieldValues[stateIndex]]![key] ??
                                    '') +
                                values.join(', ');
                      } else {
                        // Otherwise, create a new entry in the map
                        faInstance.T[stateFieldValues[stateIndex]] = {
                          key: values.join(',')
                        };
                      }
                      print(toState);
                      print(faInstance.T);
                    });
                  },
                  chipDisplay: MultiSelectChipDisplay(
                    chipColor: Colors.amber,
                    textStyle: const TextStyle(color: Colors.white),
                    onTap: (value) {
                      setState(() {
                        toState[index] = toState[index]
                            .where((item) => item != value)
                            .toList();
                        print(toState);
                      });
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                )
              ],
            );
          }),
        );
      });

      return [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: transitionFieldList,
        )
      ];
    }

    List<Widget> renderStep4() {
      String fnState = "";
      fnState = finalState.join(',');

      faInstance.Q = stateFieldValues;
      faInstance.X = keyFieldValues;
      faInstance.S = initialState!;
      faInstance.F = fnState;

      return [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 50,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.deepPurple,
                  ),
                ),
                child: const Text("Test NFA or DFA"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => FractionallySizedBox(
                            heightFactor: 0.5,
                            alignment: Alignment.center,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text(
                                "Test NFA or DFA",
                                style: TextStyle(color: Colors.deepPurple),
                              ),
                              content: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (faInstance.isDFA() == true)
                                            const Text("IT IS DFA",
                                                style: TextStyle(
                                                    color: Colors.deepPurple))
                                          else
                                            const Text("IT IS NFA",
                                                style: TextStyle(
                                                    color: Colors.deepPurple))
                                        ]),
                                  ]),
                            ),
                          ));
                  print(faInstance.isDFA());
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 50,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.deepPurple,
                  ),
                ),
                child: const Text("Test String"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => FractionallySizedBox(
                      heightFactor: 0.5,
                      alignment: Alignment.center,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text(
                          "Test String",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: TextField(
                                          decoration: InputDecoration(
                                            hintText: 'Enter a String to Test!',
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              borderSide: const BorderSide(
                                                color: Colors.deepPurpleAccent,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              userInput = value;
                                            });
                                          }),
                                    ),
                                  ]),
                              const SizedBox(height: 15),
                              FilledButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                    (states) => Colors.deepPurple,
                                  ),
                                ),
                                onPressed: () {
                                  if (userInput != null || userInput != "") {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            FractionallySizedBox(
                                              heightFactor: 0.25,
                                              alignment: Alignment.center,
                                              child: AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                content: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            if (faInstance
                                                                        .isDFA() ==
                                                                    true &&
                                                                faInstance.checkDFA(
                                                                        userInput!) ==
                                                                    true)
                                                              const Text(
                                                                "STRING ACCEPTED !",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple),
                                                              )
                                                            else if (faInstance
                                                                        .isDFA() ==
                                                                    true &&
                                                                faInstance.checkDFA(
                                                                        userInput!) ==
                                                                    false)
                                                              const Text(
                                                                "STRING REJECTED !",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple),
                                                              )
                                                            else if (faInstance
                                                                        .isDFA() ==
                                                                    false &&
                                                                faInstance.checkNFA(
                                                                        userInput!) ==
                                                                    true)
                                                              const Text(
                                                                "STRING ACCEPTED !",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple),
                                                              )
                                                            else if (faInstance
                                                                        .isDFA() ==
                                                                    false &&
                                                                faInstance.checkNFA(
                                                                        userInput!) ==
                                                                    false)
                                                              const Text(
                                                                "STRING REJECTED !",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .deepPurple),
                                                              )
                                                          ])
                                                    ]),
                                              ),
                                            ));

                                    print(faInstance.checkDFA(userInput!));
                                    print(userInput);
                                  } else {
                                    faInstance.checkNFA(userInput!);
                                    print(faInstance.checkNFA(userInput!));
                                    print(userInput);
                                  }
                                },
                                child: const Text("Check!"),
                              )
                            ]),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 50,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.deepPurple,
                  ),
                ),
                child: const Text("Convert NFA to DFA"),
                onPressed: () {
                  print("hello");
                },
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 50,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith(
                    (states) => Colors.deepPurple,
                  ),
                ),
                child: const Text("DFA Minimization"),
                onPressed: () {
                  print("hello");
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        )
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
      body: SafeArea(
        child: SizedBox(
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
                            if (currentStep == 1)
                              // ...renderStep4(),
                              ...renderStep1(),
                            if (currentStep == 2) ...renderStep2(),
                            if (currentStep == 3) ...renderStep3(),
                            if (currentStep == 4) ...renderStep4(),
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
