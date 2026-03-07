import 'models/city_model.dart';
import 'models/trip_model.dart';
import 'models/booking_model.dart';

class MockData {
  MockData._();

  // ─── Cities — All 34 Afghan Provinces ────────────────────────────────────
  static final List<CityModel> cities = [
    // Major cities / قصبات بزرگ
    const CityModel(id: 'KBL', nameFa: 'کابل',          namePs: 'کابل',          province: 'کابل',        lat: 34.5260, lng: 69.1776),
    const CityModel(id: 'HEA', nameFa: 'هرات',          namePs: 'هرات',          province: 'هرات',        lat: 34.3482, lng: 62.1997),
    const CityModel(id: 'KDH', nameFa: 'قندهار',        namePs: 'کندهار',        province: 'قندهار',      lat: 31.6180, lng: 65.7150),
    const CityModel(id: 'MZR', nameFa: 'مزار شریف',     namePs: 'مزار شریف',     province: 'بلخ',         lat: 36.7097, lng: 67.1100),
    const CityModel(id: 'JAL', nameFa: 'جلال آباد',     namePs: 'جلال آباد',     province: 'ننګرهار',     lat: 34.4272, lng: 70.4485),
    const CityModel(id: 'KNZ', nameFa: 'کندز',          namePs: 'کندز',          province: 'کندز',        lat: 36.7286, lng: 68.8681),
    const CityModel(id: 'GHZ', nameFa: 'غزنی',          namePs: 'غزني',          province: 'غزنی',        lat: 33.5536, lng: 68.4192),
    const CityModel(id: 'BAM', nameFa: 'بامیان',        namePs: 'بامیان',        province: 'بامیان',      lat: 34.8196, lng: 67.8280),
    const CityModel(id: 'KHO', nameFa: 'خوست',          namePs: 'خوست',          province: 'خوست',        lat: 33.3338, lng: 69.9169),
    const CityModel(id: 'PKT', nameFa: 'گردیز',         namePs: 'ګردیز',         province: 'پکتیا',       lat: 33.6012, lng: 69.2277),
    // Northern provinces / ولایات شمالی
    const CityModel(id: 'BGL', nameFa: 'پل خمری',       namePs: 'پل خمري',       province: 'بغلان',       lat: 35.9427, lng: 68.7167),
    const CityModel(id: 'TAK', nameFa: 'تالقان',        namePs: 'تالقان',        province: 'تخار',        lat: 36.7347, lng: 69.5153),
    const CityModel(id: 'JOZ', nameFa: 'شبرغان',        namePs: 'شبرغان',        province: 'جوزجان',      lat: 36.6550, lng: 65.7550),
    const CityModel(id: 'SAR', nameFa: 'سرپل',          namePs: 'سرپل',          province: 'سرپل',        lat: 36.1712, lng: 65.9248),
    const CityModel(id: 'SAM', nameFa: 'ایبک',          namePs: 'ایبک',          province: 'سمنگان',      lat: 36.2639, lng: 68.0186),
    const CityModel(id: 'FRB', nameFa: 'میمنه',         namePs: 'میمنه',         province: 'فاریاب',      lat: 35.9208, lng: 64.7710),
    // Northwestern / شمال غرب
    const CityModel(id: 'BAD', nameFa: 'قلعه نو',       namePs: 'قلعه نو',       province: 'بادغیس',      lat: 34.9834, lng: 63.1183),
    const CityModel(id: 'GHO', nameFa: 'فیروز کوه',     namePs: 'فیروز کوه',     province: 'غور',         lat: 34.5195, lng: 65.2471),
    // Northeastern / شمال شرق
    const CityModel(id: 'BDX', nameFa: 'فیض آباد',      namePs: 'فیض آباد',      province: 'بدخشان',      lat: 37.1299, lng: 70.5799),
    const CityModel(id: 'PNJ', nameFa: 'بازارک',        namePs: 'بازارک',        province: 'پنجشیر',      lat: 35.2710, lng: 69.5196),
    const CityModel(id: 'NUR', nameFa: 'نورستان',       namePs: 'نورستان',       province: 'نورستان',     lat: 35.3227, lng: 70.8464),
    const CityModel(id: 'KUN', nameFa: 'اسدآباد',       namePs: 'اسدآباد',       province: 'کنر',         lat: 34.8609, lng: 71.1533),
    const CityModel(id: 'LAG', nameFa: 'مهتر لام',      namePs: 'مهترلام',       province: 'لغمان',       lat: 34.6663, lng: 70.1736),
    const CityModel(id: 'KAP', nameFa: 'محمود راقی',    namePs: 'محمود راقي',    province: 'کاپیسا',      lat: 35.0218, lng: 69.3224),
    const CityModel(id: 'PAR', nameFa: 'چاریکار',       namePs: 'چاریکار',       province: 'پروان',       lat: 35.0135, lng: 69.1736),
    // Eastern / شرق
    const CityModel(id: 'LOG', nameFa: 'پل علم',        namePs: 'پل علم',        province: 'لوگر',        lat: 33.9820, lng: 69.0155),
    const CityModel(id: 'WAR', nameFa: 'میدان شهر',     namePs: 'میدان ښار',     province: 'وردک',        lat: 34.3971, lng: 68.8717),
    const CityModel(id: 'PKK', nameFa: 'شرنه',          namePs: 'شرنه',          province: 'پکتیکا',      lat: 32.6276, lng: 68.4391),
    // Southern / جنوب
    const CityModel(id: 'ZAB', nameFa: 'قلات',          namePs: 'قلات',          province: 'زابل',        lat: 32.1094, lng: 66.8989),
    const CityModel(id: 'URZ', nameFa: 'ترین کوت',      namePs: 'ترين کوټ',      province: 'ارزگان',      lat: 32.6411, lng: 65.8676),
    // Western / غرب
    const CityModel(id: 'FAR', nameFa: 'فراه',          namePs: 'فراه',          province: 'فراه',        lat: 32.3740, lng: 62.1131),
    const CityModel(id: 'HLM', nameFa: 'لشکرگاه',       namePs: 'لشکرګاه',       province: 'هلمند',       lat: 31.5933, lng: 64.3703),
    const CityModel(id: 'NIM', nameFa: 'زرنج',          namePs: 'زرنج',          province: 'نیمروز',      lat: 31.0089, lng: 61.8714),
    // Central / مرکز
    const CityModel(id: 'DAY', nameFa: 'نیلی',          namePs: 'نیلي',          province: 'دایکندی',     lat: 33.7232, lng: 66.0600),
  ];

