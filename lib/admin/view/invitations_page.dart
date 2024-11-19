import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';
import 'package:wedding_invitation/admin/widgets/invitation_widget.dart';
import 'package:wedding_invitation/app_colors.dart';

class InvitationsPage extends StatelessWidget {
  const InvitationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state.isError) {
            return const Center(
              child: Text('Error'),
            );
          }
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final invitations = state.invitations ?? [];
          return Row(
            children: [
              SizedBox(
                width: 150,
                child: Column(
                  children: [
                    IconButton(
                      onPressed: () => addInvitation(context),
                      icon: const Icon(Icons.add),
                    ),
                    const Gap(16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: invitations.length,
                      itemBuilder: (context, index) {
                        final invitation = invitations[index];
                        return ListTile(
                          title: Text(invitation.id ?? ''),
                          tileColor: invitation == state.selectedInvitation
                              ? ButtonColors.button1FillColor
                              : ButtonColors.button2FillColor,
                          onTap: () {
                            context
                                .read<AdminCubit>()
                                .selectInvitation(invitation);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: state.selectedInvitation != null
                    ? const InvitationWidget()
                    : const Center(child: Text('Select an invitation')),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> addInvitation(BuildContext context) async {
    final id = await showDialog<String?>(
      context: context,
      builder: (context) {
        String? string;
        return AlertDialog(
          title: const Text('Add invitation'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Invitation ID',
            ),
            onChanged: (value) => {
              string = value,
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, string),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
    if (id != null) {
      if (!context.mounted) return;
      await context.read<AdminCubit>().addInvitation(Invitation(id: id));
    }
  }
}