import 'package:karostreammemories/drive/screens/file-list/base-file-list-screen.dart';
import 'package:karostreammemories/drive/state/file-pages.dart';

class SharedScreen extends BaseFileListScreen {
  static const ROUTE = 'shared';
  final FilePage page = SharesPage();
}
