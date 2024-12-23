import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/widgets/container/div_container_model.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
import 'package:divkit/src/utils/mapping_widget.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:flutter/widgets.dart';

class DivContainerWidget
    extends DivMappingWidget<DivContainer, DivContainerModel> {
  const DivContainerWidget(
    super.data, {
    super.key,
  });

  @override
  DivContainerModel value(BuildContext context) => data.resolve(context);

  @override
  Stream<DivContainerModel> stream(BuildContext context) =>
      watch<DivContext>(context)!.variableManager.watch(
            (values) => data.resolve(context),
          );

  Widget buildContainer(
    BuildContext context,
    DivContainerModel model,
    List<Widget> children,
  ) {
    final mainWidget = model.contentAlignment.map(
      flex: (data) => provide(
        data.direction == Axis.vertical
            ? DivParentData.column
            : DivParentData.row,
        child: Flex(
          mainAxisSize: MainAxisSize.min,
          direction: data.direction,
          mainAxisAlignment: data.mainAxisAlignment,
          crossAxisAlignment: data.crossAxisAlignment,
          children: children,
        ),
      ),
      wrap: (data) => provide(
        DivParentData.wrap,
        child: Wrap(
          direction: data.direction,
          alignment: data.wrapAlignment,
          runAlignment: data.runAlignment,
          children: children,
        ),
      ),
      stack: (data) => provide(
        DivParentData.stack,
        child: Stack(
          alignment: data.contentAlignment ?? AlignmentDirectional.topStart,
          children: children,
        ),
      ),
    );

    return DivBaseWidget(
      data: data,
      aspect: data.aspect?.ratio,
      tapActionData: DivTapActionData(
        action: data.action,
        actions: data.actions,
        longtapActions: data.longtapActions,
        actionAnimation: data.actionAnimation,
      ),
      child: mainWidget,
    );
  }

  @override
  Widget build(BuildContext context, DivContainerModel model) {
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

      return buildContainer(context, model, children);
    } else {
      return buildContainer(context, model, model.children);
    }
  }
}
