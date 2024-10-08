import 'package:ditonton/features/tv/data/datasources/db/tv_database_helper.dart';
import 'package:ditonton/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/features/tv/domain/repositories/tv_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  TvDatabaseHelper,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
