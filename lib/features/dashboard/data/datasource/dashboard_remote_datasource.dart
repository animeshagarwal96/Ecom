import 'package:ecom/api_url.dart';
import 'package:ecom/features/dashboard/data/model/product_response.dart';
import 'package:ecom/httpclient/api_client.dart';

abstract class DashboardRemoteDatasource {
  Future<List<ProductResponseModel>> getProductList();
}

class DashboardRemoteDatasourceImpl extends DashboardRemoteDatasource {
  @override
  Future<List<ProductResponseModel>> getProductList() async {
    final response = await ApiClient().getRequest(ApiUrl.getProductListUrl);

    List<ProductResponseModel> modelList = [];

    response.forEach((element) {
      modelList.add(ProductResponseModel.fromJson(element));
    });
    return modelList;
  }
}
