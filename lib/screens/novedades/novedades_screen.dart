import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/noticia.dart";
import "package:miutem/core/services/firebase/remote_config_service.dart";
import "package:miutem/core/services/noticias_service.dart";
import "package:miutem/screens/home/models/novedad.dart";
import "package:miutem/screens/home/widgets/novedades/card_novedades.dart";
import "package:url_launcher/url_launcher_string.dart";

class NovedadesScreen extends StatelessWidget {
	const NovedadesScreen({super.key});

	@override
	Widget build(BuildContext context) {
		final novedades = Get.find<RemoteConfigService>().fetchNovedades().toList();

		return Scaffold(
			appBar: AppBar(title: const Text("Novedades")),
			body: Padding(
				padding: const EdgeInsets.all(16),
				child: SingleChildScrollView(
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							_SeccionNovedadesRemotas(novedades: novedades),
							const SizedBox(height: 20),
							const SeccionNoticias(),
						],
					),
				),
			),
		);
	}
}

class _SeccionNovedadesRemotas extends StatelessWidget {
	final List<Novedad> novedades;

	const _SeccionNovedadesRemotas({required this.novedades});

	@override
	Widget build(BuildContext context) {
		if (novedades.isEmpty) {
			return const SizedBox.shrink();
		}

		return Column(
			crossAxisAlignment: CrossAxisAlignment.start,
			children: [
				CardNovedades(novedad: novedades.first),
			],
		);
	}
}

class SeccionNoticias extends StatefulWidget {
	const SeccionNoticias({super.key});

	@override
	State<SeccionNoticias> createState() => _SeccionNoticiasState();
}

class _SeccionNoticiasState extends State<SeccionNoticias> {
	final NoticiasService _noticiasService = NoticiasService();
	late final Future<List<Noticia>> _noticiasFuture;

	@override
	void initState() {
		super.initState();
		_noticiasFuture = _noticiasService.getNoticias();
	}

	@override
	Widget build(BuildContext context) {
		return FutureBuilder<List<Noticia>>(
			future: _noticiasFuture,
			builder: (context, snapshot) {
				if (snapshot.connectionState == ConnectionState.waiting) {
					return const SizedBox(
						height: 220,
						child: Center(
							child: CircularProgressIndicator(),
						),
					);
				}

				if (snapshot.hasError) {
					return const SizedBox.shrink();
				}

				final noticias = snapshot.data ?? <Noticia>[];
				if (noticias.isEmpty) {
					return const SizedBox.shrink();
				}

				return Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						Text(
							"Noticias",
							style: Theme.of(context).textTheme.bodyLarge?.copyWith(
								fontWeight: FontWeight.bold,
							),
						),
						const SizedBox(height: 12),
						SizedBox(
							height: 240,
							child: ListView.builder(
								scrollDirection: Axis.horizontal,
								itemCount: noticias.length,
								itemBuilder: (context, index) {
									final noticia = noticias[index];
									return Padding(
										padding: EdgeInsets.only(
											right: index == noticias.length - 1 ? 0 : 12,
										),
										child: _NoticiaCard(noticia: noticia),
									);
								},
							),
						),
					],
				);
			},
		);
	}
}

class _NoticiaCard extends StatelessWidget {
	final Noticia noticia;

	const _NoticiaCard({required this.noticia});

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			onTap: () async {
				final opened = await launchUrlString(noticia.link, mode: LaunchMode.externalApplication);
				if (!opened && context.mounted) {
					ScaffoldMessenger.of(context).showSnackBar(
						const SnackBar(content: Text("No se pudo abrir la noticia")),
					);
				}
			},
			child: SizedBox(
				width: 200,
				child: Card(
					margin: EdgeInsets.zero,
					elevation: 0,
					clipBehavior: Clip.antiAlias,
					shape: RoundedRectangleBorder(
						borderRadius: BorderRadius.circular(16),
						side: BorderSide(color: Theme.of(context).dividerColor),
					),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							SizedBox(
								height: 130,
								width: double.infinity,
								child: Image.network(
									noticia.imagen,
									fit: BoxFit.cover,
									loadingBuilder: (context, child, loadingProgress) {
										if (loadingProgress == null) {
											return child;
										}
										return const Center(child: CircularProgressIndicator());
									},
									errorBuilder: (context, error, stackTrace) {
										return Container(
											color: Theme.of(context).colorScheme.surfaceContainerHighest,
											alignment: Alignment.center,
											child: Icon(
												Icons.image_not_supported_outlined,
												color: Theme.of(context).colorScheme.onSurfaceVariant,
											),
										);
									},
								),
							),
							Padding(
								padding: const EdgeInsets.all(12),
								child: Text(
									noticia.titulo,
									maxLines: 3,
									overflow: TextOverflow.ellipsis,
									style: Theme.of(context).textTheme.bodyMedium?.copyWith(
										fontWeight: FontWeight.w600,
									),
								),
							),
						],
					),
				),
			),
		);
	}
}
