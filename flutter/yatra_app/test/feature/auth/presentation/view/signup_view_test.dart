import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import 'package:yatra_app/feature/auth/presentation/view/signin_view.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:yatra_app/feature/auth/presentation/view_model/login_view_model/login_view_model.dart';

final serviceLocator = GetIt.instance;

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginViewModel {}

class FakeLoginState extends Fake implements LoginState {}

void main() {
  late MockLoginBloc loginBloc;

  setUpAll(() {
    registerFallbackValue(FakeLoginState());
  });

  setUp(() async {
    loginBloc = MockLoginBloc();

    await serviceLocator.reset();

    serviceLocator.registerSingleton<LoginViewModel>(loginBloc);

    when(() => loginBloc.state).thenReturn(
      const LoginState.initial().copyWith(isLoading: false),
    );
  });

  tearDown(() async {
    await serviceLocator.reset();
  });

  testWidgets('LoginScreen shows SIGN IN button', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignInView()));

    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, 'SIGN IN'), findsOneWidget);
  });
}
