import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/models/horario.dart';
import '../../core/models/preferencia.dart';
import '../../core/services/horario_service.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/http/functions.dart';

class HorarioScreen extends StatefulWidget {
    const HorarioScreen({super.key});

    @override
    State<HorarioScreen> createState() => _HorarioScreenState();
}

class _HorarioScreenState extends State<HorarioScreen> {
    bool _forceRefresh = false;
    Horario? _horario;
    bool _loading = false;

    @override
    void initState() {
        super.initState();
        /// No entendi donde se cargaba el offline, dejare esto por mientras pero hay que cambiar
        isOffline().then((isOffline) => Preferencia.isOffline.set(isOffline ? 'true' : 'false'), onError: (err) => Preferencia.isOffline.set('true'));
        _loadHorario();
    }

    /// Cargando horario
    Future<void> _loadHorario() async {
        setState(() => _loading = true);
        try {
            final horario = await Get.find<HorarioService>().getHorario(forceRefresh: _forceRefresh);
            setState(() => _horario = horario);
            _logHorario();
        } catch (e) {
            logger.e(e);
        } finally {
            setState(() => _loading = false);
        }
    }

    /// Refresh
    Future<void> _refresh() async {
        await _loadHorario();
    }

    void _logHorario() {
        final _horario = this._horario;
        if(_horario != null) {
            for (var i = 0; i < _horario.horario!.length; i++) {
                for (var j = 0; j < _horario!.horario![i].length; j++) {
                    final bloque = _horario!.horario?[i][j];
                    if(bloque?.asignatura != null) {
                        logger.i('Bloque: $i, $j - ${bloque?.asignatura!.nombre}');
                    }
                }
            }
        }
    }

    @override
    void dispose() {
        /// todo Implementar la logica de dispose
        super.dispose();
    }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: const Text('Horario'),
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : _horario == null
                ? const Center(child: Text('No se pudo cargar el horario'))
                : _buildHorarioGrid(),
        );
    }

    Widget _buildHorarioGrid() {
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, // Número de días
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
            ),
            itemCount: 18 * 6, // Número de bloques
            itemBuilder: (context, index) {
                final diaIdx = index % 6;
                final bloqueIdx = index ~/ 6;
                final bloque = _horario!.horario?[bloqueIdx][diaIdx];
                return Card(
                    child: ListTile(
                        title: Text(bloque?.asignatura?.nombre ?? 'Libre'),
                        subtitle: Text(bloque?.sala ?? ''),
                    ),
                );
            },
        );
    }


}