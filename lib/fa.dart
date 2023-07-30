import 'dart:collection';
import 'dart:io';

/// TODO:
/// convert from NFA to DFA
/// minimize DFA
/// store in database

class FA {
  int numStates = 0, numAlphabets = 0;

  /// Set of States
  List<String> Q = [];

  /// Set of Alphabets
  List<String> X = [];

  /// Initial State
  String S = '';

  /// Final State
  String F = '';
  String currentState = '';

  /// Transition Table
  Map<String, Map<String, String>> T = {};

  FA();

  FA.copy(FA other) {
    // Copy the values from 'other' to the new instance
    // e.g., this.property = other.property;
    F = other.F;
    Q = other.Q;
    S = other.S;
    T = other.T;
    X = other.X;
  }

  void createDFA() {
    // input set of states
    print('Enter the numbers of states: ');
    numStates = int.parse(stdin.readLineSync()!);
    for (int i = 0; i < numStates; i++) {
      Q.add('q$i');
    }

    // input set of alphabets
    print('Enter the numbers of alphabets');
    numAlphabets = int.parse(stdin.readLineSync()!);
    for (int i = 0; i < numAlphabets; i++) {
      print('Enter alphabet ${i + 1}: ');
      String alphabet = '${stdin.readLineSync()}';
      X.add(alphabet);
    }

    // set start state
    print('Set start state from $Q: ');
    S = '${stdin.readLineSync()}';

    // set final state
    print('Set final state from $Q: ');
    F = '${stdin.readLineSync()}';

    // set of transitions
    for (int i = 0; i < numStates; i++) {
      Map<String, String> inputMap = {};
      for (int j = 0; j < numAlphabets; j++) {
        print('State ${Q[i]} transition by ${X[j]}: ');
        inputMap[X[j]] = stdin.readLineSync()!;
      }
      T['q$i'] = inputMap;

      // dfa.T = {
//   //   'q0': {'a': 'q1', 'b': 'q0'},
//   //   'q1': {'a': 'q1', 'b': 'q2'},
//   //   'q2': {'a': 'q3', 'b': 'q2'},
//   //   'q3': {'a': 'q3', 'b': 'q3'}
    }
  }

  bool checkDFA(String inputs) {
    // initialize currentState to start state
    currentState = S;

    // create iterator from input and iterate through it
    var symbol = inputs.split('').iterator;
    while (symbol.moveNext()) {
      // check if input exist in transition table and set currentState to new state through the input from table
      if (T[currentState]!.containsKey(symbol.current)) {
        currentState = T[currentState]![symbol.current]!;
      }
    }

    // check if currentState is equal to final state
    return currentState == F;
  }

  bool checkNFA(String inputs) {
    Set<String> currentState = {S};

    var symbol = inputs.split('').iterator;
    while (symbol.moveNext()) {
      Set<String> nextState = {};

      // Check for epsilon transitions
      Set<String> epsilonStates = {};
      for (var state in currentState.toList()) {
        if (T[state]!.containsKey('ε')) {
          epsilonStates.addAll(T[state]!['ε']!.split(','));
        }
      }
      currentState.addAll(epsilonStates);

      // iterate over current state and create grab new state transitions
      for (var state in currentState.toList()) {
        if (T[state]!.containsKey(symbol.current)) {
          nextState.addAll(T[state]![symbol.current]!.split(','));
        } else {
          nextState = currentState;
        }
      }

      currentState = nextState;
      // print('Current State: $currentState');
    }

    // check for epsilon transition
    Set<String> tempNextState = Set.from(currentState);
    while (tempNextState.isNotEmpty) {
      Set<String> epsilonStates = {};

      for (var state in tempNextState.toList()) {
        if (T[state]!.containsKey('ε')) {
          epsilonStates.addAll(T[state]!['ε']!.split(','));
        }
      }

      tempNextState = epsilonStates.difference(currentState);
      currentState.addAll(epsilonStates);
      // print('Current State (Epsilon): $currentState');
    }

    // check for acceptance
    for (var state in currentState) {
      if (F.contains(state)) {
        return true;
      }
    }

    return false;
  }

