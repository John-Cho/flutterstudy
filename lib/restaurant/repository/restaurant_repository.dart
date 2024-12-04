import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infrun/common/dio/dio.dart';
import 'package:infrun/common/model/cursor_pagination_model.dart';
import 'package:infrun/restaurant/model/restaurant_detail_model.dart';
import 'package:infrun/restaurant/model/restaurant_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import '../../common/const/data.dart';

part 'restaurant_repository.g.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio, baseUrl: 'http://$ip/restaurant');

  return repository;
},);

@RestApi()
abstract class RestaurantRepository {
  // http://$ip/restaurant
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  // http://$ip/restaurant
  @GET('/')
  @Headers({'accessToken': 'true',})
  Future<CursorPagination<RestaurantModel>> getRestaurantPaginate();

  // http://$ip/restaurant/:id/
  @GET('/{id}')
  @Headers({'accessToken': 'true',})
  Future<RestaurantDetailModel> getRestaurantDetail({
    // 변수이름과 파라미터 이름이 같으면, ('id') 를 생략해도 된다.
    // 예를 들어 변수 이름과 다른 경우는 다음과 같이 작성한다/
    // @Path('id') required String identification;
    @Path() required String id,
  });
}
