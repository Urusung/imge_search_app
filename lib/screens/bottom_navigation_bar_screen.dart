import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imge_search_app/colors.dart';
import 'package:imge_search_app/fonst_style.dart';
import 'package:imge_search_app/provider/bottom_navigation_provider.dart';
import 'package:imge_search_app/screens/favorite_images_screen.dart';
import 'package:imge_search_app/screens/image_search_screen.dart/images_search_screen.dart';

class BottomNavigationBarScreen extends ConsumerWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedIndex = ref.watch(bottomNavigationBarProvider);
    final indexdStack = IndexedStack(
      index: selectedIndex,
      children: const [
        ImagesSearchScreen(),
        FavoriteImagesScreen(),
      ],
    );
    void onTap(int index) {
      ref.read(bottomNavigationBarProvider.notifier).update((state) => index);
    }

    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: indexdStack,
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.5),
                blurRadius: 2.0,
                spreadRadius: 1.0,
                offset: const Offset(0.0, 2.0),
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: onTap,
            selectedItemColor: mainColor,
            unselectedItemColor: grey,
            backgroundColor: white,
            selectedLabelStyle: bottomNavigationBarStyle,
            unselectedLabelStyle:
                bottomNavigationBarStyle.copyWith(color: grey),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border_rounded),
                activeIcon: Icon(Icons.favorite_rounded),
                label: 'Favorite',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
