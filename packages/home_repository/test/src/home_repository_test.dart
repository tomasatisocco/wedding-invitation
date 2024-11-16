// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:home_repository/home_repository.dart';

void main() {
  group('HomeRepository', () {
    test('can be instantiated', () {
      expect(HomeRepository(), isNotNull);
    });
  });
}
