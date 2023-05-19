import 'package:miro/blocs/widgets/kira/kira_list/abstract_list/a_list_state.dart';

class ListLoadedState<T> extends AListState {
  final List<T> listItems;
  final bool lastPage;

  const ListLoadedState({
    required this.listItems,
    required this.lastPage,
  });

  @override
  List<Object?> get props => <Object?>[listItems, lastPage];
}