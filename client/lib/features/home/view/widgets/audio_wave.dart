import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioWave extends StatefulWidget {
  final String path;
  const AudioWave({super.key, required this.path});

  @override
  State<AudioWave> createState() => _AudioWaveState();
}

class _AudioWaveState extends State<AudioWave>
    with SingleTickerProviderStateMixin {
  final PlayerController playerController = PlayerController();
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.2, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void initAudioPlayer() async {
    await playerController.preparePlayer(path: widget.path);
  }

  @override
  void dispose() {
    _animationController.dispose();
    playerController.dispose();
    super.dispose();
  }

  Future<void> playAndPause() async {
    if (!playerController.playerState.isPlaying) {
      await playerController.startPlayer();
    } else if (!playerController.playerState.isPaused) {
      await playerController.pausePlayer();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF151515), // surfaceBackground
            Color(0xFF0A0A0A), // secondaryBackground
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ), // glassBorderStrong
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6A1B9A).withOpacity(0.3), // shadowPurple
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.2), // shadowBlue
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: playAndPause,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF7C4DFF), // buttonActive
                        Color(0xFF651FFF), // buttonHover
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF7C4DFF,
                        ).withOpacity(_glowAnimation.value), // glowPurple
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    playerController.playerState.isPlaying
                        ? CupertinoIcons.pause_solid
                        : CupertinoIcons.play_arrow_solid,
                    color: Colors.white,
                    size: 28,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AudioFileWaveforms(
              size: const Size(double.infinity, 100),
              playerController: playerController,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: Colors.white.withOpacity(
                  0.2,
                ), // progressBarInactive
                liveWaveColor: const Color(0xFF64B5F6), // progressBarActive
                spacing: 6,
                waveThickness: 3,
                showSeekLine: false,
                waveCap: StrokeCap.round,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white.withOpacity(0.05), // glassOverlayLight
              ),
            ),
          ),
        ],
      ),
    );
  }
}
