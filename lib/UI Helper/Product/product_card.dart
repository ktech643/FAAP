import 'package:faap/UI Helper/colors.dart';
import 'package:faap/UI Helper/custom_imageloader.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomImageLoader(
                imageUrl: product.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: product.riskColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.riskText,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: Icon(Icons.favorite, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withOpacity(0.2),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class Product {
  final String imageUrl;
  final String title;
  final Color riskColor;
  final String riskText;

  Product({
    required this.imageUrl,
    required this.title,
    required this.riskColor,
    required this.riskText,
  });
}

final List<Product> products = [
  Product(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD87tN8xpYdPF0ZJQVxjYc3Ijm_ZILH2rTrvXlWZ0dtCbRtaAGUncsTN-nECIbZN6qmKjlKCE6eVHES18RCv0o7VFdkdeZKAQ5rmLAW5IxYpLY5nUBADIGaSn5UTFbcmjzEzS8_kceVRHwCxqDM1ecah4P51mi4XF4pD2wBYyHQh13JXmxQ_IG8hC0wzDcXBpOk9I2s1TMw_n2jPGkjnPQvV8E3Y_vdOoTJfVExyuBZ5d-V06yTy4NIhGJNC-DOunKhYXVUIOdxJQpi',
    title: 'Organic Almond Milk',
    riskColor: Colors.green,
    riskText: 'Low Risk',
  ),
  Product(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA2oY36X46x_zz1w9qEvktyZLFf1bbDVo__maoxz50zYb_8U5wOOMfYlbeeSs5iklhvpvQ2o1qtSJ3qWelmC9QslQNJk2SUKVqLii5NIrOlCzrOwXzF30SvkP6HzJKsfeP7-A0P1AnV_1P0LVJJU_8m7znWoL-e8AOjQDy9u_bm3fZfdN5Skffw8eM_nxF4Bq4mwkN9GDEIPkqVZbD4FjuSJC8MQV07CbzG5HSgMXzdBbLDjhXPB_6Tv6JrpT026j_KTObYZo02t97l',
    title: 'Gluten-Free Quinoa Pasta',
    riskColor: Colors.green,
    riskText: 'Low Risk',
  ),
  Product(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuBuTYpXrtFc4Ozx7fHGyJYuJiMug6MZ0eLe9t62uObelJOMAFET_3e9daiX40Uxfjz-xznaxRvAs7odr74IY81v7xzq_rXZh_Ua2L_aY6RVSxBQEsJerySpxJwOfaIGqpsgvrwho6UllKTyL-Jo5DR8ybP6DRzey6w9BuYjTI9Qq1-tvUwO8lorrZsukLBnasgvZIvhlBmHpbbZn1J6i4SD2kLGBzZpSWPV_pE9lV5iDP63g0MzmI2eNVyIk08yj_zYwzHz1D2l_ohu',
    title: 'Low-Sodium Chicken Broth',
    riskColor: Colors.yellow,
    riskText: 'Medium Risk',
  ),
  Product(
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAEQMyCufOeI98S2pHPObQh8jwesKaXcTsnePK4kKa7hFDMbx2HFF_1MYJtb-X6soCZ7tdBvEVPQpE-6dQm8R95bF51T2XggkdDGNjJdUqgAMXn35E24XwSPrnFLCwfe62U4NzonwX8DLyBpfdyhv1SqJ3_KFF6ABxcKFdDAJj5RJ1-A5mDiiopV2JiN5_BdKiWIA8aWI5rE9fKZiPwqTUDN2-GMATWu2x_TL3CmC6Tvo6IXq2NA9Qcj77uolCpGo48Kag2A2VZXquq',
    title: 'Sugar-Free Dark Chocolate',
    riskColor: Colors.green,
    riskText: 'Low Risk',
  ),
];
