import 'dart:convert';

import 'package:ecom/features/dashboard/data/model/product_response.dart';
import 'package:ecom/shared_preference/constants.dart';
import 'package:ecom/shared_preference/shared_preference_helper.dart';

abstract class DashboardLocalDatasource {
  Future<List<ProductResponseModel>> getProductList();
  Future<List<ProductResponseModel>> setProductList(
      List<ProductResponseModel> productList);
}

class DashboardLocalDatasourceImpl extends DashboardLocalDatasource {
  @override
  Future<List<ProductResponseModel>> getProductList() async {
    List<ProductResponseModel> modelList = [];
    final data = SharedPrefHelper.getString(AppConstants.productListKey);
    if (data != null) {
      final response = jsonDecode(data);
      response.forEach((element) {
        modelList.add(ProductResponseModel.fromJson(element));
      });
    }
    return modelList;
  }

  @override
  Future<List<ProductResponseModel>> setProductList(
      List<ProductResponseModel> productList) async {
    final encodedData = jsonEncode(productList.map((e) => e.toJson()).toList());
    await SharedPrefHelper.saveString(AppConstants.productListKey, encodedData);
    return productList;
  }
}
