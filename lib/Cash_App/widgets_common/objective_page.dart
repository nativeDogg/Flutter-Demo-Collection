import 'package:confetti/confetti.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_animate.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_function.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_page_frame_work.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_popup_frame_work.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_select_category_image.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_text_font.dart';
import 'package:flutter_demo_collect/Cash_App/common/ca_widgets.dart';
import 'package:flutter_demo_collect/Cash_App/model/index.dart';
import 'package:flutter_demo_collect/Cash_App/widgets/ca_transcation_item.dart';
import 'package:flutter_demo_collect/Cash_App/widgets_common/color_theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ObjectivePage extends StatelessWidget {
  final TransactionCategoryModel category;
  const ObjectivePage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    Color accentColor = HexColor(category.colour,
        defaultColor: Theme.of(context).colorScheme.primary);
    return CustomColorTheme(
      accentColor: accentColor,
      child: _ObjectivePageContent(
        color: accentColor,
        category: category,
        // objective: data,
      ),
    );
  }
}

class _ObjectivePageContent extends StatefulWidget {
  final Color color;
  final TransactionCategoryModel category;
  const _ObjectivePageContent({
    super.key,
    required this.color,
    required this.category,
  });

  @override
  State<_ObjectivePageContent> createState() => __ObjectivePageContentState();
}

class __ObjectivePageContentState extends State<_ObjectivePageContent> {
  /// confetti控制器
  final ConfettiController confettiController = ConfettiController();

  /// 是否正在播放
  bool hasPlayedConfetti = false;

  void openSelectIconPopup() {
    print('点击');
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) {
        return CaPopupFrameWork(
          title: 'Select Category Icon',
          // child: Container(),
          child: SelectCategoryImage(
            setSelectedImage: (String? str) {
              return '';
            },
            selectedImage: "assets/categories/${widget.category.iconName}",
          ),
        );
      },
    );
  }

  confettiListener() {
    if (mounted &&
        confettiController.state == ConfettiControllerState.playing) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        if (mounted) confettiController.stop();
      });
    }
  }

  @override
  void initState() {
    confettiController.addListener(confettiListener);
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CaPageFramework(
          appBarBackgroundColor:
              Theme.of(context).colorScheme.secondaryContainer,
          // backgroundColor: color,
          slivers: [
            SliverToBoxAdapter(
              child: Builder(builder: (context) {
                if (hasPlayedConfetti == false) {
                  confettiController.play();
                  hasPlayedConfetti = true;
                }
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: 40, bottom: 5),
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          /// 动画进度条
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Container(
                                  // 将宽和高限制在250 AspectRatio: 1 代表将高和宽限制为相同
                                  constraints:
                                      const BoxConstraints(maxWidth: 250),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: CaAnimateCircularProgress(
                                      // 百分比占比
                                      percent: clampDouble(0.6, 0, 1),
                                      // percent: 1.2,
                                      // 颜色
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondaryContainer,
                                      // 进度条颜色
                                      foregroundColor: dynamicPastel(
                                        context,
                                        Theme.of(context).colorScheme.primary,
                                        amountLight: 0.4,
                                        amountDark: 0.2,
                                      ),
                                      // 进度条宽度
                                      strokeWidth: 5,
                                      // 进度条进度宽度
                                      valueStrokeWidth: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// 圆环里面的种类和内容
                          Column(
                            children: [
                              /// 种类图标
                              TransactionCategoryIcon(
                                size: 40,
                                sizePadding: 30,
                                borderRadius: 100,
                                onLongPress: () => openSelectIconPopup(),
                                onTap: () => openSelectIconPopup(),
                                category: TransactionCategoryModel(
                                  categoryPk: "-1",
                                  name: "",
                                  dateCreated: DateTime.now(),
                                  dateTimeModified: null,
                                  order: 0,
                                  income: false,
                                  iconName: widget.category.iconName,
                                  colour: widget.category.colour,
                                  emojiIconName: widget.category.emojiIconName,
                                ),
                              ),

                              /// 占比
                              CountNumber(
                                // count: percentageTowardsGoal * 100,
                                count: 10,
                                duration: Duration(milliseconds: 1000),
                                initialCount: (0),
                                textBuilder: (value) {
                                  return TextFont(
                                    text: convertToPercent(
                                      value,
                                      // finalNumber: percentageTowardsGoal * 100,
                                      finalNumber: 10,
                                      useLessThanZero: true,
                                    ),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  );
                                },
                              ),
                              SizedBox(height: 10),

                              ///
                              const IntrinsicWidth(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFont(
                                      text: 'RM2888',
                                      textColor: Color(0xFF59A849),
                                      fontSize: 15,
                                    ),
                                    TextFont(
                                      text: '/',
                                      fontSize: 15,
                                    ),
                                    TextFont(
                                      text: 'RM28880',
                                      fontSize: 15,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              const IntrinsicWidth(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextFont(
                                      text: '已支付',
                                      textColor: Color(0xFF59A849),
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
        IgnorePointer(
          child: Align(
            alignment: AlignmentDirectional.topCenter,
            child: ConfettiWidget(
              shouldLoop: true,
              confettiController: confettiController,
              gravity: 0.2,
              blastDirectionality: BlastDirectionality.explosive,
              maximumSize: Size(15, 15),
              minimumSize: Size(10, 10),
              numberOfParticles: 50,
              canvas: Size.infinite,
            ),
          ),
        ),
      ],
    );
  }
}
