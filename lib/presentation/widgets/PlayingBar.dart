import 'package:flutter/material.dart';

class PlayingBar extends StatelessWidget {
  final String songTitle;
  final String artistName;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback? onClose;
  final String albumArtUrl;

  const PlayingBar({
    super.key,
    required this.songTitle,
    required this.artistName,
    required this.isPlaying,
    required this.onPlayPause,
    this.onClose,
    this.albumArtUrl = 'https://via.placeholder.com/50',
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Album art
            // Container(
            //   width: 50,
            //   height: 50,
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade400,
            //     borderRadius: BorderRadius.circular(10),
            //     image: const DecorationImage(
            //       image: AssetImage('assets/images/music_placeholder.png'),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 16),

            // Song details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    songTitle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artistName,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Control buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Play/Pause button
                IconButton(
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_filled,
                    color: Colors.grey.shade800,
                    size: 40,
                  ),
                  onPressed: onPlayPause,
                  padding: EdgeInsets.zero,
                ),

                // Close button
                if (onClose != null)
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                    onPressed: onClose,
                    padding: EdgeInsets.zero,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
