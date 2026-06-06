import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qqai/config/theme/app_action_colors.dart';
import 'package:qqai/features/goods/theme/goods_page_style.dart';

/// 首页 Tab（商场 / 广场 / 工具等）内容区顶部的统一搜索条，渲染在透明 AppBar 下方。
class InPageSearchBar extends StatefulWidget {
  const InPageSearchBar({
    super.key,
    required this.hintText,
    required this.onQueryChanged,
    this.controller,
    /// AppBar 与状态栏占用的顶部留白，搜索框渲染在其下方。
    this.height = kToolbarHeight,
    this.debounce = const Duration(milliseconds: 350),
    /// 搜索框右侧附加操作（如宽屏布局切换）。
    this.trailing,
  });

  final String hintText;
  final ValueChanged<String> onQueryChanged;
  final TextEditingController? controller;
  final double height;
  final Duration debounce;
  final Widget? trailing;

  /// 首页透明 AppBar 下，内容区顶部应预留的高度。
  static double homeTabTopInset(BuildContext context) {
    return kToolbarHeight;
  }

  @override
  State<InPageSearchBar> createState() => _InPageSearchBarState();
}

class _InPageSearchBarState extends State<InPageSearchBar> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  Timer? _debounce;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _query = _controller.text;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final next = _controller.text;
    if (next == _query) return;
    setState(() => _query = next);
    _debounce?.cancel();
    _debounce = Timer(widget.debounce, () {
      if (!mounted) return;
      widget.onQueryChanged(_controller.text.trim());
    });
  }

  void _clear() {
    _debounce?.cancel();
    _controller.clear();
    setState(() => _query = '');
    widget.onQueryChanged('');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: widget.height),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: AppActionColors.strong(context),
                    fontSize: 14,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    _debounce?.cancel();
                    widget.onQueryChanged(value.trim());
                  },
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      color: AppActionColors.subtle(context),
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20,
                      color: AppActionColors.subtle(context),
                    ),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 18,
                              color: AppActionColors.muted(context),
                            ),
                            onPressed: _clear,
                          ),
                    filled: true,
                    fillColor: AppActionColors.surface(context),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: GoodsPageStyle.border(context)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: GoodsPageStyle.border(context)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF3578E5)),
                    ),
                  ),
                ),
              ),
              if (widget.trailing != null) ...[
                const SizedBox(width: 8),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
