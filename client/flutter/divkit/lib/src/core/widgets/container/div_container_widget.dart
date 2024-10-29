import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/widgets/container/div_container_model.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:flutter/widgets.dart';

class DivContainerWidget extends StatefulWidget {
  final DivContainer data;

  const DivContainerWidget(
    this.data, {
    super.key,
  });

  @override
  State<DivContainerWidget> createState() => _DivContainerWidgetState();
}

class _DivContainerWidgetState extends State<DivContainerWidget> {
  DivContainerModel? value;
  Stream<DivContainerModel>? stream;

  @override
  void initState() {
    super.initState();
    value = DivContainerModel.value(context, widget.data);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    stream ??= DivContainerModel.from(context, widget.data);
  }

  @override
  void didUpdateWidget(covariant DivContainerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data) {
      value = DivContainerModel.value(context, widget.data);
      stream = DivContainerModel.from(context, widget.data);
    }
  }

  @override
  Widget build(BuildContext context) => DivBaseWidget(
        data: widget.data,
        aspect: widget.data.aspect?.ratio,
        tapActionData: DivTapActionData(
          action: widget.data.action,
          actions: widget.data.actions,
          longtapActions: widget.data.longtapActions,
          actionAnimation: widget.data.actionAnimation,
        ),
        child: StreamBuilder<DivContainerModel>(
          initialData: value,
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final model = snapshot.requireData;
              final List<Widget> children;
              if (widget.data.itemBuilder != null) {
                children = [
                  for (final result in model.itemBuilderResults)
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
              } else {
                children = model.children;
              }

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
                    clipBehavior: Clip.none,
                    alignment:
                        data.contentAlignment ?? AlignmentDirectional.topStart,
                    children: children,
                  ),
                ),
              );

              return ClipRect(
                clipBehavior: model.clipToBounds ? Clip.hardEdge : Clip.none,
                child: mainWidget,
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );

  @override
  void dispose() {
    value = null;
    stream = null;
    super.dispose();
  }
}
