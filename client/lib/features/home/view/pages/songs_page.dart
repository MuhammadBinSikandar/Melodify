import 'dart:math';

import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSongs = ref.watch(getAllSongsProvider);
    final recentlyPlayedSongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    final artistRecommendations = allSongs.when(
      data:
          (songs) => ref
              .watch(homeViewModelProvider.notifier)
              .getArtistBasedRecommendations(songs),
      error: (_, __) => <SongModel>[],
      loading: () => <SongModel>[],
    );
    final currentSong = ref.watch(currentSongNotifierProvider);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            const Color(0xFF6A1B9A).withOpacity(0.3),
            const Color(0xFF1565C0).withOpacity(0.2),
            Colors.black,
          ],
          stops: const [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        decoration:
            currentSong == null
                ? null
                : BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      hexToColor(currentSong.hex_code).withOpacity(0.4),
                      Colors.transparent,
                      hexToColor(currentSong.hex_code).withOpacity(0.1),
                    ],
                    stops: const [0.0, 0.3, 1.0],
                  ),
                ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Recently Played Songs Section
              _buildSectionHeader('Recently Played', Icons.history),
              const SizedBox(height: 16),

              Container(
                height: 280,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: recentlyPlayedSongs.length,
                  itemBuilder: (context, index) {
                    final song = recentlyPlayedSongs[index];
                    return _buildGlassCard(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song);
                            },
                            child: Container(
                              width: 56,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFBB86FC,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                child: Image.network(
                                  song.thumbnail_url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              song.song_name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                shadows: [
                                  Shadow(
                                    color: const Color(
                                      0xFF7C4DFF,
                                    ).withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Artist Recommendations Section
              _buildSectionHeader('Recommended for You', Icons.favorite),
              const SizedBox(height: 16),

              Container(
                height: 280,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: artistRecommendations.length,
                  itemBuilder: (context, index) {
                    final song = artistRecommendations[index];
                    return _buildGlassCard(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentSongNotifierProvider.notifier)
                                  .updateSong(song);
                            },
                            child: Container(
                              width: 56,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF4DD0E1,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  bottomLeft: Radius.circular(12.0),
                                ),
                                child: Image.network(
                                  song.thumbnail_url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              song.song_name,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                                shadows: [
                                  Shadow(
                                    color: const Color(
                                      0xFF64B5F6,
                                    ).withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),

              // Latest Today Section
              _buildSectionHeader('Latest Today', Icons.new_releases),
              const SizedBox(height: 16),

              ref
                  .watch(getAllSongsProvider)
                  .when(
                    data: (songs) {
                      return Container(
                        height: 280,
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: songs.length,
                          itemBuilder: (context, index) {
                            final song = songs[index];
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(currentSongNotifierProvider.notifier)
                                    .updateSong(song);
                              },
                              child: Container(
                                width: 180,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                  right: index == songs.length - 1 ? 16.0 : 0,
                                ),
                                child: _buildLatestSongCard(song),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    error: (error, st) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Error loading songs',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: Loader()),
                  ),

              const SizedBox(height: 40), // Bottom padding to prevent overflow
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7C4DFF), Color(0xFF651FFF)],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBB86FC).withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: const Color(0xFF7C4DFF).withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.only(right: 16),
      child: child,
    );
  }

  Widget _buildLatestSongCard(SongModel song) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BCD4).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(song.thumbnail_url, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            song.song_name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: const Color(0xFF7C4DFF).withOpacity(0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            song.artist,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
