// ignore_for_file: unused_local_variable

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/pages/library_page.dart';
import 'package:client/features/home/view/pages/songs_page.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/current_user_notifier.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  int selectedIndex = 0;

  final pages = const [SongsPage(), LibraryPage()];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserNotifierProvider);
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(bottom: 0, child: MusicSlab()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              selectedIndex == 0
                  ? 'assets/images/home_filled.png'
                  : 'assets/images/home_unfilled.png',
              color:
                  selectedIndex == 0
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color:
                  selectedIndex == 1
                      ? Pallete.whiteColor
                      : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
