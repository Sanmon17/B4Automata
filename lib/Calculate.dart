import 'dart:collection';

class StateSet {
  Set<int> states;

  StateSet() : states = {};

  void addState(int state) {
    states.add(state);
  }

  bool containsState(int state) {
    return states.contains(state);
  }

  int get size => states.length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateSet && runtimeType == other.runtimeType && states == other.states;

  @override
  int get hashCode => states.hashCode;
}

class NFA {
  int numStates;
  int alphabetSize;
  List<List<StateSet>> transitions;
  StateSet startStates;
  StateSet finalStates;

  NFA(this.numStates, this.alphabetSize)
      : transitions = List.generate(
            numStates, (_) => List.generate(alphabetSize, (_) => StateSet())),
        startStates = StateSet(),
        finalStates = StateSet();
}

class DFA {
  int numStates;
  int alphabetSize;
  List<List<int>> transitions;
  int startState;
  List<int> finalStates;

  DFA(this.numStates, this.alphabetSize)
      : transitions = List.generate(numStates, (_) => List.filled(alphabetSize, -1)),
        startState = -1,
        finalStates = [];
}



DFA nfaToDfa(NFA nfa) {
  DFA dfa = DFA(0, nfa.alphabetSize);
  Queue<StateSet> queue = Queue<StateSet>();
  Map<StateSet, int> stateMap = {};

  StateSet startStateSet = nfa.startStates;
  queue.add(startStateSet);
  stateMap[startStateSet] = dfa.numStates++;

  while (queue.isNotEmpty) {
    StateSet stateSet = queue.removeFirst();
    int stateIndex = stateMap[stateSet] ?? -1;

    for (int symbol = 0; symbol < nfa.alphabetSize; symbol++) {
      StateSet nextStates = StateSet();
      for (int state in stateSet.states) {
        nextStates.states.addAll(nfa.transitions[state][symbol].states);
      }

      if (!stateMap.containsKey(nextStates)) {
        queue.add(nextStates);
        stateMap[nextStates] = dfa.numStates++;
        dfa.transitions.add(List.filled(dfa.alphabetSize, -1));
      }

      int nextStateIndex = stateMap[nextStates] ?? -1;
      dfa.transitions[stateIndex][symbol] = nextStateIndex;
    }
  }

  dfa.startState = stateMap[startStateSet] ?? -1;
  for (StateSet stateSet in stateMap.keys) {
    int stateIndex = stateMap[stateSet] ?? -1;
    for (int state in stateSet.states) {
      if (nfa.finalStates.containsState(state)) {
        dfa.finalStates.add(stateIndex);
        break;
      }
    }
  }

  return dfa;
}

// nfa_to_dfa.dart