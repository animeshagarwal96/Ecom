part of 'dashboard_product_bloc.dart';

class DashboardProductState extends Equatable {
  const DashboardProductState();

  @override
  List<Object> get props => [];
}

class DashboardProductInitial extends DashboardProductState {}

class DashboardProductLoading extends DashboardProductState {
  final bool patternSearch;

  const DashboardProductLoading({this.patternSearch = false});
}

class FetchDashboardProductSuccess extends DashboardProductState {
  final List<ProductResponseModel> modelList;
  final bool patternSearch;

  const FetchDashboardProductSuccess(
      {required this.modelList, required this.patternSearch});
}

class FetchDashboardProductError extends DashboardProductState {
  final String errorMsg;

  const FetchDashboardProductError({required this.errorMsg});
}
