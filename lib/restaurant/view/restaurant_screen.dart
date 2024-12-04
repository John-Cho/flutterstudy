import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrun/common/dio/dio.dart';
import 'package:infrun/common/model/cursor_pagination_model.dart';
import 'package:infrun/restaurant/component/restaurant_card.dart';
import 'package:infrun/restaurant/model/restaurant_model.dart';
import 'package:infrun/restaurant/repository/restaurant_repository.dart';
import 'package:infrun/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends ConsumerWidget {

  Future<List<RestaurantModel>> paginateRestaurant(WidgetRef ref) async {
    final CursorPagination<RestaurantModel> state = await ref.read(restaurantRepositoryProvider).getRestaurantPaginate();
    return state.data;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
              child: FutureBuilder(
                future: ref.watch(restaurantRepositoryProvider).getRestaurantPaginate(),
                builder: (context, AsyncSnapshot snapshot) {
                  // Future 시작 시, ConnectionState.waiting
                  // Future 종료 시, ConnectionState.done + snapshot.hasData;
                  // Future 에러 시, snapshot.hasError
                  // 기본적으로 future는 한 번만 실행되며, 상태 변화에 따라 builder가 다시 호출된다.
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  else {
                    return ListView.separated(
                      itemCount: snapshot.data.data!.length,
                      itemBuilder: (context, index) {
                        final pItem = snapshot.data.data![index];//RestaurantModel.fromJson(snapshot.data![index]);

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return RestaurantDetailScreen(id: pItem.id, title: pItem.name,);
                            },));
                          },
                          child: RestaurantCard.fromModel(model: pItem,),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 16.0,);
                      },
                    );
                  }
                },
              )
          ),
        )
    );
  }
}
