import 'package:karostreammemories/drive/screens/file-list/base-file-list-screen.dart';
import 'package:karostreammemories/drive/state/file-pages.dart';

class RootScreen extends BaseFileListScreen {
  static const ROUTE = '/';
  final FilePage page = RootFolderPage();
}
