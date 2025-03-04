import 'dart:async';

import 'package:ecom/features/dashboard/data/model/category.dart';
import 'package:ecom/features/dashboard/data/model/product_response.dart';
import 'package:ecom/features/dashboard/presentation/bloc/bloc/dashboard_product_bloc.dart';
import 'package:ecom/features/dashboard/presentation/widget/loaderwidget.dart';
import 'package:ecom/features/dashboard/presentation/widget/product_card.dart';
import 'package:ecom/features/dashboard/presentation/widget/retry_page.dart';
import 'package:ecom/screen_util/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  // static const String screenRoute = "dashboardScreen";
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardProductBloc dashboardProductBloc;
  TextEditingController searchController = TextEditingController(text: "");
  FocusNode searchFocusNode = FocusNode();
  GetIt getIt = GetIt.instance;

  Timer? debounce;

  @override
  void initState() {
    dashboardProductBloc = getIt<DashboardProductBloc>();
    dashboardProductBloc.add(FetchDashboardProductEvent());
    super.initState();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<DashboardProductBloc, DashboardProductState>(
          bloc: dashboardProductBloc,
          builder: (context, state) {
            List<ProductResponseModel> modelList = [];
            if (state is FetchDashboardProductSuccess) {
              modelList = state.modelList;
              if (modelList.isEmpty) {
                if (state.patternSearch) {
                  return RetryPage(
                    showRetry: false,
                    title: "Oops! No match found",
                    onRetry: () {},
                  );
                }
                return RetryPage(
                  title: "Oops! No product found",
                  onRetry: () {
                    dashboardProductBloc.add(FetchDashboardProductEvent());
                  },
                );
              }
            } else if (state is FetchDashboardProductError) {
              return RetryPage(
                title: "Oops! Something went wrong.",
                desc: "Please check your internet connection and try again.",
                onRetry: () {
                  dashboardProductBloc.add(FetchDashboardProductEvent());
                },
              );
            } else if (state is DashboardProductLoading &&
                state.patternSearch == true) {
              return const LoaderWidget();
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 16),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "A Summer Surprise",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 15.w,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Cashback 20%",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Popular Products",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.w,
                                color: Colors.black87),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.filter_list,
                              color: Theme.of(context)
                                  .iconTheme
                                  .color
                                  ?.withOpacity(0.6),
                              size: 25.w,
                            ),
                            onPressed: () {
                              showFilterBottomSheet(
                                  context, dashboardProductBloc.categoryList);
                            },
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text("See more",
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.w,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: state is DashboardProductLoading
                        ? _buildShimmerEffect()
                        : RefreshIndicator(
                            onRefresh: () async {},
                            child: GridView.builder(
                              itemCount: modelList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.54,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  model: modelList[index],
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  void showFilterBottomSheet(
      BuildContext context, List<Category> categoryList) {
    List<Category> newCategoryList = [];
    categoryList.forEach((element) {
      newCategoryList
          .add(Category(isSelected: element.isSelected, name: element.name));
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, updateSate) {
            // Example filter options

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Products",
                        style: TextStyle(
                            fontSize: 16.w, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),

                  // On Sale Filter
                  CheckboxListTile(
                    title: Text(
                      "All",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.w),
                    ),
                    value: isSelectedAll(newCategoryList),
                    onChanged: (value) {
                      updateSate(() {
                        if (value ?? false) {
                          for (int i = 0; i < categoryList.length; i++) {
                            newCategoryList[i].isSelected = true;
                          }
                        } else {
                          for (int i = 0; i < categoryList.length; i++) {
                            newCategoryList[i].isSelected = false;
                          }
                        }
                      });
                    },
                  ),

                  Expanded(
                    flex: 5,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: newCategoryList.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(
                              newCategoryList[index].name,
                              style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.w),
                            ),
                            value: newCategoryList[index].isSelected,
                            onChanged: (value) {
                              updateSate(() {
                                newCategoryList[index].isSelected =
                                    value ?? false;
                              });
                            },
                          );
                        }),
                  ),

                  const SizedBox(height: 10),

                  // Apply Filters Button
                  ElevatedButton(
                    onPressed: () {
                      if (!isNoCategorySeleted(newCategoryList)) {
                        // Handle filter logic here
                        searchController.clear();
                        dashboardProductBloc.add(
                            SearchByCategory(categoryList: newCategoryList));
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNoCategorySeleted(newCategoryList)
                          ? Colors.deepPurple.withOpacity(0.3)
                          : Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Apply Filters",
                        style: TextStyle(color: Colors.white, fontSize: 15.w),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  bool isSelectedAll(List<Category> categoryList) {
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i].isSelected == false) {
        return false;
      }
    }
    return true;
  }

  bool isNoCategorySeleted(List<Category> categoryList) {
    int count = 0;
    for (int i = 0; i < categoryList.length; i++) {
      if (categoryList[i].isSelected == false) {
        count++;
      }
    }
    return count == categoryList.length;
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      toolbarHeight: 80.w,
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.only(
          top: 10,
          right: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                child: TextFormField(
                  focusNode: searchFocusNode,
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.w,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search product",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 25.w,
                    ),
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.w,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200]),
                child: IconButton(
                  icon: Icon(
                    Icons.shopping_cart_outlined,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                    size: 25.w,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.grey[200]),
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                    size: 25.w,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (debounce?.isActive ?? false) {
      debounce!.cancel();
    }

    // Set a delay before running the search function
    debounce = Timer(const Duration(milliseconds: 500), () {
      dashboardProductBloc.add(SearchInProductList(pattern: query));
    });
  }

  Widget _buildShimmerEffect() {
    return GridView.builder(
      itemCount: 6, // Show shimmer effect for 6 items
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.60,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 180.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30.w,
                        width: double.infinity,
                        color: Colors.black54,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 20.w,
                        width: 80.w,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}



// Retry Page Widget
