part of 'home_cubit.dart';

enum HomeStatus {
  loading,
  loaded,
  error,
}

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.loading,
    this.videoController,
    this.scrollController,
    this.invitation,
  });

  final HomeStatus status;
  final VideoController? videoController;
  final ScrollController? scrollController;
  final Invitation? invitation;

  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get isError => status == HomeStatus.error;

  String? get invitationNames {
    if (invitation == null) return null;
    if (invitation?.title != null) return invitation?.title;
    final names = invitation!.guests?.map((e) => e.name).toList().join(' & ');
    return names;
  }

  @override
  List<Object?> get props => [status];
}
