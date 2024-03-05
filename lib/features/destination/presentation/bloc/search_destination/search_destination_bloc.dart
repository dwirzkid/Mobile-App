import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:course_travel/features/destination/domain/entities/destination_entity.dart';
import 'package:course_travel/features/destination/domain/usecases/search_destination_usecase.dart';
import 'package:equatable/equatable.dart';

part 'search_destination_event.dart';
part 'search_destination_state.dart';

class SearchDestinationBloc 
    extends Bloc<SearchDestinationEvent, SearchDestinationState> {
  final SearchDestinationUseCase _useCase;

  SearchDestinationBloc(this._useCase) : super(SearchDestinationInitial()) {
    on<OnSearchDestination>((event, emit) async{
      emit(SearchDestinationLoading());
      final result = await _useCase(query: event.query);
      result.fold(
        ( failure ) => emit(SearchDestinationFailure(failure.message)),
        (data) => emit(SearchDestinationLoaded(data)),
      );
    });
    on<OnResetSearchDestination>((event, emit){
      emit(SearchDestinationInitial());
    });
  }
}
