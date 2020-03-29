import 'package:flutter/material.dart';

class Compute extends ChangeNotifier {
  String calCur = '0', calHis = '';
  //var twentyFour, twentyFive, twentySix;
  var twentySix;
  //int flag = 0;
  List<String> post = List();
  String holder = '';
  String opStack = '';

  int top = -1;

  List<String> numberStack = List();
  double rightOprand, leftOprand;
  double result;

  RegExp re = RegExp(r'^[0-9]+$');

  void appendCalCur(var data) {
    if (calCur == '0') {
      calCur = data;
    } else
      calCur += data;
    notifyListeners();
  }

  //result() => twentySix;

  String getDisplay() => calCur;

  String getHistory() => calHis;

  void backspace() {
    if (calCur == '' || calCur.isEmpty)
      calCur = '0';
    else
      calCur = calCur.substring(0, calCur.length - 1);

    notifyListeners();
  }

  void pointRunner() {
    String test;
    test = calCur;
    for (int i = 0; i < test.length; i++) {
      if (re.hasMatch(test[i])) {
        holder += test[i];
      } else {
        post.add(holder);
        holder = '';
        stackCheck(test[i]);
      }
    }
    post.add(holder);
    if (opStack.isNotEmpty) {
      while (top != -1) {
        post.add(opStack[top]);
        --top;
      }
    }
    print(post);
    top = -1;
    rpnEvaluator();
  }

  void stackCheck(String c) {
    if (opStack.isEmpty) {
      opStack += c;
      top = opStack.length - 1;
    } else {
      if (precedence(opStack[top]) < precedence(c)) {
        opStack += c;
        top = opStack.length - 1;
      } else {
        while (opStack.length >= 1) {
          //print('top:' + opStack[top]);
          post.add(opStack[top]);
          //print('ppost:' + post);
          opStack = opStack.substring(0, top);
          //print('opstack: ' + opStack);
          //opStack += c;
          top = opStack.length - 1;
          //stackCheck(c);
        }
        opStack += c;
        top = opStack.length - 1;
      }
    }
  }

  int precedence(String pre) {
    switch (pre) {
      case '^':
        return 4;
      case '*':
        return 3;
      case '/':
        return 3;
      case '~':
        return 3;
      case '+':
        return 2;
      case '-':
        return 2;
      case '=':
        return 1;
      default:
        return 1;
    }
  }

  void rpnEvaluator() {
    for (int i = 0; i < post.length; i++) {
      print('Start of $i');
      if (re.hasMatch(post[i][0])) {
        numberStack.add(post[i]);
        //print(numberStack);
      } else {
        if (numberStack.isNotEmpty) {
          top = numberStack.length - 1;
          rightOprand = double.parse(numberStack[top]);
          leftOprand = double.parse(numberStack[top - 1]);
          result = calc(leftOprand, rightOprand, post[i]);

          //numberStack = numberStack.substring(0,numberStack.length - 2);
          numberStack.removeLast();
          //print(numberStack);
          numberStack.removeLast();
          //print(numberStack);
          numberStack.add(result.toString());
          //print('Number Stack after opration : ' + numberStack);
          //top = numberStack.length - 1;
        } else {
          //print('String Empty, something has gone wrong');
        }
      }
      //print('End of $i.');
    }
    print(numberStack);
    twentySix = numberStack[0].toString();
    calCur = calCur + '\n=' + twentySix;
    notifyListeners();
  }

  double calc(double lOprand, double rOprand, String op) {
    switch (op) {
      case '+':
        return lOprand + rOprand;
      case '-':
        return lOprand - rOprand;
      case '*':
        return lOprand * rOprand;
      case '/':
        return lOprand / rOprand;
      default:
        return 0.0;
    }
  }
}
