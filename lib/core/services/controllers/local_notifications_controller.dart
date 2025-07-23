
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationController {

  // TODO APRENDER SOBRE EL CHANNELKEY Y CHANNELNAME, TAMBIEN INVESTIGAR SOBRE EL ID Y LAS CONFIGURACIONES PARA ESO.
  
  Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      // todo aqui se define el icono de la notificacion
        null,
        [
          NotificationChannel(
              channelKey: 'Test notifications alertas',
              channelName: 'Test notifications',
              channelDescription: 'Notification tests para tasks',
              playSound: true,
              onlyAlertOnce: true,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);
  }

  // TODO Esto pedira al usuario el uso de notificaciones cada vez que se logee en la app
    // TODO debo cambiar la logica para que verifique si existe la preferencia allow notifications y que si no existe pregunte, si existe que no pida permisos.
  // TODO En teoria si esto funciona bien, sera llamado cada vez que se quiera crear una task para verificar si existe el permiso o no.
  static Future<void> checkAndRequestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  // TODO Modificar la logica para que se cree la notificacion solo si la preferencia de notificaciones esta activada
  static Future<void> createNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'Test notifications alertas',
        title: 'Hello Notification',
        body: 'This is a test notification',
      ),
    );
  }
  
  static Future<void> cancelReminderTask(int id) async {
    await AwesomeNotifications().cancel(id);
  }

  // TODO Modificar la logica para que se cree el scheduleReminderTask solo si la preferencia de notificaciones esta activada
  // TODO Modificar la logica para que se reciba un task y se cree con los campos importantes de este y su fecha y hora asignada.
  static Future<void> scheduleReminderTask() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 20,
        channelKey: 'Test notifications alertas',
        title: 'Scheduled Notification',
        body: 'This notification was scheduled to appear at a specific time',
      ),
      schedule: NotificationCalendar.fromDate(
        date: DateTime.now().add(Duration(minutes: 2)),
      ),
    );
  }
  
  
  
  
}