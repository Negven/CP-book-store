import 'dart:async';

import 'package:client/enum/global_event.dart';
import 'package:get/get.dart';

// Об'єкт для події з даними
class EventDto<T> {

  final GlobalEvent event; // Подія
  final T payload; // Дані

  EventDto(this.event, this.payload); // Конструктор
}

// Сервіс для подій
class EventsService extends GetxService {

  final _trigger = Rxn<EventDto>(); // Реактивний об'єкт події

  // Слухати подію
  StreamSubscription listen<T>(GlobalEvent event, Function(T payload) listener) {
    return _trigger.listen((eventDto) {
      if (eventDto != null && eventDto.event == event) listener.call(eventDto.payload); // Виклик слухача
    });
  }

  // Запустити подію
  trigger<T>(GlobalEvent event, T payload) {
    _trigger.value = EventDto(event, payload); // Встановити значення події
    _trigger.value = null; // Очистити значення події
  }
}
