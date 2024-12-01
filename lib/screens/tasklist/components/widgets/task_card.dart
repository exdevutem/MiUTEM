
import 'package:flutter/material.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/core/models/Task/task.dart';
import 'package:skeletonizer/skeletonizer.dart';


class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCard({
    required this.task,
    required this.onDelete,
    super.key,
  });


  /**
   * Card de la lista
   * TODO modificar el diseño de la card despues de arreglar el modelo de card
   * TODO agregar color al ramo que corresponde la card
   *
   */
  @override
  Widget build(BuildContext context) {
    String mensaje = task.content;
    return GestureDetector(
      onTap: () {
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppTheme.lightGrey,
            width: 1,
          ),
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            // border: Border(
            //   left: BorderSide(color: getTipoColor(context, tipo), width: 8),
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon(
                //   getTipoIcon(tipo),
                //   weight: 700,
                //   color: getTipoTextColor(tipo),
                //   size: 25,
                // ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'titulo',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'message',
                              // style: StyleText.labelSmall.copyWith(
                              //   color: getEstadoTextColor(estado),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'asunto',
                        // style: StyleText.description.copyWith(
                        //   color: Theme.of(context).colorScheme.onPrimaryContainer,
                        // ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                      if (mensaje.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            mensaje,
                            // style: StyleText.body.copyWith(
                            //   color: AppTheme.darkGray,
                            // ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //   return Card(
  //     color: taskList.color,
  //     margin: const EdgeInsets.all(8),
  //     child: ListTile(
  //       title: Text(taskList.title),
  //       subtitle: Text(taskList.content),
  //       trailing: Skeleton.keep(child: IconButton(
  //         icon: const Icon(Icons.delete_forever_outlined),
  //         onPressed: onDelete,
  //       )),
  //       onTap: () => showDialog(
  //         context: context,
  //         builder: (context) => ViewTaskDialog(task: taskList),
  //       )
  //     ),
  //   );
  // }
}