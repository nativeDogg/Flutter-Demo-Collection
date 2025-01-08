import 'dart:async';

Completer<String> completer = Completer();

void someAsyncOperation() {
  // 模拟异步操作
  Future.delayed(Duration(seconds: 2), () {
    completer.complete('Result of async operation');
  });
}

void main() {
  int index = 0;
  someAsyncOperation();

  Timer.periodic(const Duration(milliseconds: 100), (_) {
    index++;

    if (index > 3) {
      print('我是index:$index');
      completer.future.then((result) {
        print(result); // 输出: Result of async operation
      });
    }
  });
}
