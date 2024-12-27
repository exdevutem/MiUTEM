/// Representa un file que esta dentro de un APUNTE
class TaskFile {
  final String name;
  final String type;
  final String path;

  TaskFile({
    required this.name,
    required this.type,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'type': type,
    'path': path,
  };

  factory TaskFile.fromJson(Map<String, dynamic> json) => TaskFile(
    name: json['name'],
    type: json['type'],
    path: json['path'],
  );
}