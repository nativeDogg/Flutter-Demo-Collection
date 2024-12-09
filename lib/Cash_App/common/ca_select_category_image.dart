import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_input.dart';
import 'package:flutter_demo_collect/Cash_App/struct/iconObjects.dart';

class SelectCategoryImage extends StatefulWidget {
  const SelectCategoryImage({
    super.key,
    required this.setSelectedImage,
    this.selectedImage,
    // required this.setSelectedTitle,
    // required this.setSelectedEmoji,
    this.next,
  });

  final Function(String?) setSelectedImage;
  final String? selectedImage;
  // final Function(String?) setSelectedTitle;
  // final Function(String?) setSelectedEmoji;
  final VoidCallback? next;

  @override
  State<SelectCategoryImage> createState() => _SelectCategoryImageState();
}

class _SelectCategoryImageState extends State<SelectCategoryImage> {
  String? selectedImage;

  /// emoji搜索关键字
  String searchTerm = "";

  @override
  void initState() {
    super.initState();
    if (widget.selectedImage != null) {
      setState(() {
        selectedImage =
            widget.selectedImage!.replaceAll("assets/categories/", "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _buildEmojiSearch(),
        const SizedBox(height: 10),
        _buildEmojiList(),
      ],
    );
  }

  _buildEmojiSearch() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: CaTextInput(
            labelText: "Search Emoji",

            icon: Icons.search_outlined,
            onSubmitted: (value) {},
            onChanged: (value) {
              setState(() {
                searchTerm = value.trim();
              });
            },
            padding: const EdgeInsetsDirectional.all(0),
            // 如果是web平台运行 则自动获取焦点
            autoFocus: kIsWeb,
          ),
        ),
      ],
    );
  }

  _buildEmojiList() {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 500),
      child: Wrap(
        // alignment: WrapAlignment.start,
        children: iconObjects.map((IconForCategory ifc) {
          bool show = false;
          // 通过在输入框中输入的关键字来过滤图标
          if (searchTerm.isNotEmpty) {
            for (var i = 0; i < ifc.tags.length; i++) {
              ifc.tags[i].toLowerCase().contains(searchTerm.toLowerCase())
                  ? show = true
                  : show = false;
            }
          } else {
            show = true;
          }
          if (show == true) {
            return ImageIcon(
              sizePadding: 8,
              margin: const EdgeInsetsDirectional.all(5),
              size: 50,
              iconPath: 'assets/categories/${ifc.icon}',
              onTap: () {
                widget.setSelectedImage(ifc.icon);
                setState(() {
                  selectedImage = ifc.icon;
                });
                Navigator.pop(context);
              },
              outline: widget.selectedImage == ifc.icon,
              color: Colors.transparent,
            );
          } else {
            return const SizedBox.shrink();
          }
        }).toList(),
      ),
    );
  }
}

/// 图标Icon
class ImageIcon extends StatelessWidget {
  ImageIcon({
    Key? key,
    required this.color,
    required this.size,
    this.onTap,
    this.margin,
    this.sizePadding = 20,
    this.outline = false,
    this.iconPath,
  }) : super(key: key);

  final Color color;
  final double size;
  final VoidCallback? onTap;
  final EdgeInsetsDirectional? margin;
  final double sizePadding;
  final bool outline;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      margin: margin ??
          EdgeInsetsDirectional.only(start: 8, end: 8, top: 8, bottom: 8),
      height: size,
      width: size,
      decoration: outline
          ? BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                width: 2,
              ),
              borderRadius: BorderRadiusDirectional.all(Radius.circular(500)),
            )
          : BoxDecoration(
              border: Border.all(
                color: color,
                width: 0,
              ),
              borderRadius: BorderRadiusDirectional.all(Radius.circular(500)),
            ),
      child: Tappable(
        color: color,
        onTap: onTap,
        borderRadius: 500,
        child: Padding(
          padding: EdgeInsetsDirectional.all(sizePadding),
          child: Image(
            image: AssetImage(iconPath ?? ""),
            width: size,
          ),
        ),
      ),
    );
  }
}
