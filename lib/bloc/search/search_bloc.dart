import 'package:bloc/bloc.dart';
import 'package:dtube_go/bloc/search/search_event.dart';
import 'package:dtube_go/bloc/search/search_state.dart';
import 'package:dtube_go/bloc/search/search_response_model.dart';
import 'package:dtube_go/bloc/search/search_repository.dart';
import 'package:dtube_go/utils/SecureStorage.dart' as sec;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchRepository repository;

  SearchBloc({required this.repository}) : super(SearchInitialState());

  // @override

  // SearchState get initialState => SearchInitialState();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    String _avalonApiNode = await sec.getNode();
    String _currentUser = await sec.getUsername();
    if (event is FetchSearchResultsEvent) {
      yield SearchLoadingState();
      try {
        SearchResults results = await repository.getSearchResults(
            event.searchQuery,
            event.searchEntity,
            _avalonApiNode,
            _currentUser);

        yield SearchLoadedState(searchResults: results);
      } catch (e) {
        yield SearchErrorState(message: e.toString());
      }
    }
    if (event is SetSearchInitialState) {
      yield SearchInitialState();
    }
  }
}
