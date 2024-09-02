import 'package:carousel_slider/carousel_controller.dart';
import 'package:divkit/divkit.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/div_scaling_model.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DivPagerModel with EquatableMixin {
  final List<Widget> children;
  final List<DivItemBuilderResult> itemBuilderResults;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;
  final bool isInfinite;
  final Axis orientation;

  const DivPagerModel({
    required this.children,
    required this.itemSpacing,
    required this.itemBuilderResults,
    required this.orientation,
    required this.isInfinite,
    required this.padding,
  });

  static DivPagerModel? value(
    BuildContext buildContext,
    DivPager data,
  ) {
    try {
      final divScalingModel = read<DivScalingModel>(buildContext);
      final viewScale = divScalingModel?.viewScale ?? 1;

      final rawOrientation = data.orientation.requireValue;
      final orientation = _convertOrientation(rawOrientation);
      final isInfinite = data.infiniteScroll.requireValue;
      final padding = data.paddings.value(viewScale: viewScale);

      final itemSpacingUnit = data.itemSpacing.unit.requireValue.asPx;
      final itemSpacing = data.itemSpacing.value.requireValue * itemSpacingUnit;

      final List<Widget> children;
      final List<DivItemBuilderResult> results;
      if (data.items != null) {
        results = const [];
        children = [
          for (final item in data.items!) //
            DivWidget(item),
        ];
      } else if (data.itemBuilder != null) {
        children = const [];
        results = buildChildren(data.itemBuilder!);
      } else {
        children = const [];
        results = const [];
      }

      return DivPagerModel(
        children: children,
        padding: padding,
        isInfinite: isInfinite,
        itemSpacing: itemSpacing,
        itemBuilderResults: results,
        orientation: orientation,
      );
    } catch (e, st) {
      logger.warning(
        'Expression cache is corrupted! Instant rendering is not available for div',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  static Stream<DivPagerModel> from(
    BuildContext buildContext,
    DivPager data,
    ValueGetter<CarouselSliderController> controller,
    ValueGetter<int> currentPage,
  ) {
    final variables = watch<DivContext>(buildContext)!.variableManager;
    final divScalingModel = watch<DivScalingModel>(buildContext);
    final viewScale = divScalingModel?.viewScale ?? 1;

    final id = data.id;
    if (id != null && variables.context.current[id] != currentPage()) {
      variables.putVariable(id, currentPage());
    }
    return variables.watch<DivPagerModel>((context) async {
      final length = data.items?.length;
      if (id != null && length != null) {
        if (variables.context.current[id] < 0) {
          variables.updateVariable(id, 0);
        }
        if (variables.context.current[id] > length - 1) {
          variables.updateVariable(id, length - 1);
        }
        if (variables.context.current[id] != currentPage()) {
          controller().animateToPage(
            variables.context.current[id],
            duration: const Duration(milliseconds: 200),
            curve: Curves.linear,
          );
        }
      }

      final rawOrientation = await data.orientation.resolveValue(
        context: context,
      );
      final orientation = _convertOrientation(rawOrientation);
      final padding = await data.paddings.resolve(
        context: context,
        viewScale: viewScale,
      );

      final isInfinite = await data.infiniteScroll //
          .resolveValue(context: context);

      final itemSpacingUnit =
          (await data.itemSpacing.unit.resolveValue(context: context)).asPx;
      final itemSpacing =
          await data.itemSpacing.value.resolveValue(context: context) *
              itemSpacingUnit;

      final List<Widget> children;
      final List<DivItemBuilderResult> results;
      if (data.items != null) {
        results = const [];
        await Future.wait(
          (data.items ?? [])
              .map((e) => e.value.visibility.resolveValue(context: context)),
        );

        children = [
          for (final item in data.items!) //
            if (item.value.visibility.requireValue != DivVisibility.gone)
              DivWidget(item),
        ];
      } else if (data.itemBuilder != null && buildContext.mounted) {
        children = const [];
        results = await buildChildrenAsync(
          builder: data.itemBuilder!,
          context: context,
        ).then(
          (results) => [
            for (final result in results)
              if (result.div.value.visibility.requireValue !=
                  DivVisibility.gone)
                result
          ],
        );
      } else {
        children = const [];
        results = const [];
      }

      return DivPagerModel(
        children: children,
        padding: padding,
        isInfinite: isInfinite,
        itemSpacing: itemSpacing,
        itemBuilderResults: results,
        orientation: orientation,
      );
    }).distinct();
  }

  @override
  List<Object?> get props => [
        orientation,
        isInfinite,
        itemSpacing,
        padding,
        itemBuilderResults,
        children,
      ];

  static Axis _convertOrientation(DivPagerOrientation orientation) {
    switch (orientation) {
      case DivPagerOrientation.horizontal:
        return Axis.horizontal;
      case DivPagerOrientation.vertical:
        return Axis.vertical;
    }
  }
}
