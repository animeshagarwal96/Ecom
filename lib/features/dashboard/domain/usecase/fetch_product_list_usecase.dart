import 'package:dartz/dartz.dart';
import 'package:ecom/failure.dart';
import 'package:ecom/features/dashboard/data/model/product_response.dart';
import 'package:ecom/features/dashboard/domain/repositories/dashboard_repo.dart';
import 'package:ecom/httpclient/usecase.dart';

class FetchProductListUsecase
    extends UseCase<List<ProductResponseModel>, NoParams> {
  final DashboardRepo repo;

  FetchProductListUsecase({required this.repo});

  @override
  Future<Either<Failure, List<ProductResponseModel>>> call(
      NoParams params) async {
    return await repo.getProductList();
  }
}
