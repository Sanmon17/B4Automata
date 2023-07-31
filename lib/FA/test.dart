// Copyright (c) 2017, Kevin Moore. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

// import 'package:gviz/gviz.dart';
import 'dart:convert';

// void main() {
//   final graph = Gviz();

//   for (var item in [
//     [1, 2],
//     [2, 5],
//     [5, 1],
//     [2, 6],
//     [5, 6],
//     [2, 3],
//     [6, 7],
//     [7, 6],
//     [3, 7],
//     [3, 4],
//     [4, 3],
//     [4, 8],
//     [8, 4],
//     [8, 7]
//   ]) {
//     final from = item[0].toString();
//     final to = item[1].toString();

//     if (item[0] % 2 == 1 && !graph.nodeExists(from)) {
//       graph.addNode(from, properties: {'color': 'red'});
//     }

//     graph.addEdge(from, to);
//   }

//   print(graph);
// }

List<Map<String, dynamic>> converter(List<Map<String, dynamic>> datas,
    List<String> header, List<String> states, Map<String, dynamic> startfinal) {
  //print("Data: $datas");

  final result = <Map<String, dynamic>>[];
  //header.removeLast();
  final newState = <String>[];
  final newPairState = <List<String>>[];
  final oldState = <String>[];
  newState.add('q0');
  oldState.add('q0');
  //check whether the start contains the ε
  if (datas[0]['ε'] == '') {
    newPairState.add(['q0']);
  } else {
    final ds = datas[0]['ε'].split(',');
    ds.add('q0');
    ds.sort();
    newPairState.add(ds);
  }
  //------
  while (newState.isNotEmpty) {
    final state = newState[0];
    newState.removeAt(0);
    final index = oldState.indexOf(state.trim());
    final pairState = newPairState[index];
    for (final symbol in header) {
      var newArr = <String>[];
      var newArr2 = <String>[];
      for (final pair in pairState) {
        final ind = states.indexOf(pair.trim());
        final inv = datas[ind][symbol];
        if (inv == '') {
          continue;
        }
        newArr.addAll(inv.split(','));
      }

      for (final pair in newArr) {
        try {
          final ind = states.indexOf(pair.trim());
          final inv = datas[ind]['ε'];
          newArr2.add(pair);
          if (inv != '') {
            newArr2.addAll(inv.split(','));
          }
        } catch (error) {
          print("something went wrong");
        }
      }
      newArr2 = newArr2.map((e) => e.trim()).toList();
      newArr2 = List.from(Set.from(newArr2));
      newArr2.sort();
      final ing = newPairState
          .indexWhere((ex) => jsonEncode(ex) == jsonEncode(newArr2));
      if (ing == -1) {
        result.add({
          'start': state == 'q0',
          'final':
              state == 'q0' ? false : pairState.contains(startfinal['final']),
          'value': state,
          symbol: 'q${newPairState.length}'
        });
        newState.add('q${newPairState.length}');
        oldState.add('q${newPairState.length}');
        newPairState.add(newArr2);
      } else {
        result.add({
          'start': state == 'q0',
          'final': pairState.contains(startfinal['final']),
          'value': state,
          symbol: oldState[ing]
        });
      }
    }
  }

  final mergeResult = List.generate(
      (result.length / header.length).ceil(),
      (index) => Map.fromEntries(result
          .sublist(index * header.length, (index + 1) * header.length)
          .expand((e) => e.entries)));

  return mergeResult;
}

void main() {
  // trasition is:'0' == start state, is:'1' == end state for empty state denote as '' or 'Ø'
  // final datas = [
  //   {'is': '0', 'state': 'q0', 'a': '', 'b': 'q1', 'ε': 'q2'},
  //   {'is': '1', 'state': 'q1', 'a': 'q1', 'b': 'q1', 'ε': 'q1'},
  //   {'is': '', 'state': 'q2', 'a': 'q1, q2', 'b': 'q2', 'ε': ''},
  // ];

  // // header is the symbol
  // final header = ['a', 'b'];
  // // states
  // final states = ['q0', 'q1', 'q2'];
  // //final states  and start states
  // final startfinal = {'start': 'q0', 'final': 'q1'};

  // final result = converter(datas, header, states, startfinal);
  // print(result);

  
  List<String> test = ['a', 'b', 'c'];
  String str = '';
  str = test.join(',');
  print(str);
}
