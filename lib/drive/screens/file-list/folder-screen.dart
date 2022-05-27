import 'package:karostreammemories/drive/screens/file-list/base-file-list-screen.dart';
import 'package:karostreammemories/drive/state/file-pages.dart';

class FolderScreenArgs {
  FolderScreenArgs(this.folderPage);
  final FolderPage? folderPage;
}

class FolderScreen extends BaseFileListScreen {
  static const ROUTE = 'folder';
  FolderScreen(this.page);
  final FolderPage? page;
}
