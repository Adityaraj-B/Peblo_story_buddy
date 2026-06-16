import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controllers/story_buddy_controller.dart';
import 'services/narration_player.dart';
import 'widgets/story_buddy_screen.dart';

void main() {
  runApp(const PebloStoryBuddyApp());
}

class PebloStoryBuddyApp extends StatelessWidget {
  const PebloStoryBuddyApp({super.key, this.narrationPlayer});

  final NarrationPlayer? narrationPlayer;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoryBuddyCubit(narrationPlayer: narrationPlayer),
      child: MaterialApp(
        title: 'Peblo Story Buddy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1AA6B7),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFFF6DE),
          textTheme: Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xFF17324D),
            displayColor: const Color(0xFF17324D),
          ),
        ),
        home: const StoryBuddyScreen(),
      ),
    );
  }
}
