import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/a_list_bloc.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/a_list_state.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/controllers/i_list_controller.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/events/list_next_page_event.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/events/list_updated_event.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/models/a_list_item.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/models/page_data.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/states/list_loaded_state.dart';
import 'package:miro/blocs/abstract_blocs/abstract_list/states/list_loading_state.dart';
import 'package:miro/blocs/specific_blocs/list/favourites/favourites_bloc.dart';
import 'package:miro/blocs/specific_blocs/list/filters/filters_bloc.dart';
import 'package:miro/blocs/specific_blocs/list/infinity_list/events/infinity_list_reached_bottom_event.dart';
import 'package:miro/blocs/specific_blocs/list/sort/sort_bloc.dart';
import 'package:miro/shared/controllers/reload_notifier/reload_notifier_model.dart';
import 'package:miro/shared/utils/list_utils.dart';

class InfinityListBloc<T extends AListItem> extends AListBloc<T> {
  int lastPageIndex = 0;

  InfinityListBloc({
    required IListController<T> listController,
    required FiltersBloc<T> filterBloc,
    required SortBloc<T> sortBloc,
    required FavouritesBloc<T> favouritesBloc,
    required int singlePageSize,
    ReloadNotifierModel? reloadNotifierModel,
  }) : super(
          listController: listController,
          filtersBloc: filterBloc,
          sortBloc: sortBloc,
          favouritesBloc: favouritesBloc,
          reloadNotifierModel: reloadNotifierModel,
          singlePageSize: singlePageSize,
        ) {
    on<InfinityListReachedBottomEvent>(_mapInfinityListReachedBottomEventToState);
    on<ListUpdatedEvent>(_mapListUpdatedEventToState);
  }

  void _mapInfinityListReachedBottomEventToState(
    InfinityListReachedBottomEvent infinityListReachedBottomEvent,
    Emitter<AListState> emit,
  ) {
    if (currentPageData.isLastPage || pageDownloadingStatus) {
      return;
    }
    lastPageIndex += 1;
    add(ListNextPageEvent());
  }

  void _mapListUpdatedEventToState(ListUpdatedEvent listUpdatedEvent, Emitter<AListState> emit) {
    if (listUpdatedEvent.jumpToTop) {
      lastPageIndex = 0;
    }
    List<T> allListItems = _getAllPagesAsList();
    List<T> filteredListItems = filterList(allListItems);
    List<T> sortedListItems = sortList(filteredListItems);

    _updateCurrentPageData(sortedListItems);

    List<T> visibleListItems = ListUtils.getSafeSublist<T>(
      list: sortedListItems,
      start: 0,
      end: (lastPageIndex + 1) * singlePageSize,
    );

    emit(ListLoadingState());
    emit(ListLoadedState<T>(
      listItems: visibleListItems,
      lastPage: currentPageData.isLastPage,
    ));
  }

  List<T> _getAllPagesAsList() {
    List<T> allListItems = List<T>.empty(growable: true);
    for (PageData<T> pageData in downloadedPagesCache.values) {
      allListItems.addAll(pageData.listItems);
    }
    return allListItems;
  }

  void _updateCurrentPageData(List<T> allListItems) {
    List<T> currentPageItems = ListUtils.getSafeSublist<T>(
      list: allListItems,
      start: lastPageIndex * singlePageSize,
      end: (lastPageIndex + 1) * singlePageSize,
    );

    currentPageData = PageData<T>(
      index: lastPageIndex,
      listItems: currentPageItems,
      isLastPage: currentPageItems.length < singlePageSize,
    );
  }
}