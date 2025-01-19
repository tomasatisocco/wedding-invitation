import 'package:admin_repository/admin_repository.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';

class ExcelButton extends StatefulWidget {
  const ExcelButton({super.key});

  @override
  State<ExcelButton> createState() => _ExcelButtonState();
}

class _ExcelButtonState extends State<ExcelButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: downloadExcel,
      icon: const Icon(Icons.web_asset_rounded),
    );
  }

  void downloadExcel() {
    try {
      final invitations = context.read<AdminCubit>().state.invitations ?? [];
      final guests = invitations.expand((e) => e.guests ?? <Guest>[]).toList();
      final confirmed = guests.where((e) => e.isAttending != null).toList();
      final assistants = guests.where((e) => e.isAttending ?? false).toList();
      final declined = guests.where((e) => e.isAttending == false).toList();
      final missing = guests.where((e) => e.isAttending == null).toList();
      final dietary = guests
          .where((e) => e.dietaryPreference != DietaryPreference.none)
          .toList();
      final excel = Excel.createExcel();

      createSheet(excel, 'Guests', guests, invitations);
      createSheet(excel, 'Confirmed', confirmed, invitations);
      createSheet(excel, 'Assistants', assistants, invitations);
      createSheet(excel, 'Declined', declined, invitations);
      createSheet(excel, 'Missing', missing, invitations);
      createSheet(excel, 'Dietary', dietary, invitations);

      excel
        ..setDefaultSheet('Guests')
        ..save(fileName: 'wedding_invitations.xlsx');
    } catch (_) {}
  }

  void createSheet(
    Excel excel,
    String name,
    List<Guest> guests,
    List<Invitation> invitations,
  ) {
    addTitles(excel, name);
    for (final guest in guests) {
      final invitation =
          invitations.firstWhere((e) => e.guests?.contains(guest) ?? false);
      excel.appendRow(name, [
        TextCellValue(guest.name ?? ''),
        TextCellValue(invitation.id ?? ''),
        BoolCellValue(guest.isAttending ?? false),
        BoolCellValue(guest.isAttending ?? false),
        TextCellValue(guest.dietaryPreference?.name ?? ''),
      ]);
    }
  }

  void addTitles(Excel excel, String name) {
    excel.appendRow(name, [
      TextCellValue('Name'),
      TextCellValue('Invitation ID'),
      TextCellValue('Assistance'),
      TextCellValue('Confirmed'),
      TextCellValue('Dietary Preference'),
    ]);
  }
}
