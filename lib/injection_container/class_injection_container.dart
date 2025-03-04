import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:ecom/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:ecom/features/dashboard/data/repositories/dashboard_repo_impl.dart';
import 'package:ecom/features/dashboard/domain/repositories/dashboard_repo.dart';
import 'package:ecom/features/dashboard/domain/usecase/fetch_product_list_usecase.dart';
import 'package:ecom/router/connectivity.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

// Dependency Injection
Future<void> init() async {
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectivity: sl()));

  // Datasource

  sl.registerLazySingleton<DashboardRemoteDatasource>(
      () => DashboardRemoteDatasourceImpl());

  sl.registerLazySingleton<DashboardLocalDatasource>(
      () => DashboardLocalDatasourceImpl());

  // Repo

  sl.registerLazySingleton<DashboardRepo>(() => DashboardRepoImpl(
        remoteDatasource: sl(),
        localDatasource: sl(),
        networkInfo: sl(),
      ));

  // Usecase
  sl.registerLazySingleton<FetchProductListUsecase>(
      () => FetchProductListUsecase(repo: sl()));
}
