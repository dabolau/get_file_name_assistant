import 'dart:io';

class FileScanner {
  // 获取路径下的名字，如果是文件直接返回，如果是目录则递归
  static List<String> getAllFileNames(String path) {
    final fileType = FileSystemEntity.typeSync(path);

    // 如果是文件夹，才去钻洞
    if (fileType == FileSystemEntityType.directory) {
      final directory = Directory(path);
      final contents = directory.listSync(recursive: true);

      List<String> nameList = [];
      for (var item in contents) {
        if (item is File) {
          nameList.add(item.path.split(Platform.pathSeparator).last);
        }
      }
      return nameList;
    }
    // 如果直接就是一个文件，就直接给它名字
    else if (fileType == FileSystemEntityType.file) {
      return [path.split(Platform.pathSeparator).last];
    }

    return [];
  }

  // 新增一个判断：是不是文件夹？
  static bool isDirectory(String path) {
    return FileSystemEntity.isDirectorySync(path);
  }
}
