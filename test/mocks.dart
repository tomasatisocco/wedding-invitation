import 'package:admin_repository/admin_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';

class MockAdminRepository extends Mock implements AdminRepository {}

class MockAdminCubit extends MockCubit<AdminState> implements AdminCubit {}
