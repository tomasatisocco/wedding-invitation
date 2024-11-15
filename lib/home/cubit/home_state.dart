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
  });

  final HomeStatus status;
  final VideoPlayerController? videoController;

  bool get isLoading => status == HomeStatus.loading;
  bool get isLoaded => status == HomeStatus.loaded;
  bool get isError => status == HomeStatus.error;

  @override
  List<Object?> get props => [status];
}
