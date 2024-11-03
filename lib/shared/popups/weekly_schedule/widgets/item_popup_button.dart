import 'package:flutter/material.dart';

class ItemPopupButton extends StatelessWidget {
  /// This function is called when the edit button is pressed
  final void Function() onEdit;

  /// This function is called when the delete button is pressed
  final void Function() onDelete;

  const ItemPopupButton({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_WeeklyScheduleDialogGesture>(
      tooltip: "Optionen",
      initialValue: _WeeklyScheduleDialogGesture.none,
      onSelected: (_WeeklyScheduleDialogGesture gesture) async {
        switch (gesture) {
          case _WeeklyScheduleDialogGesture.edit:
            onEdit();
            break;
          case _WeeklyScheduleDialogGesture.delete:
            onDelete();
            break;
          case _WeeklyScheduleDialogGesture.none:
            break;
        }
      },
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<_WeeklyScheduleDialogGesture>>[
        const PopupMenuItem(
          value: _WeeklyScheduleDialogGesture.edit,
          child: Text('Bearbeiten'),
        ),
        const PopupMenuItem(
          value: _WeeklyScheduleDialogGesture.delete,
          child: Text('Löschen'),
        ),
      ],
    );
  }
}

enum _WeeklyScheduleDialogGesture {
  none,
  edit,
  delete;
}
