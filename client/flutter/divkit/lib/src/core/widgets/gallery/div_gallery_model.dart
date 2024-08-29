import 'package:divkit/divkit.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/div_scaling_model.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DivGalleryModel with EquatableMixin {
  final List<Widget> children;
  final List<DivItemBuilderResult> itemBuilderResults;
  final CrossAxisAlignment crossContentAlignment;
  final Axis orientation;
  final double itemSpacing;

  const DivGalleryModel({
    this.children = const [],
    this.itemBuilderResults = const [],
    required this.crossContentAlignment,
    required this.orientation,
    required this.itemSpacing,
  });

  static DivGalleryModel? value(
    BuildContext buildContext,
    DivGallery data,
  ) {
    try {
      final divScalingModel = read<DivScalingModel>(buildContext);
      final viewScale = divScalingModel?.viewScale ?? 1;

      final rawAlignment = data.crossContentAlignment.value!;
      final alignment = _convertAlignment(rawAlignment);

      final rawOrientation = data.orientation.value!;
      final orientation = _convertOrientation(rawOrientation);

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

      return DivGalleryModel(
        children: children,
        itemBuilderResults: results,
        crossContentAlignment: alignment,
        orientation: orientation,
        itemSpacing: data.itemSpacing.value!.toDouble() * viewScale,
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

  static Stream<DivGalleryModel> from(
    BuildContext buildContext,
    DivGallery data,
  ) {
    final variables = watch<DivContext>(buildContext)!.variableManager;

    final divScalingModel = watch<DivScalingModel>(buildContext);
    final viewScale = divScalingModel?.viewScale ?? 1;

    return variables.watch<DivGalleryModel>((context) async {
      final rawAlignment = await data.crossContentAlignment.resolveValue(
        context: context,
      );
      final alignment = _convertAlignment(rawAlignment);

      final rawOrientation = await data.orientation.resolveValue(
        context: context,
      );
      final orientation = _convertOrientation(rawOrientation);

      final List<Widget> children;
      final List<DivItemBuilderResult> results;
      if (data.items != null) {
        results = const [];
        children = [
          for (final item in data.items!) //
            DivWidget(item),
        ];
      } else if (data.itemBuilder != null && buildContext.mounted) {
        children = const [];
        results = await buildChildrenAsync(
          builder: data.itemBuilder!,
          context: context,
        );
      } else {
        children = const [];
        results = const [];
      }

      return DivGalleryModel(
        children: children,
        itemBuilderResults: results,
        crossContentAlignment: alignment,
        orientation: orientation,
        itemSpacing: (await data.itemSpacing.resolveValue(
              context: context,
            ))
                .toDouble() *
            viewScale,
      );
    }).distinct();
  }

  @override
  List<Object?> get props => [
        crossContentAlignment,
        orientation,
        itemSpacing,
        itemBuilderResults,
        children,
      ];

  static CrossAxisAlignment _convertAlignment(
    DivGalleryCrossContentAlignment alignment,
  ) {
    switch (alignment) {
      case DivGalleryCrossContentAlignment.start:
        return CrossAxisAlignment.start;
      case DivGalleryCrossContentAlignment.center:
        return CrossAxisAlignment.center;
      case DivGalleryCrossContentAlignment.end:
        return CrossAxisAlignment.end;
    }
  }

  static Axis _convertOrientation(DivGalleryOrientation orientation) {
    switch (orientation) {
      case DivGalleryOrientation.horizontal:
        return Axis.horizontal;
      case DivGalleryOrientation.vertical:
        return Axis.vertical;
    }
  }
}
