import 'package:carousel_slider/carousel_slider.dart';
import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/widgets/pager/div_pager_model.dart';
import 'package:divkit/src/utils/provider.dart';
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
  late CarouselSliderController controller;

  late DivPager dataWithoutPaddings;

  @override
  void initState() {
    super.initState();
    value = DivPagerModel.value(context, widget.data);
    currentPage = widget.data.defaultItem.value ?? 0;
    controller = CarouselSliderController();
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
        data: widget.data.copyWith(paddings: const DivEdgeInsets()),
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
                  final padding = model.padding;
                  final viewportFractionPadding =
                      model.orientation == Axis.horizontal
                          ? padding.horizontal
                          : padding.vertical;

                  final viewportFraction = 1 +
                      (model.itemSpacing - viewportFractionPadding) /
                          constraints.maxWidth;

                  return provide(
                    DivParentData.pager,
                    child: CarouselSlider(
                      carouselController: controller,
                      options: CarouselOptions(
                        viewportFraction: viewportFraction,
                        clipBehavior: Clip.none,
                        enableInfiniteScroll: model.isInfinite,
                        initialPage: widget.data.defaultItem.value ?? 0,
                        onPageChanged: (value, _) => onPageChanged(value),
                        scrollDirection: model.orientation,
                      ),
                      items: [
                        for (final child in children)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: model.itemSpacing / 2,
                            ),
                            child: child,
                          ),
                      ],
                    ),
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
      final divContext = watch<DivContext>(context)!;
      divContext.variableManager.updateVariable(id, currentPage);
    }
  }

  @override
  void dispose() {
    value = null;
    stream = null;
    super.dispose();
  }
}
