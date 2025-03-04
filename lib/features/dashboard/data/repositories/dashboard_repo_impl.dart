import 'package:ecom/features/dashboard/data/datasource/dashboard_local_datasource.dart';
import 'package:ecom/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:ecom/features/dashboard/data/model/product_response.dart';
import 'package:ecom/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ecom/features/dashboard/domain/repositories/dashboard_repo.dart';
import 'package:ecom/router/connectivity.dart';

class DashboardRepoImpl extends DashboardRepo {
  final DashboardRemoteDatasource remoteDatasource;
  final DashboardLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  DashboardRepoImpl(
      {required this.remoteDatasource,
      required this.localDatasource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<ProductResponseModel>>> getProductList() async {
    if (await networkInfo.isConnected) {
      final data = await remoteDatasource.getProductList();
      if (data.isNotEmpty) {
        localDatasource.setProductList(data);
        return right(data);
      } else {
        final saveData = await localDatasource.getProductList();
        return right(saveData);
      }
    } else {
      final data = await localDatasource.getProductList();
      if (data.isEmpty) {
        return left(NetworkFailure());
      }
      return right(data);
    }
  }
}