  static CityModel? cityById(String id) {
    try { return cities.firstWhere((c) => c.id == id); }
    catch (_) { return null; }
  }

  // ─── Vehicles ─────────────────────────────────────────────────────────────
  static final VehicleModel _sedanV1 = VehicleModel(
    id: 'V001', make: 'Toyota', model: 'Corolla', plate: 'ک-۱۲۳۴۵',
    totalSeats: 5, type: VehicleType.sedan, hasAc: true, hasWifi: false, luggageAllowanceKg: 20,
  );
  static final VehicleModel _suvV2 = VehicleModel(
    id: 'V002', make: 'Toyota', model: 'Land Cruiser', plate: 'ک-۵۶۷۸۹',
    totalSeats: 7, type: VehicleType.suv, hasAc: true, hasWifi: true, luggageAllowanceKg: 30,
  );
  static final VehicleModel _vanV3 = VehicleModel(
    id: 'V003', make: 'Toyota', model: 'HiAce', plate: 'هـ-۱۱۱۲۲',
    totalSeats: 12, type: VehicleType.van, hasAc: true, hasWifi: false, luggageAllowanceKg: 25,
  );
  static final VehicleModel _minibusV4 = VehicleModel(
    id: 'V004', make: 'Mitsubishi', model: 'Rosa', plate: 'ق-۳۳۳۴۴',
    totalSeats: 25, type: VehicleType.minibus, hasAc: false, hasWifi: false, luggageAllowanceKg: 30,
  );

