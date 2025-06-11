import 'package:soyabox/data/reservation_repo.dart';
import 'package:soyabox/models/reservation_model.dart';
import 'package:get/get.dart';

class ReservationController extends GetxController {
  final ReservationRepo reservationRepo;

  ReservationController({
    required this.reservationRepo,
  });

  bool _isLoading = false; // State variable for loading status
  bool get isLoading => _isLoading;

  RxList<ReservationModel> reservations =
      <ReservationModel>[].obs; // Observable list of reservations
  String? errorMessage; // Variable to hold error messages

  @override
  void onInit() {
    super.onInit();
    // You can automatically fetch reservations when the controller is initialized
    fetchUserReservations();
  }

  // Method to place a new reservation
  Future<String> placeReservation(ReservationModel reservation) async {
    _isLoading = true; // Indicate that the reservation placement is in progress
    update(); // Notify UI about loading state

    Response response = await reservationRepo.placeReservation(reservation);

    _isLoading = false; // Reset loading state after the request
    update(); // Notify UI about loading state change

    if (response.statusCode == 201) {
      
      return 'Reservation placed successfully';
    } else {
      // Handle errors and return error message
      errorMessage = response.statusText; // Capture the error message
      return 'Failed to place reservation: $errorMessage';
    }
  }

  // Method to fetch user reservations
  Future<void> fetchUserReservations() async {
    _isLoading = true; // Indicate that fetching is in progress
    update(); // Notify UI about loading state

    try {
      Response response = await reservationRepo.fetchUserReservations();
      if (response.statusCode == 200) {
        List<dynamic> reservationList = response.body['data'];
        reservations.value = reservationList
            .map((reservation) => ReservationModel.fromJson(reservation))
            .toList();
      } else {
        errorMessage = response.statusText; // Capture error message on failure
      }
    } catch (e) {
      errorMessage = e.toString(); // Capture any error during the fetch
    } finally {
      _isLoading = false; // Reset loading state
      update(); // Notify UI about data change
    }
  }
}
