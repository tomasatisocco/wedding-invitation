part of 'unlock_cubit.dart';

enum UnlockStatus {
  locked,
  unlocked,
  unlocking,
  error;

  bool get isLocked => this == locked;
  bool get isUnlocked => this == unlocked;
  bool get isUnlocking => this == unlocking;
  bool get isError => this == error;
}
