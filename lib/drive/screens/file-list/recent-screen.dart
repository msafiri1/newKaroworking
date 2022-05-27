import 'package:karostreammemories/drive/screens/file-list/base-file-list-screen.dart';
import 'package:karostreammemories/drive/state/file-pages.dart';

class RecentScreen extends BaseFileListScreen {
  static const ROUTE = 'recent';
  final FilePage page = RecentPage();
}
