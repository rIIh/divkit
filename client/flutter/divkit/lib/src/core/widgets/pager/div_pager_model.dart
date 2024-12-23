import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/converters/converters.dart';
import 'package:divkit/src/core/converters/edge_insets.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DivPagerModel with EquatableMixin {
  final Axis orientation;
  final EdgeInsetsGeometry padding;
  final double itemSpacing;
  final bool isInfinite;
  final List<Widget> children;
  final List<DivItemBuilderResult>? itemBuilderResults;

  const DivPagerModel({
    required this.children,
    required this.itemSpacing,
    required this.itemBuilderResults,
    required this.orientation,
    required this.isInfinite,
    required this.padding,
  });

  @override
  List<Object?> get props => [
        orientation,
        isInfinite,
        itemSpacing,
        padding,
        itemBuilderResults,
        children,
      ];
}

extension DivPagerConvereter on DivPager {
  DivPagerModel init(BuildContext context) {
    final divContext = read<DivContext>(context)!;
    final variables = divContext.variables;

    final viewScale = divContext.scale.view;

    final orientation =
        _convertOrientation(this.orientation.resolve(variables));
    final isInfinite = infiniteScroll.value;
    final padding = paddings.resolve(variables, viewScale: viewScale);

    final itemSpacingUnit = this.itemSpacing.unit.value.asPx;
    final itemSpacing = this.itemSpacing.value.value * itemSpacingUnit;

    final List<Widget> children;
    final List<DivItemBuilderResult>? results;
    if (items != null) {
      results = null;
      children = [
        for (final item in items!) //
          if (item.value.visibility.resolve(variables) != DivVisibility.gone)
            DivWidget(item),
      ];
    } else if (itemBuilder != null && context.mounted) {
      children = const [];
      results = buildItemBuilderResults(
        builder: itemBuilder!,
        context: variables,
      )
          .where(
            (element) =>
                element.div.value.visibility.resolve(variables) !=
                DivVisibility.gone,
          )
          .toList();
    } else {
      children = const [];
      results = null;
    }

    return DivPagerModel(
      padding: padding,
      isInfinite: isInfinite,
      itemSpacing: itemSpacing,
      orientation: orientation,
      itemBuilderResults: results,
      children: children,
    );
  }

  DivPagerModel resolve(
    BuildContext context,
    ValueGetter<PageController> controller,
    ValueGetter<int> currentPage,
  ) {
    final divContext = read<DivContext>(context)!;

    final id = this.id;
    final variables = divContext.variables;
    final viewScale = divContext.scale.view;

    if (id != null && variables.current[id] == null) {
      divContext.variableManager.putVariable(id, currentPage());
    }

    final isInfinite = infiniteScroll.resolve(variables);

    final length = items?.length;
    if (id != null && length != null) {
      if (variables.current[id] < 0) {
        divContext.variableManager.updateVariable(id, 0);
      }

      if (variables.current[id] > length - 1 && !isInfinite) {
        divContext.variableManager.updateVariable(id, length - 1);
      }

      if (variables.current[id] != currentPage()) {
        controller().animateToPage(
          variables.current[id],
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    }

    final List<Widget> children;
    final List<DivItemBuilderResult>? results;
    if (items != null) {
      results = null;
      children = [
        for (final item in items!) //
          if (item.value.visibility.resolve(variables) != DivVisibility.gone)
            DivWidget(item),
      ];
    } else if (itemBuilder != null && context.mounted) {
      children = const [];
      results = buildItemBuilderResults(
        builder: itemBuilder!,
        context: variables,
      )
          .where(
            (element) =>
                element.div.value.visibility.resolve(variables) !=
                DivVisibility.gone,
          )
          .toList();
    } else {
      children = const [];
      results = null;
    }

    final orientation =
        _convertOrientation(this.orientation.resolve(variables));
    final padding = paddings.resolve(variables, viewScale: viewScale);

    final itemSpacingUnit = this.itemSpacing.unit.value.asPx;
    final itemSpacing = this.itemSpacing.value.value * itemSpacingUnit;

    return DivPagerModel(
      padding: padding,
      isInfinite: isInfinite,
      itemSpacing: itemSpacing,
      orientation: orientation,
      itemBuilderResults: results,
      children: children,
    );
  }

  static Axis _convertOrientation(DivPagerOrientation orientation) {
    switch (orientation) {
      case DivPagerOrientation.horizontal:
        return Axis.horizontal;
      case DivPagerOrientation.vertical:
        return Axis.vertical;
    }
  }
}
