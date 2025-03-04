import 'package:bloc/bloc.dart';
import 'package:ecom/features/dashboard/data/model/category.dart';
import 'package:ecom/features/dashboard/data/model/product_response.dart';
import 'package:ecom/features/dashboard/domain/usecase/fetch_product_list_usecase.dart';
import 'package:ecom/httpclient/usecase.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_product_event.dart';
part 'dashboard_product_state.dart';

class DashboardProductBloc
    extends Bloc<DashboardProductEvent, DashboardProductState> {
  final FetchProductListUsecase fetchProductListUsecase;
  List<ProductResponseModel> modelList = [];
  List<Category> categoryList = [];
  List<String> categoryListString = [];

  DashboardProductBloc({required this.fetchProductListUsecase})
      : super(DashboardProductInitial()) {
    on<FetchDashboardProductEvent>((event, emit) async {
      emit(const DashboardProductLoading(patternSearch: false));

      final data = await fetchProductListUsecase(NoParams());

      data.fold(
          (l) => emit(const FetchDashboardProductError(
              errorMsg: "Something went wrong")), (r) {
        categoryListString = [];
        categoryList = [];
        modelList = r;
        modelList.forEach((element) {
          if (!categoryListString.contains(element.category ?? "")) {
            categoryListString.add(element.category ?? "");
          }
        });

        categoryListString.forEach((element) {
          categoryList.add(Category(isSelected: true, name: element));
        });
        emit(FetchDashboardProductSuccess(
            modelList: modelList, patternSearch: false));
      });
    });

    on<SearchInProductList>((event, emit) async {
      emit(const DashboardProductLoading(patternSearch: true));
      List<ProductResponseModel> tempList = modelList
          .where((element) =>
              (element.title ?? "")
                  .toLowerCase()
                  .contains(event.pattern.toLowerCase()) ||
              (element.description ?? "")
                  .toLowerCase()
                  .contains(event.pattern.toLowerCase()))
          .toList();

      emit(FetchDashboardProductSuccess(
          modelList: tempList, patternSearch: true));
    });
    on<SearchByCategory>((event, emit) async {
      emit(const DashboardProductLoading(patternSearch: true));
      List<ProductResponseModel> tempList = [];
      List<String> chooseCategory = [];

      event.categoryList.forEach((element) {
        if (element.isSelected == true) {
          chooseCategory.add(element.name);
        }
      });

      modelList.forEach((element) {
        if (chooseCategory.contains(element.category ?? "")) {
          tempList.add(element);
        }
      });
      categoryList = event.categoryList;
      emit(FetchDashboardProductSuccess(
          modelList: tempList, patternSearch: true));
    });
  }
}
