import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrun/common/dio/dio.dart';
import 'package:infrun/common/layout/default_layout.dart';
import 'package:infrun/restaurant/component/restaurant_card.dart';
import 'package:infrun/restaurant/repository/restaurant_repository.dart';

import '../../common/const/data.dart';
import '../../product/component/product_card.dart';
import '../model/restaurant_detail_model.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  final String title;

  const RestaurantDetailScreen({required this.id, required this.title, });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: title,
      child: FutureBuilder(
        future: ref.watch(restaurantRepositoryProvider).getRestaurantDetail(id: id),
        builder: (context, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if(snapshot.hasError){
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          //Data 가 없는 경우
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              renderTop(model: snapshot.data!),
              renderLabel(),
              renderProduct(snapshot.data!.products),
            ],
          );
        },
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  renderProduct(List<RestaurantProductModel> model) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ProductCard.fromModel(model: model[index]),
        );
      }, childCount: model.length)),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
        child: RestaurantCard.fromModel(
      model: model,
      isDetail: true,
    ));
  }
}