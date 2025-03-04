import 'package:ecom/features/dashboard/data/model/product_response.dart';
import 'package:ecom/screen_util/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final ProductResponseModel model;
  const ProductCard({super.key, required this.model});
  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180.w,
            decoration: BoxDecoration(
              // color: Colors.grey[300],
              image: DecorationImage(
                  image: NetworkImage(widget.model.image ?? "", scale: 0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.model.title ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.w,
                      color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${widget.model.price}",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.w,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 35.w,
                      height: 35.w,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red[50]),
                      child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16.w,
                        ),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