  bool isDFA() {
    for (var state in T.keys) {
      var symbols = T[state]!.keys.toList();

      // check that there are transition for each input symbol
      var uniqueSymbol = Set<String>.from(symbols);
      if (symbols.length != uniqueSymbol.length) {
        return false;
      }

      // check for epsilon transition
      if (symbols.contains('ε')) {
        return false;
      }

      // check if one input have multiple transitions
      for (var symbol in symbols) {
        if (T[state]![symbol]!.contains(',')) {
          return false;
        }
      }
    }

    return true;
  }

  void convertToDFA() {
    // create new transistion table for DFA
    Map<String, Map<String, String>> dfaTransition = {};

    List<Set<String>> dfaStates = [
      {S}
    ];

    Queue<Set<String>> queue = Queue<Set<String>>();
    queue.addAll(dfaStates);

    int newState = 0;
    Map<String, String> mapState = {'{$S}': 'q$newState'};

    // using BFS(BreadthFirst Search) algorithm
    while (queue.isNotEmpty) {
      Set<String> currentState = queue.removeFirst();
      // print('CurrentState: $currentState');

      Map<String, String> inputMap = {};
      // dfaTransition[currentState.join(',')] = inputMap;
      dfaTransition[mapState[currentState.toString()]!] = inputMap;

      for (String symbol in X) {
        Set<String> nextState = {};

        for (String state in currentState) {
          if (state == '') {
            // continue;
            nextState.add('');
          } else {
            if (T[state]!.containsKey(symbol)) {
              nextState.addAll(T[state]![symbol]!.split(','));
            }

            if (nextState.length > 1) {
              nextState.remove('');
            }

            if (T[state]!.containsKey('ε')) {
              // print('State: $state');
              if (T[state]![symbol] == '') {
                nextState.remove('');
                nextState.addAll(getEpsilonClosure({state}));
              } else {
                nextState.addAll(getEpsilonClosure({state}));
              }
            }
          }
        }

        if (nextState.isNotEmpty) {
          // print('Next State: $nextState');
          bool isNewState = true;
          for (Set<String> state in dfaStates) {
            if (state.length == nextState.length &&
                state.difference(nextState).isEmpty) {
              // State already exists, no need to add it
              isNewState = false;
              break;
            }
          }

          if (isNewState) {
            newState++;
            mapState[nextState.toString()] = 'q$newState';
            dfaStates.add(nextState);
            queue.add(nextState);
            // print('Map States: $mapState');
            // print('Dfa state: $dfaStates');
          }

          // inputMap[symbol] = nextState.join(',');
          inputMap[symbol] = mapState[nextState.toString()]!;
          // print('Input[$currentState][$symbol]: ${inputMap[symbol]}');
          print(
              'Input[${mapState['$currentState']}][$symbol]: ${inputMap[symbol]}');
        }
      }
    }

    List<String> newFinalStates = [];
    T = dfaTransition;
    numStates = dfaStates.length;
    for (var state in dfaStates) {
      if (state.contains(F)) {
        newFinalStates.add(mapState[state.toString()]!);
      }
    }
    F = newFinalStates.join(',');
    print('Final State: $F');
  }

  Set<String> getEpsilonClosure(Set<String> states) {
    // Set<String> closure = Set.from(states);
    Set<String> closure = {};

    Queue<String> queue = Queue.from(states);
    while (queue.isNotEmpty) {
      String state = queue.removeFirst();

      if (T[state]!.containsKey('ε')) {
        Set<String> epsilonStates = T[state]!['ε']!.split(',').toSet();

        epsilonStates.removeAll(closure);
        closure.addAll(epsilonStates);
        queue.addAll(epsilonStates);
        // print('Closure: $closure');
      }
    }

    return closure;
  }
}

