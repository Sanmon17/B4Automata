import 'dart:collection';
import 'dart:io';

/// TODO:
/// convert from NFA to DFA | send help PLS :(
/// minimize DFA
/// store in database (Maybe)

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
        if (T[state]!.containsKey('')) {
          epsilonStates.addAll(T[state]!['']!.split(','));
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
        if (T[state]!.containsKey('')) {
          epsilonStates.addAll(T[state]!['']!.split(','));
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
      if (symbols.contains('')) {
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
    Map<String, Map<String, String>> dfaTransition = {};

    Set<String> dfaStates = {S};

    Queue<Set<String>> queue = Queue<Set<String>>();
    queue.add(dfaStates);

    while (queue.isNotEmpty) {
      Set<String> currentState = queue.removeFirst();
      print('CurrentState: $currentState');

      Map<String, String> inputMap = {};
      dfaTransition[currentState.join(',')] = inputMap;
      // dfaTransition['q$newDFAState'] = inputMap;

      for (String symbol in X) {
        Set<String> nextState = {};

        for (String state in currentState) {
          if (T[state]!.containsKey(symbol)) {
            nextState.addAll(T[state]![symbol]!.split(','));
            // print('[$state, $symbol]: $nextState');
          }
        }

        Set<String> epsilonClosure = getEpsilonClosure(nextState);
        nextState.addAll(epsilonClosure);

        if (nextState.isNotEmpty) {
          inputMap[symbol] = nextState.join(',');
          print('Next State: ${nextState.join(',')}');
          // print('Input[$dfaStates][$symbol]: $inputMap');

          if (!dfaStates.containsAll(nextState)) {
            dfaStates.addAll(nextState);
            print('DFA States: $dfaStates');
            queue.add(nextState);
            // print('Next State: $queue');
          }
        }
      }
    }

    // print(dfaTransition);
    T = dfaTransition;
    numStates = dfaStates.length;
  }

  Set<String> getEpsilonClosure(Set<String> states) {
    Set<String> closure = Set.from(states);

    Queue<String> queue = Queue.from(states);
    while (queue.isNotEmpty) {
      String state = queue.removeFirst();

      if (T[state]!.containsKey('')) {
        Set<String> epsilonStates = T[state]!['']!.split(',').toSet();

        epsilonStates.removeAll(closure);
        closure.addAll(epsilonStates);
        queue.addAll(epsilonStates);
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
    'q1': {'b': 'q2'},
    'q2': {'b': 'q3'},
    'q3': {'a': 'q3', 'b': 'q3'},
  };

  // print(nfa.checkNFA('abb'));
  // print(nfa.isDFA());

  nfa.convertToDFA();
  // print(nfa.checkDFA('abb'));

  // FA nfa2 = FA();

  // // accept when none or more {a,b,c}
  // nfa2.Q = ['q0', 'q1', 'q2'];
  // nfa2.X = ['a', 'b', 'c'];
  // nfa2.S = 'q0';
  // nfa2.F = 'q2';
  // nfa2.T = {
  //   'q0': {'a': 'q0', '': 'q1'},
  //   'q1': {'b': 'q1', '': 'q2'},
  //   'q2': {'c': 'q2'},
  // };

  // print(nfa2.checkNFA(''));
  // print(nfa2.isDFA());

  // // accept when there are aa or bb
  // nfa2.S = 'q0';
  // nfa2.F = 'q5';
  // nfa2.T = {
  //   'q0': {'': 'q1,q3'},
  //   'q1': {'a': 'q2'},
  //   'q2': {'a': 'q2,q5', 'b': 'q2'},
  //   'q3': {'b': 'q4'},
  //   'q4': {'a': 'q4', 'b': 'q4,q5'},
  //   'q5': {}
  // };

  // print(nfa2.checkNFA('aab'));
  // print(nfa2.isDFA());
}
