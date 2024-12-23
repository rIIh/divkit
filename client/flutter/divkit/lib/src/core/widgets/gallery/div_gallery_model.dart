import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/converters/gallery_specific.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DivGalleryModel with EquatableMixin {
  final Axis orientation;
  final CrossAxisAlignment crossContentAlignment;
  final double itemSpacing;
  final List<DivItemBuilderResult>? itemBuilderResults;
  final List<Widget> children;

  const DivGalleryModel({
    required this.orientation,
    required this.crossContentAlignment,
    required this.itemSpacing,
    required this.itemBuilderResults,
    required this.children,
  });

  @override
  List<Object?> get props => [
        orientation,
        crossContentAlignment,
        itemSpacing,
        itemBuilderResults,
        children,
      ];
}

extension DivGalleryConverter on DivGallery {
  DivGalleryModel resolve(BuildContext context) {
    final divContext = read<DivContext>(context)!;
    final variables = divContext.variables;
    final viewScale = divContext.scale.view;

    final alignment = crossContentAlignment.resolve(variables).convert();
    final orientation = this.orientation.resolve(variables).convert();
    final itemSpacing =
        this.itemSpacing.resolve(variables).toDouble() * viewScale;

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

    return DivGalleryModel(
      crossContentAlignment: alignment,
      orientation: orientation,
      itemSpacing: itemSpacing,
      children: children,
      itemBuilderResults: results,
    );
  }
}
