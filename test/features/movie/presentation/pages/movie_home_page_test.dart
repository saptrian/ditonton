import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/features/movie/domain/entities/movie.dart';
import 'package:ditonton/features/movie/presentation/bloc/bloc_export.dart';
import 'package:ditonton/features/movie/presentation/pages/page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_home_page_test.mocks.dart';

@GenerateMocks([MovieListBloc])
void main() {
  late MockMovieListBloc mockMovieListBloc;

  setUp(() {
    mockMovieListBloc = MockMovieListBloc();

    // Stub the stream and close methods
    when(mockMovieListBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockMovieListBloc.state).thenReturn(const MovieListState());
    when(mockMovieListBloc.close()).thenAnswer((_) async {
      return;
    });
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieListBloc>.value(
      value: mockMovieListBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('should display CircularProgressIndicator when state is loading',
      (WidgetTester tester) async {
    // Arrange
    when(mockMovieListBloc.state).thenReturn(const MovieListState(
      movieNowPlayingState: RequestState.loading,
      movieNowPlaying: [],
      moviePopularState: RequestState.loading,
      moviePopular: [],
      movieTopRatedState: RequestState.loading,
      movieTopRated: [],
    ));

    // Act
    await tester.pumpWidget(makeTestableWidget(const MovieHomePage()));
    await tester.pump();

    // Assert
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display MovieList when state is loaded',
      (WidgetTester tester) async {
    // Arrange
    final movies = [
      Movie(
        id: 1,
        title: 'Test Movie',
        overview: 'Test Overview',
        posterPath: '/test.jpg',
      ),
    ];
    when(mockMovieListBloc.state).thenReturn(MovieListState(
      movieNowPlayingState: RequestState.loaded,
      movieNowPlaying: movies,
      moviePopularState: RequestState.loaded,
      moviePopular: movies,
      movieTopRatedState: RequestState.loaded,
      movieTopRated: movies,
    ));

    // Act
    await tester.pumpWidget(makeTestableWidget(const MovieHomePage()));
    await tester.pump();

    // Assert
    expect(find.byType(MovieList), findsNWidgets(3));
  });

  testWidgets('should display error message when state is error',
      (WidgetTester tester) async {
    // Arrange
    when(mockMovieListBloc.state).thenReturn(const MovieListState(
      movieNowPlayingState: RequestState.error,
      movieNowPlaying: [],
      moviePopularState: RequestState.error,
      moviePopular: [],
      movieTopRatedState: RequestState.error,
      movieTopRated: [],
    ));

    // Act
    await tester.pumpWidget(makeTestableWidget(const MovieHomePage()));
    await tester.pump();

    // Assert
    expect(find.text('Failed'), findsWidgets);
  });
}
