import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zetesis/widgets/components/app_button.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );

  group('AppButton', () {
    testWidgets('mostra o label e dispara onPressed', (tester) async {
      var toques = 0;
      await tester.pumpWidget(
        wrap(AppButton(label: 'Entrar', onPressed: () => toques++)),
      );

      expect(find.text('Entrar'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      expect(toques, 1);
    });

    testWidgets('em loading, esconde o label e ignora toques', (tester) async {
      var toques = 0;
      await tester.pumpWidget(
        wrap(
          AppButton(label: 'Entrar', loading: true, onPressed: () => toques++),
        ),
      );

      expect(find.text('Entrar'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      expect(toques, 0);
    });

    testWidgets('com onPressed nulo, fica desabilitado', (tester) async {
      await tester.pumpWidget(
        wrap(const AppButton(label: 'Entrar', onPressed: null)),
      );

      final botao = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(botao.onPressed, isNull);
    });
  });
}
