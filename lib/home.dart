import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'scanner.dart';
import 'url.dart';
import 'locale.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  String? statusMessage;

  // 核心对齐基准线
  final double basePadding = 12.0;

  // 提供状态反馈
  void showFeedback(String messageKey) {
    setState(() {
      statusMessage = LocaleHelper.getText(context, messageKey);
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          statusMessage = null;
        });
      }
    });
  }

  // 执行提取操作
  void handleAction(String path) {
    try {
      final names = FileScanner.getAllFileNames(path);
      setState(() {
        textController.text = names.join('\n');
      });
      if (names.isNotEmpty) {
        Clipboard.setData(ClipboardData(text: textController.text));
        showFeedback('success');
      }
    } catch (e) {
      if (e.toString().contains('not_a_directory')) {
        showFeedback('errorNotFolder');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // --- Zed 工具栏 (适配统一 18px 字体) ---
              Container(
                height: 56, // 增加高度，为 18px 标题提供空间
                padding: EdgeInsets.only(left: basePadding, right: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF3F3F3),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE6E6E6), width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      LocaleHelper.getText(context, 'title').toLowerCase(),
                      style: const TextStyle(
                        color: Color(0xFF383A42),
                        fontSize: 18, // 统一字号
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    _buildZedButton(
                      icon: LucideIcons.folderOpen,
                      tooltip: 'open',
                      onPressed: () async {
                        String? path = await FilePicker.platform
                            .getDirectoryPath();
                        if (path != null) {
                          handleAction(path);
                        }
                      },
                    ),
                    _buildZedButton(
                      icon: LucideIcons.copy,
                      tooltip: 'copy',
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          Clipboard.setData(
                            ClipboardData(text: textController.text),
                          );
                          showFeedback('copied');
                        }
                      },
                    ),
                    _buildZedButton(
                      icon: LucideIcons.trash2,
                      tooltip: 'clear',
                      onPressed: () {
                        textController.clear();
                        showFeedback('cleared');
                      },
                    ),
                    _buildZedButton(
                      icon: LucideIcons.globe,
                      tooltip: 'web',
                      onPressed: () {
                        UrlHelper.openWebsite();
                        showFeedback('web');
                      },
                    ),
                  ],
                ),
              ),
              // --- 主编辑器区域 (18px) ---
              Expanded(
                child: DropTarget(
                  onDragDone: (details) {
                    if (details.files.isNotEmpty) {
                      handleAction(details.files.first.path);
                    }
                  },
                  child: TextField(
                    controller: textController,
                    maxLines: null,
                    expands: true,
                    cursorColor: const Color(0xFF526FFF),
                    cursorWidth: 2.0,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      color: Color(0xFF383A42),
                      fontFamily: 'monospace',
                      fontSize: 18, // 统一字号
                      height: 1.6,
                    ),
                    decoration: InputDecoration(
                      hintText: LocaleHelper.getText(context, 'hint'),
                      hintStyle: const TextStyle(
                        color: Color(0xFFA0A1A7),
                        fontSize: 18,
                      ),
                      contentPadding: EdgeInsets.all(basePadding),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- 状态提示框 (18px) ---
          if (statusMessage != null)
            Positioned(
              left: basePadding,
              bottom: basePadding,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFD0D0D0),
                      width: 0.5,
                    ),
                  ),
                  child: Text(
                    statusMessage!,
                    style: const TextStyle(
                      color: Color(0xFF383A42),
                      fontSize: 18, // 统一字号
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 方形按钮组件
  Widget _buildZedButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    bool isHovering = false;
    return StatefulBuilder(
      builder: (context, setBtnState) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setBtnState(() => isHovering = true),
          onExit: (_) => setBtnState(() => isHovering = false),
          child: Tooltip(
            message: LocaleHelper.getText(context, tooltip),
            child: GestureDetector(
              onTap: onPressed,
              child: Container(
                width: 36, // 略微增大，适配整体大字号风格
                height: 36,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: isHovering
                      ? const Color(0xFFE8E8E8)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 20, color: const Color(0xFF696C77)),
              ),
            ),
          ),
        );
      },
    );
  }
}
