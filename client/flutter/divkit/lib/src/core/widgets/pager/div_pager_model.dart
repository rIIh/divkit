import 'package:divkit/divkit.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DivPagerModel with EquatableMixin {
  final Axis orientation;
  final List<Widget> children;
  final List<DivItemBuilderResult>? itemBuilderResults;

  const DivPagerModel({
    required this.orientation,
    required this.itemBuilderResults,
    required this.children,
  });

  @override
  List<Object?> get props => [
        orientation,
      ];
}

extension DivPagerConvereter on DivPager {
  DivPagerModel init(BuildContext context) {
    final divContext = read<DivContext>(context)!;
    final variables = divContext.variables;

    final orientation =
        _convertOrientation(this.orientation.resolve(variables));

    final List<Widget> children;
    final List<DivItemBuilderResult>? results;
    if (items != null) {
      results = null;
      children = [
        for (final item in items!) //
          DivWidget(item),
      ];
    } else if (itemBuilder != null && context.mounted) {
      children = const [];
      results = buildItemBuilderResults(
        builder: itemBuilder!,
        context: variables,
      );
    } else {
      children = const [];
      results = null;
    }

    return DivPagerModel(
      orientation: orientation,
      itemBuilderResults: results,
      children: children,
    );
  }

  DivPagerModel resolve(
    BuildContext context,
    PageController controller,
    ValueGetter<int> currentPage,
  ) {
    final divContext = read<DivContext>(context)!;

    final id = this.id;
    final variables = divContext.variables;

    final length = items?.length;
    if (id != null && length != null) {
      if (variables.current[id] != currentPage()) {
        controller.animateToPage(
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
          DivWidget(item),
      ];
    } else if (itemBuilder != null && context.mounted) {
      children = const [];
      results = buildItemBuilderResults(
        builder: itemBuilder!,
        context: variables,
      );
    } else {
      children = const [];
      results = null;
    }

    final orientation =
        _convertOrientation(this.orientation.resolve(variables));

    return DivPagerModel(
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
