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
  int? stateAmount = 1, keyAmount = 1;
  bool? epsilon = false, epsilonCheck = false;
  String? initialState, userInput;
  List<Widget> transitionFieldList = [];
  List<String> stateFieldValues = [],
      keyFieldValues = [],
      finalState = [],
      fromState = [],
      byKey = [];
  List<List<String>> toState = [];
  Map<String, String> inputMap = {};

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
    } else if (currentStep < 4 && currentStep > 1) {
      buttonRow = Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Visibility(
              visible: (currentStep < 4 && currentStep > 1),
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
    } else if (currentStep == 4) {
      buttonRow = Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: (currentStep == 4),
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
            const SizedBox(
              height: 17,
            ),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith(
                  (states) => Colors.amber,
                ),
              ),
              onPressed: () {
                setState(() {
                  print("save!");
                });
              },
              child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text('Save'),
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

    List<Widget> keyFieldList = [];
    if (epsilon! && epsilonCheck == true) {
      keyFieldList = List.generate(
          keyAmount! - 1,
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
                          if (epsilon! && epsilonCheck == true) {
                            if (index + 1 >= keyFieldValues.length) {
                              keyFieldValues.add(value);
                            } else {
                              keyFieldValues[index + 1] = value;
                            }
                          } else {
                            if (index >= keyFieldValues.length) {
                              keyFieldValues.add(value);
                            } else {
                              keyFieldValues[index] = value;
                            }
                          }
                          print(keyFieldValues);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Please insert a unique key value!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      });
                    }),
              ]).expand((widgets) => widgets).toList();
    } else {
      keyFieldList = List.generate(
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please insert a unique key value!"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              });
            },
          ),
        ],
      ).expand((widgets) => widgets).toList();
    }

    List<Widget> renderStep2() {
      toState = [];
      inputMap.clear();
      faInstance.T.clear();
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
                      epsilon = newValue ??
                          true; // Update the epsilon variable with the new value
                      if (epsilon! == true && epsilonCheck == false) {
                        epsilonCheck = true;
                        keyAmount = keyAmount! + 1;
                        keyFieldValues.add('ε');
                        print(keyFieldValues);
                      }
                      if (epsilon! == false && epsilonCheck == true) {
                        epsilonCheck = false;
                        keyAmount = keyAmount! - 1;
                        keyFieldValues.remove('ε');
                        print(keyFieldValues);
                      }
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
      inputMap.clear();

      if (toState.length < stateAmount! * keyAmount!) {
        // Fill with empty lists if not enough elements
        toState = List.generate(stateAmount! * keyAmount!, (index) => []);
      }
      // Generate the transitionFieldList directly using nested loops
      List<Widget> transitionFieldList =
          List.generate(stateAmount!, (stateIndex) {
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
      faInstance.numAlphabets = keyAmount!;
      faInstance.numStates = stateAmount!;

      if (faInstance.X.contains('ε')) {
        faInstance.X.remove('ε');
      }

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
                    child: const Text("View FA"),
                    onPressed: () {
                      List<DataColumn> dataColumn = List.generate(
                        keyAmount!,
                        (index) => DataColumn(
                          label: Expanded(
                            child: Text(
                              keyFieldValues[index],
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      );

                      List<DataRow> dataRow = faInstance.T.entries
                          .where((entry) => keyFieldValues.every(
                              (inputKey) => entry.value.containsKey(inputKey)))
                          .map((entry) => DataRow(
                                cells: [
                                  DataCell(Text(entry.key)),
                                  ...keyFieldValues.map((inputKey) => DataCell(
                                      Text(entry.value[inputKey] ?? ''))),
                                ],
                              ))
                          .toList();

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("View FA",
                              style: TextStyle(color: Colors.deepPurple)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.deepPurple, width: 2),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columnSpacing: 35,
                                          columns: <DataColumn>[
                                            const DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            ...dataColumn,
                                          ],
                                          rows: dataRow,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text("Start State: $initialState"),
                                Text("Final State: $finalState"),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter a String to Test!',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  borderSide: const BorderSide(
                                                    color:
                                                        Colors.deepPurpleAccent,
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
                                      if (userInput != null ||
                                          userInput != "") {
                                        showDialog(
                                            context: context,
                                            builder:
                                                (context) =>
                                                    FractionallySizedBox(
                                                      heightFactor: 0.25,
                                                      alignment:
                                                          Alignment.center,
                                                      child: AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
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
                                                                            .isDFA() &&
                                                                        faInstance.checkDFA(userInput!) ==
                                                                            true)
                                                                      const Text(
                                                                        "STRING ACCEPTED !",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.deepPurple),
                                                                      )
                                                                    else if (faInstance
                                                                            .isDFA() &&
                                                                        faInstance.checkDFA(userInput!) ==
                                                                            false)
                                                                      const Text(
                                                                        "STRING REJECTED !",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.deepPurple),
                                                                      )
                                                                    else if (faInstance
                                                                            .checkNFA(userInput!) ==
                                                                        true)
                                                                      const Text(
                                                                        "STRING ACCEPTED !",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.deepPurple),
                                                                      )
                                                                    else
                                                                      const Text(
                                                                        "STRING REJECTED !",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.deepPurple),
                                                                      ),
                                                                  ]),
                                                            ]),
                                                      ),
                                                    ));
                                        if (faInstance.isDFA() == true) {
                                          print(
                                              faInstance.checkDFA(userInput!));
                                          print(userInput);
                                        } else {
                                          print(
                                              faInstance.checkNFA(userInput!));
                                          print(userInput);
                                        }
                                      }
                                    },
                                    child: const Text("Check!"),
                                  )
                                ]),
                          ),
                        ),
                      );
                    }),
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
                      FA copy = FA.copy(faInstance);
                      copy.convertToDFA();

                      List<DataColumn> copyColumn = List.generate(
                        copy.X.length,
                        (index) => DataColumn(
                          label: Expanded(
                            child: Text(
                              copy.X[index],
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      );

                      List<DataRow> copyRow = copy.T.entries
                          .where((entry) => copy.X.every(
                              (inputKey) => entry.value.containsKey(inputKey)))
                          .map((entry) => DataRow(
                                cells: [
                                  DataCell(Text(entry.key)),
                                  ...copy.X.map((inputKey) => DataCell(
                                      Text(entry.value[inputKey] ?? ''))),
                                ],
                              ))
                          .toList();

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("New DFA",
                              style: TextStyle(color: Colors.deepPurple)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.deepPurple, width: 2),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columnSpacing: 35,
                                          columns: <DataColumn>[
                                            const DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            ...copyColumn,
                                          ],
                                          rows: copyRow,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text("Start State: ${copy.S}"),
                                Text("Final State: ${copy.F}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
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
                      FA copy1 = FA.copy(faInstance);
                      copy1 = copy1.minimizeDFA();

                      List<DataColumn> copyColumn = List.generate(
                        copy1.X.length,
                        (index) => DataColumn(
                          label: Expanded(
                            child: Text(
                              copy1.X[index],
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      );

                      List<DataRow> copyRow = copy1.T.entries
                          .where((entry) => copy1.X.every(
                              (inputKey) => entry.value.containsKey(inputKey)))
                          .map((entry) => DataRow(
                                cells: [
                                  DataCell(Text(entry.key)),
                                  ...copy1.X.map((inputKey) => DataCell(
                                      Text(entry.value[inputKey] ?? ''))),
                                ],
                              ))
                          .toList();

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Minimized DFA",
                              style: TextStyle(color: Colors.deepPurple)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.deepPurple, width: 2),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                          columnSpacing: 35,
                                          columns: <DataColumn>[
                                            const DataColumn(
                                              label: Expanded(
                                                child: Text(
                                                  '',
                                                  style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic),
                                                ),
                                              ),
                                            ),
                                            ...copyColumn,
                                          ],
                                          rows: copyRow,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text("Start State: ${copy1.S}"),
                                Text("Final State: ${copy1.F}"),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ])
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
                        Text(
                          currentStep != 4
                              ? 'Enter Information!'
                              : 'Select a Feature!',
                          style: const TextStyle(
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
                            if (currentStep == 4) ...renderStep4(),
                            const SizedBox(height: 15),
                          ],
                        ),
                        buttonRow!,
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
