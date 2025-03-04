import 'package:ecom/features/dashboard/presentation/bloc/bloc/dashboard_product_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

// Dependency Injection
Future<void> init() async {
  sl.registerLazySingleton<DashboardProductBloc>(
      () => DashboardProductBloc(fetchProductListUsecase: sl()));
}
