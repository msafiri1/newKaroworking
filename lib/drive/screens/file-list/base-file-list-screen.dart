import 'package:karostreammemories/drive/navigation/app-bar/app-bar-container.dart';
import 'package:karostreammemories/drive/navigation/bottom-nav.dart';
import 'package:karostreammemories/drive/navigation/drive-drawer/drive-drawer.dart';
import 'package:karostreammemories/drive/screens/file-list/file-list-container.dart';
import 'package:karostreammemories/drive/state/drive-state.dart';
import 'package:karostreammemories/drive/state/file-pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseFileListScreen extends StatefulWidget {
  final FilePage? page = RootFolderPage();
  @override
  _BaseFileListScreenState createState() => _BaseFileListScreenState();
}

class _BaseFileListScreenState extends State<BaseFileListScreen> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarContainer(),
      bottomNavigationBar: BottomNav(),
      body: FileListContainer(),
      drawer: widget.page is FolderPage ? null : DriveDrawer(),
    );
  }

  @override
  void initState() {
    context.read<DriveState>().openPage(widget.page!);
    super.initState();
  }
}
