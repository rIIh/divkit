import 'package:collection/collection.dart';
import 'package:divkit/divkit.dart';

class DivItemBuilderResult {
  final Div div;
  final Map<String, dynamic> item;
  final Map<String, dynamic> variables;

  const DivItemBuilderResult({
    required this.div,
    required this.item,
    required this.variables,
  });
}

List<DivItemBuilderResult> buildChildren(DivCollectionItemBuilder builder) {
  final items = builder.data.value;
  final itemName = builder.dataElementName;
  final results = <DivItemBuilderResult>[];

  var index = 0;
  for (final item in items) {
    final selectors = [
      for (final prototype in builder.prototypes)
        [prototype, prototype.selector.value],
    ];

    final selected = selectors //
            .firstWhere((element) => element[1] == true)[0]
        as DivCollectionItemBuilderPrototype;

    final id = selected.id?.value;
    final Div result = selected.div.copy(id: id);

    results.add(
      DivItemBuilderResult(
        div: result,
        item: (item as Map).cast<String, dynamic>(),
        variables: {
          itemName: item,
          "index": index,
        },
      ),
    );
    index++;
  }

  return results;
}

List<DivItemBuilderResult> buildItemBuilderResults({
  required DivCollectionItemBuilder builder,
  required DivVariableContext context,
}) {
  final items = builder.data.resolve(context);
  var itemName = builder.dataElementName;
  if (itemName.isEmpty) itemName = 'it';

  final results = items.mapIndexed(
    (index, item) {
      final itemContext = DivVariableContext(
        current: {
          ...context.current,
          itemName: item,
          'index': index,
        },
      );

      final selectors = [
        for (final prototype in builder.prototypes)
          [
            prototype,
            exprResolver.resolve(prototype.selector, context: itemContext)
          ]
      ];

      final selected = selectors //
              .firstWhere((element) => element[1] == true)[0]
          as DivCollectionItemBuilderPrototype;

      final id = selected.id?.resolve(itemContext);
      final Div result = selected.div.copy(id: id);

      return DivItemBuilderResult(
        div: result,
        item: (item as Map).cast<String, dynamic>(),
        variables: {
          itemName: item,
          "index": index,
        },
      );
    },
  );

  return results.toList();
}

extension DivCopy on Div {
  Div copy({String? id}) {
    final value = this.value;
    id ??= value.id;

    if (value is DivImage) {
      return Div.divImage(value.copyWith(id: () => id));
    } else if (value is DivGifImage) {
      return Div.divGifImage(value.copyWith(id: () => id));
    } else if (value is DivText) {
      return Div.divText(value.copyWith(id: () => id));
    } else if (value is DivSeparator) {
      return Div.divSeparator(value.copyWith(id: () => id));
    } else if (value is DivContainer) {
      return Div.divContainer(
        value.copyWith(
          id: () => id,
          items: () => value.items?.map((it) => it.copy()).toList(),
        ),
      );
    } else if (value is DivGrid) {
      return Div.divGrid(
        value.copyWith(
          id: () => id,
          items: () => value.items?.map((it) => it.copy()).toList(),
        ),
      );
    } else if (value is DivGallery) {
      return Div.divGallery(
        value.copyWith(
          id: () => id,
          items: () => value.items?.map((it) => it.copy()).toList(),
        ),
      );
    } else if (value is DivPager) {
      return Div.divPager(
        value.copyWith(
          id: () => id,
          items: () => value.items?.map((it) => it.copy()).toList(),
        ),
      );
    } else if (value is DivTabs) {
      return Div.divTabs(
        value.copyWith(
          id: () => id,
          items: value.items //
              .map((it) => it.copyWith(div: it.div.copy()))
              .toList(),
        ),
      );
    } else if (value is DivState) {
      return Div.divState(
        value.copyWith(
          id: () => id,
          divId: () => id,
          states: value.states
              .map((e) => e.copyWith(div: () => e.div?.copy()))
              .toList(),
        ),
      );
    } else if (value is DivCustom) {
      return Div.divCustom(value.copyWith(id: () => id));
    } else if (value is DivIndicator) {
      return Div.divIndicator(value.copyWith(id: () => id));
    } else if (value is DivSlider) {
      return Div.divSlider(value.copyWith(id: () => id));
    } else if (value is DivInput) {
      return Div.divInput(value.copyWith(id: () => id));
    } else if (value is DivSelect) {
      return Div.divSelect(value.copyWith(id: () => id));
    } else if (value is DivVideo) {
      return Div.divVideo(value.copyWith(id: () => id));
    }

    logger.warning("Failed to copy div - ${value.runtimeType}");
    return this;
  }
}
