// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Enum to represent dietary preferences
enum DietaryPreference {
  /// Vegan preferences
  vegan,

  /// Celiac preferences
  celiac,

  /// Vegetarian preferences
  vegetarian,

  /// None of the above
  none;

  const DietaryPreference();

  factory DietaryPreference.fromString(String? value) {
    return DietaryPreference.values.firstWhere(
      (element) => element.name == value,
      orElse: () => DietaryPreference.none,
    );
  }
}

/// Model for a person in the invitation
class Guest extends Equatable {
  /// Constructor
  const Guest({
    this.name,
    this.isAttending,
    this.dietaryPreference,
    this.id,
  });

  /// Factory constructor to parse from a Map
  factory Guest.fromMap(Map<String, dynamic> map) {
    final dietary = map['dietaryPreference'] as String?;
    return Guest(
      id: map['id'] as String?,
      name: map['name'] as String?,
      isAttending: map['isAttending'] as bool?,
      dietaryPreference: DietaryPreference.fromString(dietary),
    );
  }

  /// Id of the guest
  final String? id;

  /// Name of the guest
  final String? name;

  /// Whether the guest is attending
  final bool? isAttending;

  /// Dietary preference
  final DietaryPreference? dietaryPreference;

  /// Convert to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isAttending': isAttending,
      'dietaryPreference': dietaryPreference?.name,
    };
  }

  @override
  List<Object?> get props => [name, isAttending, dietaryPreference];

  Guest copyWith({
    String? id,
    String? name,
    bool? isAttending,
    DietaryPreference? dietaryPreference,
  }) {
    return Guest(
      id: id ?? this.id,
      name: name ?? this.name,
      isAttending: isAttending ?? this.isAttending,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
    );
  }
}

/// Model for an invitation
class Invitation extends Equatable {
  /// Constructor
  const Invitation({
    this.id,
    this.guests,
    this.note,
  });

  /// Factory constructor to parse from a Map
  factory Invitation.fromMap(Map<String, dynamic> map) {
    return Invitation(
      id: map['id'] as String,
      guests: (map['guests'] as List<dynamic>?)
          ?.map((invitee) => Guest.fromMap(invitee as Map<String, dynamic>))
          .toList(),
      note: map['note'] as String?,
    );
  }

  /// Deserialize from JSON
  factory Invitation.fromJson(String source) =>
      Invitation.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Id of the invitation equal to the principal
  final String? id;

  /// List of guests
  final List<Guest>? guests;

  /// Optional note
  final String? note;

  /// Convert to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guests': guests?.map((invitee) => invitee.toMap()).toList(),
      'note': note,
    };
  }

  /// Serialize to JSON
  String toJson() => json.encode(toMap());

  Invitation copyWith({
    String? id,
    List<Guest>? guests,
    String? note,
  }) {
    return Invitation(
      id: id ?? this.id,
      guests: guests ?? this.guests,
      note: note ?? this.note,
    );
  }

  String? get invitedNames {
    if (guests == null) return null;
    if (guests?.isEmpty ?? true) return null;
    if (guests?.length == 1) return null;

    return guests?.map((guest) => guest.name).join(', ') ?? '';
  }

  @override
  List<Object?> get props => [id, guests, note];
}
