import 'package:client/classes/sizes.dart';
import 'package:flutter/material.dart';

// Абстрактний клас для сторінки додатку
abstract class AppPage extends StatelessWidget {

  const AppPage({super.key}); // Конструктор

  @override
  Widget build(BuildContext context) {
    // Повернення одиночного віджету з прокруткою і вмістом сторінки
    return SingleChildScrollView(
        child: content(context)
    );
  }

  // Абстрактний метод для вмісту сторінки
  Widget content(BuildContext context);

}

// Клас для вмісту додатку
class AppContent extends StatelessWidget {

  final Map<int, WidgetBuilder> builders;
  const AppContent(this.builders, {super.key}); // Конструктор

  @override
  Widget build(BuildContext context) {
    // Перевірка доступних Builder і виклик першого доступного
    for (var column = sizes.content.columns; column > 0; column--) {
      var builder = builders[column];
      if (builder != null) {
        return builder(context);
      }
    }

    throw 'Builder not found'; // Викидання помилки, якщо Builder не знайдений
  }

}
