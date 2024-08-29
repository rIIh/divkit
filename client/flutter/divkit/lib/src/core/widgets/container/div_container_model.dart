import 'package:divkit/divkit.dart';
import 'package:divkit/src/utils/content_alignment_converters.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class DivContainerModel with EquatableMixin {
  final List<Widget> children;
  final List<DivItemBuilderResult> itemBuilderResults;
  final ContentAlignment contentAlignment;

  const DivContainerModel({
    required this.contentAlignment,
    this.children = const [],
    this.itemBuilderResults = const [],
    this.aspectRatio,
  });

  static DivContainerModel? value(
    BuildContext buildContext,
    DivContainer data,
  ) {
    try {
      final contentAlignment = PassDivContentAlignment(
        data.orientation,
        data.contentAlignmentVertical,
        data.contentAlignmentHorizontal,
        data.layoutMode,
      ).requireValue;

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

      return DivContainerModel(
        contentAlignment: contentAlignment,
        aspectRatio: data.aspect?.ratio.requireValue,
        children: children,
        itemBuilderResults: results,
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

  static Stream<DivContainerModel> from(
    BuildContext buildContext,
    DivContainer data,
  ) {
    final variables = watch<DivContext>(buildContext)!.variableManager;

    return variables.watch<DivContainerModel>((context) async {
      final contentAlignment = await PassDivContentAlignment(
        data.orientation,
        data.contentAlignmentVertical,
        data.contentAlignmentHorizontal,
        data.layoutMode,
      ).resolve(
        context: context,
      );

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

      return DivContainerModel(
        contentAlignment: contentAlignment,
        aspectRatio: await data.aspect?.ratio.resolveValue(
          context: context,
        ),
        children: children,
        itemBuilderResults: results,
      );
    }).distinct(); // The widget is redrawn when the model changes.
  }

  @override
  List<Object?> get props => [
        children,
        itemBuilderResults,
        contentAlignment,
      ];
}