  // ─── Trips ────────────────────────────────────────────────────────────────
  static List<TripModel> trips = [
    TripModel(
      id: 'T001',
      fromCity: cities[0], // کابل
      toCity: cities[1],   // هرات
      departureTime: DateTime.now().add(const Duration(hours: 6)),
      arrivalTime: DateTime.now().add(const Duration(hours: 22)),
      price: 2500,
      driderId: 'D001',
      driverName: 'احمد خان',
      companyName: 'ملی ترانسپورت',
      driverRating: 4.8,
      vehicle: _suvV2,
      bookedSeats: [2, 3, 5],
      stops: ['شیندند', 'فراه'],
      status: 'active',
    ),
    TripModel(
      id: 'T002',
      fromCity: cities[0], // کابل
      toCity: cities[3],   // مزار شریف
      departureTime: DateTime.now().add(const Duration(hours: 3)),
      arrivalTime: DateTime.now().add(const Duration(hours: 12)),
      price: 1800,
      driderId: 'D002',
      driverName: 'محمد نادر',
      companyName: 'آریانا لاین',
      driverRating: 4.6,
      vehicle: _sedanV1,
      bookedSeats: [2, 4],
      stops: ['سالنگ', 'پل خمری'],
      status: 'active',
    ),
    TripModel(
      id: 'T003',
      fromCity: cities[0], // کابل
      toCity: cities[2],   // قندهار
      departureTime: DateTime.now().add(const Duration(hours: 8)),
      arrivalTime: DateTime.now().add(const Duration(hours: 16)),
      price: 1500,
      driderId: 'D003',
      driverName: 'فریدون',
      companyName: 'پشتون ترانسپورت',
      driverRating: 4.4,
      vehicle: _vanV3,
      bookedSeats: [2, 4, 6, 8, 10],
      stops: ['غزنی'],
      status: 'active',
    ),
    TripModel(
      id: 'T004',
      fromCity: cities[1], // هرات
      toCity: cities[0],   // کابل
      departureTime: DateTime.now().add(const Duration(hours: 5)),
      arrivalTime: DateTime.now().add(const Duration(hours: 21)),
      price: 2500,
      driderId: 'D004',
      driverName: 'علی احمد',
      companyName: 'خیبر لاین',
      driverRating: 4.9,
      vehicle: _suvV2,
      bookedSeats: [3, 7],
      stops: ['غور'],
      status: 'active',
    ),
    TripModel(
      id: 'T005',
      fromCity: cities[0], // کابل
      toCity: cities[4],   // جلال آباد
      departureTime: DateTime.now().add(const Duration(hours: 2)),
      arrivalTime: DateTime.now().add(const Duration(hours: 6)),
      price: 800,
      driderId: 'D005',
      driverName: 'صدیق الله',
      companyName: 'ننگرهار ترانسپورت',
      driverRating: 4.5,
      vehicle: _minibusV4,
      bookedSeats: [2, 4, 6, 8, 10, 12, 14],
      stops: ['سرخ آب'],
      status: 'active',
    ),
    TripModel(
      id: 'T006',
      fromCity: cities[3], // مزار شریف
      toCity: cities[5],   // کندز
      departureTime: DateTime.now().add(const Duration(hours: 4)),
      arrivalTime: DateTime.now().add(const Duration(hours: 9)),
      price: 1200,
      driderId: 'D006',
      driverName: 'حبیب الله',
      companyName: 'بلخ ترانسپورت',
      driverRating: 4.3,
      vehicle: _sedanV1,
      bookedSeats: [2],
      stops: [],
      status: 'active',
    ),
    TripModel(
      id: 'T007',
      fromCity: cities[0], // کابل
      toCity: cities[6],   // غزنی
      departureTime: DateTime.now().add(const Duration(hours: 1)),
      arrivalTime: DateTime.now().add(const Duration(hours: 5)),
      price: 900,
      driderId: 'D007',
      driverName: 'نصرالله',
      companyName: 'غزنی ترانسپورت',
      driverRating: 4.7,
      vehicle: _sedanV1,
      bookedSeats: [3],
      stops: [],
      status: 'active',
    ),
    TripModel(
      id: 'T008',
      fromCity: cities[1], // هرات
      toCity: cities[2],   // قندهار
      departureTime: DateTime.now().add(const Duration(hours: 7)),
      arrivalTime: DateTime.now().add(const Duration(hours: 19)),
      price: 2000,
      driderId: 'D008',
      driverName: 'عبدالقادر',
      companyName: 'هرات ترانسپورت',
      driverRating: 4.5,
      vehicle: _suvV2,
      bookedSeats: [2, 4, 6],
      stops: ['فراه'],
      status: 'active',
    ),
    TripModel(
      id: 'T009',
      fromCity: cities[3], // مزار شریف
      toCity: cities[0],   // کابل
      departureTime: DateTime.now().add(const Duration(hours: 5)),
      arrivalTime: DateTime.now().add(const Duration(hours: 14)),
      price: 1800,
      driderId: 'D009',
      driverName: 'بشیر احمد',
      companyName: 'آریانا لاین',
      driverRating: 4.7,
      vehicle: _suvV2,
      bookedSeats: [2, 5],
      stops: ['پل خمری'],
      status: 'active',
    ),
    TripModel(
      id: 'T010',
      fromCity: cities[0], // کابل
      toCity: cities[7],   // بامیان
      departureTime: DateTime.now().add(const Duration(hours: 9)),
      arrivalTime: DateTime.now().add(const Duration(hours: 15)),
      price: 1100,
      driderId: 'D010',
      driverName: 'داود خان',
      companyName: 'بامیان ترانسپورت',
      driverRating: 4.6,
      vehicle: _sedanV1,
      bookedSeats: [3, 4],
      stops: [],
      status: 'active',
    ),
    TripModel(
      id: 'T011',
      fromCity: cities[0], // کابل
      toCity: cities[3],   // مزار شریف
      departureTime: DateTime.now().add(const Duration(hours: 14)),
      arrivalTime: DateTime.now().add(const Duration(hours: 23)),
      price: 1900,
      driderId: 'D011',
      driverName: 'ذبیح الله',
      companyName: 'ملی ترانسپورت',
      driverRating: 4.4,
      vehicle: _vanV3,
      bookedSeats: [2, 4, 6, 8],
      stops: ['سالنگ'],
      status: 'active',
    ),
  ];

