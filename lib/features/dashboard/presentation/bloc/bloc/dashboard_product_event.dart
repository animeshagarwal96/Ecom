part of 'dashboard_product_bloc.dart';

class DashboardProductEvent extends Equatable {
  const DashboardProductEvent();

  @override
  List<Object> get props => [];
}

class FetchDashboardProductEvent extends DashboardProductEvent {}

class SearchInProductList extends DashboardProductEvent {
  final String pattern;

  const SearchInProductList({required this.pattern});
}

class SearchByCategory extends DashboardProductEvent {
  final List<Category> categoryList;

  const SearchByCategory({required this.categoryList});
}
