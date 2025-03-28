import 'package:banpay/common/result.dart';

abstract class Storage {
  String get name;

  Future<void> initialize();

  Future<EmptyResult> delete();
}
