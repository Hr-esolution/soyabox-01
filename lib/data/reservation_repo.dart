import 'package:soyabox/api/api_client.dart';
import 'package:soyabox/models/reservation_model.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';

class ReservationRepo {
  ApiClient apiClient;

  ReservationRepo({required this.apiClient});

  Future<Response> placeReservation(ReservationModel reservation) async {
    return await apiClient.postData(
        AppConstant.addReservation, reservation.toJson());
  }

  Future<Response> fetchUserReservations() async {
    return await apiClient.getData(AppConstant.reservationHistory);
  }
}
