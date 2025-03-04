import 'package:dartz/dartz.dart';
import 'package:ecom/failure.dart';
import 'package:ecom/features/dashboard/data/model/product_response.dart';

abstract class DashboardRepo {
  Future<Either<Failure, List<ProductResponseModel>>> getProductList();
}
