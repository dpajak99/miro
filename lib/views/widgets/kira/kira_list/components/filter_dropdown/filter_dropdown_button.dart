import 'package:flutter/material.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/models/a_list_item.dart';
import 'package:miro/config/theme/design_colors.dart';
import 'package:miro/views/widgets/generic/responsive/responsive_value.dart';
import 'package:miro/views/widgets/generic/responsive/responsive_widget.dart';
import 'package:miro/views/widgets/kira/kira_list/models/filter_option_model.dart';

class FilterDropdownButton<T extends AListItem> extends StatelessWidget {
  final List<FilterOptionModel<T>> filterOptionModelList;

  const FilterDropdownButton({
    required this.filterOptionModelList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    String filtersTitle = 'All';
    if (filterOptionModelList.isNotEmpty) {
      filtersTitle = filterOptionModelList.map((FilterOptionModel<T> filterOptionModel) => filterOptionModel.title).join(', ');
    }

    return Container(
      padding: const ResponsiveValue<EdgeInsets>(
        largeScreen: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        smallScreen: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      ).get(context),
      decoration: BoxDecoration(
        border: Border.all(
          color: DesignColors.gray2_100,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              filtersTitle,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: textTheme.caption!.copyWith(
                color: DesignColors.gray2_100,
              ),
            ),
          ),
          if (ResponsiveWidget.isSmallScreen(context) == false) ...<Widget>[
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: DesignColors.gray2_100,
              size: 15,
            ),
          ],
        ],
      ),
    );
  }
}