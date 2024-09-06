import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/widgets/pager/div_pager_model.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:divkit/src/utils/size_axis_extension.dart';
import 'package:flutter/material.dart';

class DivPagerWidget extends StatefulWidget {
  final DivPager data;

  const DivPagerWidget(
    this.data, {
    super.key,
  });

  @override
  State<DivPagerWidget> createState() => _DivPagerWidgetState();
}

class _DivPagerWidgetState extends State<DivPagerWidget> {
  DivPagerModel? value;
  Stream<DivPagerModel>? stream;

  late int currentPage;
  late PageController controller;

  late DivPager dataWithoutPaddings;

  @override
  void initState() {
    value = DivPagerModel.value(context, widget.data);
    currentPage = widget.data.defaultItem.value ?? 0;
    controller = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    stream ??= DivPagerModel.from(
      context,
      widget.data,
      () => controller,
      () => currentPage,
    );
  }

  @override
  void didUpdateWidget(covariant DivPagerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data) {
      value = DivPagerModel.value(context, widget.data);
      stream = DivPagerModel.from(
        context,
        widget.data,
        () => controller,
        () => currentPage,
      );
    }
  }

  @override
  Widget build(BuildContext context) => DivBaseWidget(
        ignorePaddings: true,
        data: widget.data,
        child: StreamBuilder<DivPagerModel>(
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

              return LayoutBuilder(
                builder: (context, constraints) {
                  updateViewportFraction(model, constraints);

                  return PageView.builder(
                    controller: controller,
                    scrollDirection: model.orientation,
                    onPageChanged: (value) => onPageChanged(value),
                    itemCount: model.isInfinite ? null : model.children.length,
                    itemBuilder: (context, index) => model.children.isNotEmpty
                        ? buildItem(
                            itemSpacing: model.itemSpacing,
                            child: children[index % model.children.length],
                          )
                        : null,
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      );

  void onPageChanged(int value) {
    currentPage = value;
    final id = widget.data.id;
    if (id != null) {
      final divContext = DivKitProvider.watch<DivContext>(context)!;
      divContext.variableManager.updateVariable(id, currentPage);
    }
  }

  void updateViewportFraction(
    DivPagerModel model,
    BoxConstraints constraints,
  ) {
    final padding = model.padding;
    final viewportFractionPadding = padding.along(
      model.orientation,
    );

    final viewportFraction = 1 +
        (model.itemSpacing - viewportFractionPadding) /
            constraints.biggest.along(model.orientation);

    if (controller.viewportFraction != viewportFraction) {
      controller = PageController(
        initialPage: controller.initialPage,
        viewportFraction: viewportFraction,
      );
    }
  }

  Widget buildItem({required Widget child, required double itemSpacing}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: itemSpacing / 2,
        ),
        child: child,
      );

  @override
  void dispose() {
    stream = null;
    super.dispose();
  }
}
