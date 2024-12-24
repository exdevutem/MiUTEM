import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AppIcons {
  /// Iconos de la barra de navegación.
  static const IconData home = Symbols.home_rounded;
  static const IconData subjects = Symbols.book_2_rounded;
  static const IconData subjectsMarker = Symbols.book_rounded;
  static const IconData updates = Symbols.notifications_rounded;
  static const IconData profile = Symbols.person_rounded;
  static const IconData notes = Symbols.note_stack_rounded;
  /// Iconos de accesos rápidos
  static const IconData timetable = Symbols.calendar_month_rounded;
  static const IconData historicTimetable = Symbols.calendar_clock_rounded;
  static const IconData grades = Symbols.book;
  static const IconData calculator = Symbols.calculate_rounded;
  static const IconData idea = Symbols.lightbulb_rounded;
  /// Iconos para acciones
  static const IconData location = Symbols.location_on_rounded;
  static const IconData mail = Symbols.alternate_email_rounded;
  static const IconData password = Symbols.key_rounded;
  static const IconData delete = Symbols.delete_rounded;
  static const IconData settings = Symbols.settings_rounded;
  static const IconData dropdown = Symbols.keyboard_arrow_down_rounded;
  static const IconData add = Symbols.add_rounded;
  static const IconData close = Symbols.close_rounded;
  static const IconData more = Symbols.more_vert_rounded;
  static const IconData edit = Symbols.edit_rounded;
  static const IconData refresh = Symbols.refresh_rounded;
  static const IconData error = Symbols.error_rounded;

  static const _iconMap = {
    'home': home,
    'subjects': subjects,
    'subjectsMarker': subjectsMarker,
    'updates': updates,
    'profile': profile,
    'notes': notes,
    'timetable': timetable,
    'historicTimetable': historicTimetable,
    'grades': grades,
    'calculator': calculator,
    'idea': idea,
    'location': location,
    'mail': mail,
    'password': password,
    'delete': delete,
    'settings': settings,
    'dropdown': dropdown,
    'add': add,
    'close': close,
    'more': more,
    'edit': edit,
    'refresh': refresh,
    'error': error,
  };

  static IconData getIcon(String name) => _iconMap[name] ?? error;
}