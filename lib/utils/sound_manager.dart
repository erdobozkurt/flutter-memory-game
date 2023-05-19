import 'package:audioplayers/audioplayers.dart';


class SoundManager {
  static final SoundManager _instance = SoundManager._internal();

  factory SoundManager() => _instance;

  SoundManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  // play correct sound
  Future<void> playCorrectSound() async {
    await _audioPlayer.play(AssetSource('correct_tap.flac'));
  }

  // play wrong sound
  Future<void> playWrongSound() async {
    await _audioPlayer.play(AssetSource('wrong_tap.flac'));
  }
}
