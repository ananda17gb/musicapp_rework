import 'package:flutter/material.dart';
import 'package:music_v2/domain/entities/songs.dart';

class SongsCards extends StatefulWidget {
  final Song song;
  final bool isCurrentlyPlaying;
  final VoidCallback onPlay;

  const SongsCards({
    super.key,
    required this.song,
    this.isCurrentlyPlaying = false,
    required this.onPlay,
  });

  @override
  State<SongsCards> createState() => _SongsCardsState();
}

class _SongsCardsState extends State<SongsCards> {
  bool _showPlayIcon = true;

  @override
  void didUpdateWidget(SongsCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCurrentlyPlaying != widget.isCurrentlyPlaying) {
      setState(() {
        _showPlayIcon = !widget.isCurrentlyPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7.0),
      padding: const EdgeInsets.all(11.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(11),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            spreadRadius: 0,
            blurRadius: 14,
            blurStyle: BlurStyle.normal,
            offset: const Offset(-1, 3),
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-6, -5),
            blurRadius: 14,
            spreadRadius: 0,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade100,
            Colors.grey.shade200,
            Colors.grey.shade300,
            Colors.grey.shade400,
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _showPlayIcon = !_showPlayIcon;
          });
          widget.onPlay();
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.song.artist,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade800,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Play/Wave Icon
            SizedBox(
              width: 32,
              height: 32,
              child: widget.isCurrentlyPlaying
                  ? const WaveAnimationIcon()
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveAnimationIcon extends StatefulWidget {
  final double size;
  const WaveAnimationIcon({super.key, this.size = 31});

  @override
  State<WaveAnimationIcon> createState() => _WaveAnimationIconState();
}

class _WaveAnimationIconState extends State<WaveAnimationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Create multiple animations for different bars
    _animations = List.generate(3, (index) {
      final begin = 0.3;
      final end = 1.0;
      final interval = index * 0.2; // Stagger the animations

      return Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            interval,
            interval + 0.5,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 4,
              height: widget.size * _animations[index].value,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
        );
      },
    );
  }
}
