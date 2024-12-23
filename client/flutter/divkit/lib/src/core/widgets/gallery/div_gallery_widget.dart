import 'package:collection/collection.dart';
import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/widgets/gallery/div_gallery_model.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/mapping_widget.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:flutter/widgets.dart';

class DivGalleryWidget extends DivMappingWidget<DivGallery, DivGalleryModel> {
  const DivGalleryWidget(
    super.data, {
    super.key,
  });

  @override
  DivGalleryModel value(BuildContext context) => data.resolve(context);

  @override
  Stream<DivGalleryModel> stream(BuildContext context) =>
      watch<DivContext>(context)!.variableManager.watch(
            (values) => data.resolve(context),
          );

  Widget buildGallery(
    BuildContext context,
    DivGalleryModel model,
    List<Widget> children,
  ) {
    final isHorizontal = model.orientation == Axis.horizontal;

    final childrenWithSpacing = model.children
        .mapIndexed((i, element) {
          final isLastElement = i == model.children.length - 1;
          final spacing = isLastElement ? 0.0 : model.itemSpacing;
          return [
            element,
            SizedBox(
              width: isHorizontal ? spacing : null,
              height: isHorizontal ? null : spacing,
            ),
          ];
        })
        .expand((element) => element)
        .toList();

    return DivBaseWidget(
      data: data,
      child: SingleChildScrollView(
        scrollDirection: model.orientation,
        child: provide(
          isHorizontal ? DivParentData.row : DivParentData.column,
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: isHorizontal ? Axis.horizontal : Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: childrenWithSpacing,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, DivGalleryModel model) {
    if (data.itemBuilder != null) {
      final children = [
        for (final result in model.itemBuilderResults ?? [])
          provide<DivContext>(
            DivAdditionalVariablesContext(
              buildContext: context,
              variables: [
                for (final variable in result.variables.entries)
                  DivVariableModel(
                    name: variable.key,
                    value: variable.value,
                  ),
              ],
            ),
            child: DivWidget(result.div),
          )
      ];

      return buildGallery(context, model, children);
    } else {
      return buildGallery(context, model, model.children);
    }
  }
}
