import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/converters/content_alignment.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DivContainerModel with EquatableMixin {
  final List<Widget> children;
  final List<DivItemBuilderResult>? itemBuilderResults;
  final ContentAlignment contentAlignment;
  final bool clipToBounds;

  const DivContainerModel({
    required this.contentAlignment,
    this.children = const [],
    this.itemBuilderResults,
    this.clipToBounds = true,
  });

  @override
  List<Object?> get props => [
        children,
        itemBuilderResults,
        contentAlignment,
      ];
}

extension DivContainerConvert on DivContainer {
  DivContainerModel resolve(BuildContext context) {
    final variables = read<DivContext>(context)!.variables;

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

    return DivContainerModel(
      contentAlignment: DivContentAlignmentConverter(
        orientation,
        contentAlignmentVertical,
        contentAlignmentHorizontal,
        layoutMode,
      ).resolve(variables),
      itemBuilderResults: results,
      children: children,
    );
  }
}
