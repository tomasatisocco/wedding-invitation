import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:home_repository/home_repository.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/home/cubit/assistance_cubit.dart';
import 'package:wedding_invitation/home/cubit/home_cubit.dart';

class AssistancePage extends StatelessWidget {
  const AssistancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final invitation = context.read<HomeCubit>().state.invitation;
    if (invitation == null) return const SizedBox();

    return BlocProvider(
      create: (context) => AssistanceCubit(
        originalInvitation: invitation,
        homeRepository: context.read<HomeRepository>(),
      ),
      child: const AssistancePageView(),
    );
  }
}

class AssistancePageView extends StatelessWidget {
  const AssistancePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(64),
        const Text(
          'ASISTENCIA',
          style: TextStyle(
            fontSize: 40,
            color: ButtonColors.button1TextColor,
          ),
        ),
        const Gap(32),
        Image.asset(
          'assets/images/ready.png',
          height: 340,
        ),
        const Gap(32),
        BlocBuilder<AssistanceCubit, AssistanceState>(
          builder: (context, state) {
            final guests = state.invitation.guests ?? [];
            return Column(
              children: [
                ...guests.map((e) => GuestAssistance(guest: e)),
                const Gap(16),
                const ConfirmButton(),
              ],
            );
          },
        ),
        const Gap(32),
      ],
    );
  }
}

class GuestAssistance extends StatelessWidget {
  const GuestAssistance({
    required this.guest,
    super.key,
  });

  final Guest guest;

  @override
  Widget build(BuildContext context) {
    final isAttending = guest.isAttending;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SizedBox(
              width: 100,
              child: Text(
                guest.name ?? '',
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 20,
                  color: ButtonColors.button1TextColor,
                ),
              ),
            ),
          ),
          const Gap(8),
          AssistanceButton(
            text: 'Si',
            isActive: isAttending ?? false,
            onPressed: () async {
              final updatedGuest = guest.copyWith(isAttending: true);
              context.read<AssistanceCubit>().updateInvitation(updatedGuest);
            },
          ),
          const Gap(8),
          AssistanceButton(
            text: 'No',
            isActive: !(isAttending ?? true),
            onPressed: () async {
              final updatedGuest = guest.copyWith(isAttending: false);
              context.read<AssistanceCubit>().updateInvitation(updatedGuest);
            },
          ),
          const Gap(8),
          DropdownButton<DietaryPreference>(
            value: guest.dietaryPreference,
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            hint: const Text('Restricciones'),
            alignment: Alignment.center,
            items: DietaryPreference.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e.title),
                  ),
                )
                .toList(),
            onChanged: (value) async {
              final updatedGuest = guest.copyWith(dietaryPreference: value);
              context.read<AssistanceCubit>().updateInvitation(updatedGuest);
            },
          ),
        ],
      ),
    );
  }
}

class AssistanceButton extends StatelessWidget {
  const AssistanceButton({
    required this.text,
    required this.isActive,
    this.onPressed,
    super.key,
  });

  final String text;
  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive
            ? ButtonColors.button2FillColor
            : ButtonColors.button1FillColor,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AssistanceCubit>().state;
    final isEnabled = context.watch<AssistanceCubit>().confirmEnabled;
    return ElevatedButton(
      onPressed: !isEnabled
          ? null
          : () => context.read<AssistanceCubit>().confirmInvitation(),
      style: ElevatedButton.styleFrom(
        backgroundColor: ButtonColors.button2FillColor,
      ),
      child: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const SizedBox(
              height: 20,
              width: 100,
              child: Center(
                child: SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            );
          }
          if (state.isConfirmed) {
            return const Text(
              'Confirmado',
              style: TextStyle(color: Colors.white, fontSize: 20),
            );
          }
          return const Text(
            'Confirmar',
            style: TextStyle(color: Colors.white, fontSize: 20),
          );
        },
      ),
    );
  }
}

extension on DietaryPreference {
  String get title {
    return switch (this) {
      DietaryPreference.vegan => 'Vegano',
      DietaryPreference.celiac => 'Gluten Free',
      DietaryPreference.vegetarian => 'Vegetariano',
      DietaryPreference.none => 'Ninguna',
    };
  }
}
