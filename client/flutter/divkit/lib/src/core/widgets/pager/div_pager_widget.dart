import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/widgets/pager/div_pager_model.dart';
import 'package:divkit/src/utils/div_item_builder_utils.dart';
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
    super.initState();
    final divContext = read<DivContext>(context)!;
    final variables = divContext.variables;
    value = widget.data.init(context);

    final length = widget.data.items?.length ?? 0;
    currentPage = widget.data.defaultItem.resolve(variables).clamp(0, length);

    final id = widget.data.id;
    if (id != null && !variables.current.containsKey(id)) {
      divContext.variableManager.putVariable(id, currentPage);
    }

    controller = PageController(initialPage: currentPage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    stream = watch<DivContext>(context)!.variableManager.watch((values) {
      return widget.data.resolve(
        context,
        () => controller,
        () => currentPage,
      );
    });
  }

  @override
  void didUpdateWidget(covariant DivPagerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data) {
      value = widget.data.init(context);
      stream = watch<DivContext>(context)!.variableManager.watch(
            (values) => widget.data.resolve(
              context,
              () => controller,
              () => currentPage,
            ),
          );
    }
  }

  Widget buildPager(
    BuildContext context,
    DivPagerModel model,
    List<Widget> children,
  ) {
    return DivBaseWidget(
      data: widget.data,
      ignorePaddings: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          updateViewportFraction(model, constraints);

          return provide(
            DivParentData.pager,
            child: PageView.builder(
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
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<DivPagerModel>(
        initialData: value,
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final model = snapshot.data!;

            if (widget.data.itemBuilder != null) {
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

              return buildPager(context, model, children);
            } else {
              return buildPager(context, model, model.children);
            }
          }

          return const SizedBox.shrink();
        },
      );

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

  void onPageChanged(int value) {
    final length = widget.data.items?.length ?? 0;
    currentPage = value.clamp(0, length);
    final id = widget.data.id;
    if (id != null) {
      final divContext = watch<DivContext>(context)!;
      divContext.variableManager.updateVariable(id, currentPage);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    value = null;
    stream = null;
    super.dispose();
  }
}
