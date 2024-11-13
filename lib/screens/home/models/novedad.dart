class Novedad {
  final String icon, title, subtitle;
  final String? url;

  const Novedad({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.url,
  });

  factory Novedad.fromJson(Map<String, dynamic> json) => Novedad(
    icon: json['icon'],
    title: json['title'],
    subtitle: json['subtitle'],
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'icon': icon,
    'title': title,
    'subtitle': subtitle,
    'url': url,
  };

  static List<Novedad> fromJsonList(List<dynamic> json) => json.map((e) => Novedad.fromJson(e)).toList();
}