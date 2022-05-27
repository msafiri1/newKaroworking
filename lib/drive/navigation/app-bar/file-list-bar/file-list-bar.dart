import 'package:karostreammemories/drive/navigation/app-bar/file-list-bar/file-view-mode-button.dart';
import 'package:karostreammemories/drive/navigation/app-bar/file-list-bar/sorting/sort-popup-menu-button.dart';
import 'package:karostreammemories/drive/state/file-pages.dart';
import 'package:flutter/material.dart';
import 'package:karostreammemories/drive/state/drive-state.dart';
import 'package:provider/provider.dart';

class FileListBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final shouldHide = context.select((DriveState s) => s.activePage is SearchPage);
    if (shouldHide) {
      return SliverToBoxAdapter(child: Container());
    }
    return SliverAppBar(
      primary: false,
      automaticallyImplyLeading: false,
      floating: true,
      elevation: 0,
      toolbarHeight: 43,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme: Theme.of(context).iconTheme,
      textTheme: Theme.of(context).textTheme,
      brightness: Theme.of(context).brightness,
      title: SortPopupMenuButton(),
      centerTitle: false,
      titleSpacing: 4,
      bottom: PreferredSize(
        child: Container(
          color: Theme.of(context).dividerColor,
          height: 1,
        ),
        preferredSize: Size.fromHeight(1)
      ),
      actions: [
        FileViewModeButton(),
      ],
    );
  }
}



