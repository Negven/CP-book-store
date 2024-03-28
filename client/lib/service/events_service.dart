

import 'dart:async';

import 'package:client/enum/global_event.dart';
import 'package:get/get.dart';


class EventDto<T> {

  final GlobalEvent event;
  final T payload;

  EventDto(this.event, this.payload);

}


class EventsService extends GetxService {

  final _trigger = Rxn<EventDto>();

  StreamSubscription listen<T>(GlobalEvent event, Function(T payload) listener) {
    return _trigger.listen((eventDto) {
      if (eventDto != null && eventDto.event == event) listener.call(eventDto.payload);
    });
  }

  triggerSimple(GlobalEvent event) => trigger(event, event);

  trigger<T>(GlobalEvent event, T payload) {
    _trigger.value = EventDto(event, payload);
    _trigger.value = null;
  }


  @override
  void onClose() {
    _trigger.close();
  }

}
