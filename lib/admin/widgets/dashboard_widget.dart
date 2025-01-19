import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';

class DashboardWidget extends StatelessWidget {
  const DashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TotalInvitations(),
      ],
    );
  }
}

class TotalInvitations extends StatelessWidget {
  const TotalInvitations({super.key});

  @override
  Widget build(BuildContext context) {
    final invitations = context.read<AdminCubit>().state.invitations;
    final invitedPeople =
        invitations?.expand((e) => e.guests ?? <Guest>[]).toList();
    final confirmed =
        invitedPeople?.where((e) => e.isAttending ?? false).toList();
    final declined =
        invitedPeople?.where((e) => e.isAttending == false).toList();
    final missing = invitedPeople?.where((e) => e.isAttending == null).toList();
    final preferences = invitedPeople
        ?.where((e) =>
            e.dietaryPreference != null &&
            e.dietaryPreference != DietaryPreference.none)
        .toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Indicator(
              label: 'Guests',
              value: invitedPeople?.length.toString(),
              guests: invitedPeople,
            ),
            const Gap(32),
            Indicator(
              label: 'Invites',
              value: invitations?.length.toString(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Indicator(
              label: 'Confirm',
              value: confirmed?.length.toString(),
              guests: confirmed,
            ),
            const Gap(32),
            Indicator(
              label: 'Decline',
              value: declined?.length.toString(),
              guests: declined,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Indicator(
              label: 'Missing',
              value: missing?.length.toString(),
              guests: missing,
            ),
            const Gap(32),
            Indicator(
              label: 'Dietary',
              value: preferences?.length.toString(),
              guests: preferences,
              showDietary: true,
            ),
          ],
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    required this.label,
    required this.value,
    this.showDietary = false,
    this.guests,
    super.key,
  });

  final String label;
  final String? value;
  final bool showDietary;
  final List<Guest>? guests;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: guests != null ? () async => showGuests(context) : null,
      child: Column(
        children: [
          Text(
            value ?? '0',
            style: const TextStyle(
              fontSize: 32,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showGuests(BuildContext context) async {
    final guest = guests ?? [];
    await showDialog<void>(
      context: context,
      useRootNavigator: false,
      builder: (iContext) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: guest.map(
                (e) {
                  final invitation =
                      context.read<AdminCubit>().guestInvitation(e.id);
                  return GuestWidget(
                    guest: e,
                    invitation: invitation,
                    onSelect: (e) {
                      context.read<AdminCubit>().selectByGuest(e);
                    },
                    showDietary: showDietary,
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}

class GuestWidget extends StatelessWidget {
  const GuestWidget({
    required this.guest,
    required this.onSelect,
    required this.showDietary,
    this.invitation,
    super.key,
  });

  final Guest guest;
  final Invitation? invitation;
  final bool showDietary;
  final void Function(Guest guest) onSelect;

  @override
  Widget build(BuildContext context) {
    final title =
        '${guest.name} | ${invitation?.id} ${showDietary ? '| ${guest.dietaryPreference?.name}' : ''}';
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        onSelect(guest);
      },
    );
  }
}
