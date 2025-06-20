// client/lib/features/home/viewmodel/home_viewmodel.dart
// ignore_for_file: deprecated_member_use_from_same_package, unused_local_variable

import 'dart:io';
import 'dart:ui';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/models/fav_song_model.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_viewmodel.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(GetFavSongsRef ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref.watch(homeRepositoryProvider).getFavSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

// Add this provider at the top of the file with other providers
@riverpod
Future<List<SongModel>> getTopSongs(GetTopSongsRef ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );
  final res = await ref.watch(homeRepositoryProvider).getTopSongs(token: token);

  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;

  get length => null;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required Color selectedColor,
  }) async {
    state = AsyncValue.loading();
    final res = await _homeRepository.uploadSong(
      selectedAudio: selectedAudio,
      selectedThumbnail: selectedThumbnail,
      songName: songName,
      artist: artist,
      hexCode: rgbToHex(selectedColor),
      token: ref.read(currentUserNotifierProvider)!.token,
    );
    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.favSong(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) =>
        state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };
    print(val);
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorited) {
      userNotifier.addUser(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favorites: [
                ...ref.read(currentUserNotifierProvider)!.favorites,
                FavSongModel(id: '', song_id: songId, user_id: ''),
              ],
            ),
      );
    } else {
      userNotifier.addUser(
        ref
            .read(currentUserNotifierProvider)!
            .copyWith(
              favorites:
                  ref
                      .read(currentUserNotifierProvider)!
                      .favorites
                      .where((fav) => fav.song_id != songId)
                      .toList(),
            ),
      );
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavorited);
  }

  List<SongModel> getArtistBasedRecommendations(List<SongModel> allSongs) {
    // Get recently played songs and favorite songs
    final recentlyPlayed = getRecentlyPlayedSongs();
    final favoriteSongs = ref.read(getFavSongsProvider).valueOrNull ?? [];

    // Extract unique artists from recently played and favorite songs
    final preferredArtists =
        {
          ...recentlyPlayed.map((song) => song.artist),
          ...favoriteSongs.map((song) => song.artist),
        }.toList();

    // Filter allSongs to include only those by preferred artists
    final recommendedSongs =
        allSongs
            .where((song) => preferredArtists.contains(song.artist))
            .toList();

    // If no matching songs found, return empty list (strictly matching artists only)
    if (recommendedSongs.isEmpty) {
      return [];
    }

    // Shuffle recommendations and limit to exactly 4 songs
    recommendedSongs.shuffle();
    return recommendedSongs.take(8).toList();
  }
}