  static TripModel? tripById(String id) {
    try { return trips.firstWhere((t) => t.id == id); }
    catch (_) { return null; }
  }

  static List<TripModel> searchTrips({
    required String fromId,
    required String toId,
    DateTime? date,
    int passengers = 1,
  }) {
    return trips.where((t) {
      final fromMatch = t.fromCity.id == fromId;
      final toMatch   = t.toCity.id == toId;
      final dateMatch = date == null ||
        (t.departureTime.year  == date.year &&
         t.departureTime.month == date.month &&
         t.departureTime.day   == date.day);
      final seatsMatch = t.availableSeats >= passengers;
      return fromMatch && toMatch && dateMatch && seatsMatch;
    }).toList();
  }

  // ─── Sample Bookings ──────────────────────────────────────────────────────
  static List<BookingModel> sampleBookings = [
    BookingModel(
      id: 'BK001',
      tripId: 'T001',
      userId: 'U001',
      passengerName: 'کاربر نمونه',
      passengerPhone: '0791234567',
      passengerNationalId: '12345678',
      seatNumber: 4,
      totalPrice: 2500,
      status: BookingStatus.confirmed,
      paymentMethod: PaymentMethod.atPickup,
      bookedAt: DateTime.now().subtract(const Duration(hours: 2)),
      fromCityFa: 'کابل',
      fromCityPs: 'کابل',
      toCityFa: 'هرات',
      toCityPs: 'هرات',
      departureTime: DateTime.now().add(const Duration(hours: 6)),
      driverName: 'احمد خان',
      vehiclePlate: 'ک-۵۶۷۸۹',
    ),
  ];

  static BookingModel? bookingById(String id) {
    try { return sampleBookings.firstWhere((b) => b.id == id); }
    catch (_) { return null; }
  }

  // ─── Popular Routes ───────────────────────────────────────────────────────
  static const List<Map<String, String>> popularRoutes = [
    {'fromId': 'KBL', 'toId': 'HEA', 'fromFa': 'کابل',       'toFa': 'هرات',       'fromPs': 'کابل',      'toPs': 'هرات',      'price': '۲۵۰۰', 'duration': '۱۶ ساعت'},
    {'fromId': 'KBL', 'toId': 'MZR', 'fromFa': 'کابل',       'toFa': 'مزار شریف',  'fromPs': 'کابل',      'toPs': 'مزار شریف', 'price': '۱۸۰۰', 'duration': '۹ ساعت'},
    {'fromId': 'KBL', 'toId': 'KDH', 'fromFa': 'کابل',       'toFa': 'قندهار',     'fromPs': 'کابل',      'toPs': 'کندهار',    'price': '۱۵۰۰', 'duration': '۸ ساعت'},
    {'fromId': 'KBL', 'toId': 'JAL', 'fromFa': 'کابل',       'toFa': 'جلال آباد',  'fromPs': 'کابل',      'toPs': 'جلال آباد', 'price': '۸۰۰',  'duration': '۴ ساعت'},
    {'fromId': 'KBL', 'toId': 'GHZ', 'fromFa': 'کابل',       'toFa': 'غزنی',       'fromPs': 'کابل',      'toPs': 'غزني',      'price': '۹۰۰',  'duration': '۴ ساعت'},
    {'fromId': 'KBL', 'toId': 'BAM', 'fromFa': 'کابل',       'toFa': 'بامیان',     'fromPs': 'کابل',      'toPs': 'بامیان',    'price': '۱۱۰۰', 'duration': '۶ ساعت'},
    {'fromId': 'HEA', 'toId': 'KBL', 'fromFa': 'هرات',       'toFa': 'کابل',       'fromPs': 'هرات',      'toPs': 'کابل',      'price': '۲۵۰۰', 'duration': '۱۶ ساعت'},
    {'fromId': 'MZR', 'toId': 'KBL', 'fromFa': 'مزار شریف',  'toFa': 'کابل',       'fromPs': 'مزار شریف', 'toPs': 'کابل',      'price': '۱۸۰۰', 'duration': '۹ ساعت'},
    {'fromId': 'MZR', 'toId': 'KNZ', 'fromFa': 'مزار شریف',  'toFa': 'کندز',       'fromPs': 'مزار شریف', 'toPs': 'کندز',      'price': '۱۲۰۰', 'duration': '۵ ساعت'},
    {'fromId': 'HEA', 'toId': 'KDH', 'fromFa': 'هرات',       'toFa': 'قندهار',     'fromPs': 'هرات',      'toPs': 'کندهار',    'price': '۲۰۰۰', 'duration': '۱۲ ساعت'},
  ];}