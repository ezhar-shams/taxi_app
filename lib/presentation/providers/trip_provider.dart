import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/trip_model.dart';
import '../../data/models/city_model.dart';
import '../../data/mock_data.dart';

// Search params
class SearchParams {
  final String fromId;
  final String toId;
  final DateTime? date;
  final int passengers;

  const SearchParams({
    this.fromId = '',
    this.toId = '',
    this.date,
    this.passengers = 1,
  });
}

final searchParamsProvider = StateProvider<SearchParams>((ref) => const SearchParams());

// All cities
final citiesProvider = Provider<List<CityModel>>((ref) => MockData.cities);

// Search results
final searchResultsProvider = Provider<List<TripModel>>((ref) {
  final params = ref.watch(searchParamsProvider);
  if (params.fromId.isEmpty || params.toId.isEmpty) return [];
  // Date is not used for filtering mock data (all trips use DateTime.now() as base).
  // It is kept in state for display in results header only.
  return MockData.searchTrips(
    fromId: params.fromId,
    toId: params.toId,
    date: null,
    passengers: params.passengers,
  );
});

// Sort/filter state
enum SortOption { priceLow, priceHigh, timeSoonest, timeLatest }
enum VehicleFilter { all, sedan, suv, van, minibus }

class FilterState {
  final SortOption sort;
  final VehicleFilter vehicleFilter;
  const FilterState({this.sort = SortOption.timeSoonest, this.vehicleFilter = VehicleFilter.all});
}

final filterProvider = StateProvider<FilterState>((ref) => const FilterState());

final filteredTripsProvider = Provider<List<TripModel>>((ref) {
  var trips = ref.watch(searchResultsProvider);
  final filter = ref.watch(filterProvider);

  // Vehicle filter
  if (filter.vehicleFilter != VehicleFilter.all) {
    final type = VehicleType.values.firstWhere(
      (t) => t.name == filter.vehicleFilter.name,
      orElse: () => VehicleType.sedan,
    );
    trips = trips.where((t) => t.vehicle.type == type).toList();
  }

  // Sort
  switch (filter.sort) {
    case SortOption.priceLow:
      trips.sort((a, b) => a.price.compareTo(b.price));
    case SortOption.priceHigh:
      trips.sort((a, b) => b.price.compareTo(a.price));
    case SortOption.timeSoonest:
      trips.sort((a, b) => a.departureTime.compareTo(b.departureTime));
    case SortOption.timeLatest:
      trips.sort((a, b) => b.departureTime.compareTo(a.departureTime));
  }

  return trips;
});

// Single trip by id
final tripByIdProvider = Provider.family<TripModel?, String>((ref, id) {
  return MockData.tripById(id);
});

// Selected seat
final selectedSeatProvider = StateProvider<int?>((ref) => null);
