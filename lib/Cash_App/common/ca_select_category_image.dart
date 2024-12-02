import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_tappable.dart';
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Wrap(
            children: iconObjects.map((IconForCategory ifc) {
              return ImageIcon(
                sizePadding: 8,
                margin: EdgeInsetsDirectional.all(5),
                size: 50,
                iconPath: 'assets/categories/${ifc.icon}',
                onTap: () {},
                outline: widget.selectedImage == ifc.icon,
                color: Colors.transparent,
              );
            }).toList(),
          ),
        )
      ],
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
