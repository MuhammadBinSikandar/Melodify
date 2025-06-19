// client/lib/features/home/pages/top_songs_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';

class TopSongsPage extends ConsumerWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const TopSongsPage());

  const TopSongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topSongs = ref.watch(getTopSongsProvider);
    final currentSong = ref.watch(currentSongNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top Songs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
      ),
      body: topSongs.when(
        data: (songs) {
          if (songs.isEmpty) {
            return const Center(
              child: Text(
                'No songs available yet',
                style: TextStyle(fontSize: 16, color: Pallete.subtitleText),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              final isCurrentSong = currentSong?.id == song.id;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color:
                      isCurrentSong
                          ? hexToColor(song.hex_code).withOpacity(0.1)
                          : Pallete.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border:
                      isCurrentSong
                          ? Border.all(
                            color: hexToColor(song.hex_code),
                            width: 2,
                          )
                          : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: hexToColor(song.hex_code),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.thumbnail_url,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 50,
                              height: 50,
                              color: Pallete.borderColor,
                              child: const Icon(
                                Icons.music_note,
                                color: Pallete.whiteColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    song.song_name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color:
                          isCurrentSong
                              ? hexToColor(song.hex_code)
                              : Pallete.whiteColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.artist,
                        style: const TextStyle(
                          color: Pallete.subtitleText,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.play_arrow,
                            size: 16,
                            color: hexToColor(song.hex_code),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${song.play_count} plays',
                            style: TextStyle(
                              color: hexToColor(song.hex_code),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing:
                      isCurrentSong
                          ? Icon(
                            Icons.equalizer,
                            color: hexToColor(song.hex_code),
                          )
                          : const Icon(
                            Icons.play_arrow,
                            color: Pallete.whiteColor,
                          ),
                  onTap: () {
                    ref
                        .read(currentSongNotifierProvider.notifier)
                        .updateSong(song);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Pallete.errorColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading top songs',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: const TextStyle(color: Pallete.subtitleText),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.refresh(getTopSongsProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