void main(List<String> arguments) {
  // FA dfa = FA();

  // // dfa.createDFA();
  // dfa.Q = ['q0', 'q1', 'q2', 'q3'];
  // dfa.X = ['a', 'b'];
  // dfa.S = 'q0';
  // dfa.F = 'q3';
  // dfa.T = {
  //   'q0': {'a': 'q1', 'b': 'q0'},
  //   'q1': {'a': 'q1', 'b': 'q2'},
  //   'q2': {'a': 'q3', 'b': 'q2'},
  //   'q3': {'a': 'q3', 'b': 'q3'}
  // };

  // if (dfa.checkDFA('abab')) {
  //   print('accept');
  // } else {
  //   print('rejected');
  // }
  // print(dfa.isDFA());

  // accept if there are abb
  FA nfa = FA();

  nfa.Q = ['q0', 'q1', 'q2', 'q3'];
  nfa.X = ['a', 'b'];
  nfa.S = 'q0';
  nfa.F = 'q3';
  nfa.T = {
    'q0': {'a': 'q0,q1', 'b': 'q0'},
    'q1': {'a': '', 'b': 'q2'},
    'q2': {'a': '', 'b': 'q3'},
    'q3': {'a': 'q3', 'b': 'q3'},
  };

  print('NFA 1');
  nfa.convertToDFA();
  print(nfa.isDFA());

  nfa.Q = ['q0', 'q1', 'q2'];
  nfa.X = ['a', 'b'];
  nfa.S = 'q0';
  nfa.F = 'q1';
  nfa.T = {
    'q0': {'a': '', 'b': 'q1', 'ε': 'q2'},
    'q1': {'a': 'q1', 'b': 'q1', 'ε': 'q1'},
    'q2': {'a': 'q1,q2', 'b': 'q2'},
  };

  print('NFA 2');
  nfa.convertToDFA();
  print(nfa.isDFA());

  nfa.Q = ['q0', 'q1', 'q2', 'q3', 'q4'];
  nfa.X = ['a', 'b'];
  nfa.S = 'q0';
  nfa.F = 'q4';
  nfa.T = {
    'q0': {'a': 'q1', 'b': ''},
    'q1': {'a': '', 'b': 'q2'},
    'q2': {'a': 'q2', 'b': 'q2,q3'},
    'q3': {'a': 'q4', 'b': ''},
    'q4': {'a': '', 'b': ''}
  };

  // print(nfa.checkNFA('abbab'));
  // print(nfa.isDFA());
  // print(nfa.T);

  print('NFA 3');
  nfa.convertToDFA();
  print(nfa.isDFA());
  // print('Start State: ${nfa.S}');
  // print('Final State: ${nfa.F}');
  // print('Transitions: ${nfa.T}');

  // print(nfa.checkDFA('abb'));

  FA nfa2 = FA();

  // accept when none or more {a,b,c}
  nfa2.Q = ['q0', 'q1', 'q2'];
  nfa2.X = ['a', 'b', 'c'];
  nfa2.S = 'q0';
  nfa2.F = 'q2';
  nfa2.T = {
    'q0': {'a': 'q0', 'b': '', 'c': '', 'ε': 'q1'},
    'q1': {'a': '', 'b': 'q1', 'c': '', 'ε': 'q2'},
    'q2': {'a': '', 'b': '', 'c': 'q2'},
  };

  print('NFA 4');
  // print(nfa2.checkNFA(''));
  nfa2.convertToDFA();
  print(nfa2.isDFA());

  // // accept when there are aa or bb
  nfa2.S = 'q0';
  nfa2.F = 'q5';
  nfa2.T = {
    'q0': {'a': '', 'b': '', 'ε': 'q1,q3'},
    'q1': {'a': 'q2', 'b': ''},
    'q2': {'a': 'q2,q5', 'b': 'q2'},
    'q3': {'a': '', 'b': 'q4'},
    'q4': {'a': 'q4', 'b': 'q4,q5'},
    'q5': {'a': '', 'b': ''}
  };

  print('NFA 5');
  // print(nfa2.checkNFA('aab'));
  nfa2.convertToDFA();
  print(nfa2.isDFA());
}
