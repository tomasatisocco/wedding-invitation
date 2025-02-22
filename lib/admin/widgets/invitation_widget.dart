import 'package:admin_repository/admin_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/v4.dart';
import 'package:wedding_invitation/admin/cubit/admin_cubit.dart';
import 'package:wedding_invitation/admin/cubit/invitation_cubit.dart';
import 'package:wedding_invitation/app_colors.dart';
import 'package:wedding_invitation/l10n/l10n.dart';

class InvitationWidget extends StatelessWidget {
  const InvitationWidget({
    required this.invitation,
    super.key,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: Key(invitation.id ?? ''),
      create: (context) => InvitationCubit(
        adminRepository: context.read<AdminRepository>(),
        invitation: invitation,
      ),
      child: const InvitationWidgetView(),
    );
  }
}

class InvitationWidgetView extends StatefulWidget {
  const InvitationWidgetView({super.key});

  @override
  State<InvitationWidgetView> createState() => _InvitationWidgetViewState();
}

class _InvitationWidgetViewState extends State<InvitationWidgetView> {
  late TextEditingController noteController;
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    final invitation = context.read<InvitationCubit>().state.actualInvitation;
    noteController = TextEditingController(
      text: invitation.note,
    );
    titleController = TextEditingController(
      text: invitation.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<InvitationCubit>();
    return BlocConsumer<InvitationCubit, InvitationState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final note = state.actualInvitation.note;
          if (note == null) {
            noteController.clear();
            return;
          }
          noteController.value = noteController.value.copyWith(text: note);
          setState(() {});
        });
        if (state.isLoaded) {
          context.read<AdminCubit>().updateInvitation(state.actualInvitation);
        }
      },
      builder: (context, state) {
        final invitation = state.actualInvitation;
        final sent = state.actualInvitation.sent ?? false;
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.actualInvitation.id ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        color: ButtonColors.button1TextColor,
                      ),
                    ),
                    const Gap(8),
                    IconButton(
                      icon: Icon(
                        Icons.verified,
                        color: sent ? Colors.green : Colors.grey,
                      ),
                      onPressed: () {
                        context
                            .read<InvitationCubit>()
                            .updateInvitation(invitation.copyWith(sent: !sent));
                      },
                    ),
                  ],
                ),
                const SaveResetButton(),
                const Gap(16),
                ShareWidget(invitation: invitation),
                const Gap(16),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                    controller: titleController,
                    key: const Key('title'),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Title',
                    ),
                    onChanged: (value) {
                      final newNote = invitation.copyWith(title: value);
                      cubit.updateInvitation(newNote);
                    },
                    maxLines: 5,
                  ),
                ),
                const Gap(8),
                SizedBox(
                  width: 300,
                  height: 60,
                  child: TextField(
                    controller: noteController,
                    key: const Key('note'),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: context.l10n.notes,
                    ),
                    onChanged: (value) {
                      final newNote = invitation.copyWith(note: value);
                      cubit.updateInvitation(newNote);
                    },
                    maxLines: 5,
                  ),
                ),
                ...(invitation.guests ?? [])
                    .map((guest) => GuestWidget(guest: guest)),
                const Gap(8),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: ButtonColors.button1TextColor,
                  ),
                  onPressed: () => cubit.addGuest(
                    Guest(id: const UuidV4().generate()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SaveResetButton extends StatelessWidget {
  const SaveResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationCubit, InvitationState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: state.isUpToDate ? null : () => save(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: state.isLoading
                      ? const Center(
                          child: SizedBox.square(
                            dimension: 16,
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                        )
                      : Text(
                          context.l10n.save,
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
                const Gap(16),
                ElevatedButton(
                  onPressed: state.isUpToDate ? null : () => reset(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    context.l10n.reset,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> save(BuildContext context) async {
    await context.read<InvitationCubit>().saveInvitation();
  }

  void reset(BuildContext context) {
    final original = context.read<InvitationCubit>().state.originalInvitation;
    context.read<InvitationCubit>().updateInvitation(original);
  }
}

class GuestWidget extends StatefulWidget {
  const GuestWidget({
    required this.guest,
    super.key,
  });

  final Guest guest;

  @override
  State<GuestWidget> createState() => _GuestWidgetState();
}

class _GuestWidgetState extends State<GuestWidget> {
  late TextEditingController nameController;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.guest.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAttending = widget.guest.isAttending;
    final attendingColor = isAttending == null
        ? Colors.grey
        : isAttending
            ? Colors.green
            : Colors.red;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    context.read<InvitationCubit>().deleteGuest(widget.guest);
                  },
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: nameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: ButtonColors.button1TextColor,
                    ),
                    onChanged: (value) {
                      final newGuest = widget.guest.copyWith(name: value);
                      context.read<InvitationCubit>().updateGuest(newGuest);
                    },
                  ),
                ),
              ],
            ),
            const Gap(16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(16),
                Text(
                  context.l10n.confirmed,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
                Checkbox(
                  value: isAttending != null,
                  fillColor: (isAttending != null)
                      ? WidgetStateProperty.all(Colors.green)
                      : WidgetStateProperty.all(Colors.red),
                  onChanged: null,
                ),
                Text(
                  context.l10n.attendance,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
                Checkbox(
                  value: isAttending ?? false,
                  fillColor: WidgetStateProperty.all(attendingColor),
                  onChanged: (value) {
                    final newGuest = widget.guest.copyWith(isAttending: value);
                    context.read<InvitationCubit>().updateGuest(newGuest);
                  },
                ),
              ],
            ),
            // Dropdown with the different values of dietary preferences
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(16),
                Text(
                  context.l10n.restrictions,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
                const Gap(8),
                DropdownButton<DietaryPreference>(
                  value: widget.guest.dietaryPreference,
                  items: DietaryPreference.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    final newGuest = widget.guest.copyWith(
                      dietaryPreference: value,
                    );
                    context.read<InvitationCubit>().updateGuest(newGuest);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShareWidget extends StatelessWidget {
  const ShareWidget({
    required this.invitation,
    super.key,
  });

  final Invitation invitation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView(
              children: [
                Text(
                  invitationText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
              ],
            ),
          ),
          const Gap(4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: copyToClipboard,
                child: Text(
                  context.l10n.copy,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
              ),
              const Gap(16),
              TextButton(
                onPressed: shareWhatsApp,
                child: Text(
                  context.l10n.share,
                  style: const TextStyle(
                    fontSize: 16,
                    color: ButtonColors.button1TextColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: invitationText));
  }

  Future<void> shareWhatsApp() async {
    final uri = Uri.parse('https://wa.me/?text=$invitationText');
    if (!await canLaunchUrl(uri)) return;
    await launchUrl(uri);
  }

  String get link =>
      'https://wedding-invitation-4ee7d.web.app/${invitation.id}';

  String get invitationText {
    if (invitation.guests?.length == 1) {
      return singleInvitationText;
    } else {
      return multipleInvitationText;
    }
  }

  String get singleInvitationText => '''
¡Hola, ${invitation.invitedNames}!
¡Llegó la invitación oficial a nuestra boda! Estamos muy felices de compartir con vos este momento tan especial.

Te dejamos el enlace: $link.
Para acceder, necesitarás esta contraseña: 15032025.

Recomendamos ver la invitación desde tu celular para una mejor experiencia. 📱

Por favor, confirma tu asistencia antes del 1 de febrero dentro de la pagina misma (¡es muy importante saber si podrás acompañarnos!).

¡Gracias de corazón y esperamos verte para celebrar juntos este día inolvidable!

Con mucho cariño,
Tomi & Emi
''';

  String get multipleInvitationText => '''
¡Hola, ${invitation.invitedNames}!
¡Llegó la invitación oficial a nuestra boda! Estamos muy felices de compartir con ustedes este momento tan especial.

Les dejamos el enlace: $link.
Para acceder, necesitarán esta contraseña: 15032025.

Recomendamos ver la invitación desde su celular para una mejor experiencia. 📱

Por favor, confirmen su asistencia antes del 1 de febrero dentro de la pagina misma (¡es muy importante saber si podrán acompañarnos!).

¡Gracias de corazón y esperamos verlos para celebrar juntos este día inolvidable!

Con mucho cariño,
Tomi & Emi
''';

  String get englishInvitation => '''
Hello, ${invitation.invitedNames}!
The official invitation to our wedding has arrived! We are so happy to share this very special moment with you.

Here is the link: $link
To access it, you’ll need this password: 15032025.

We recommend viewing the invitation on your phone for the best experience. 📱

Please confirm your attendance by February 1 directly on the page (it’s very important for us to know if you’ll be able to join!).

Thank you from the bottom of our hearts, and we hope to see you to celebrate this unforgettable day together!

With love,
Tomas & Emi
''';
}
