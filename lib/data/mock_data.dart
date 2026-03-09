import 'models/city_model.dart';
import 'models/trip_model.dart';
import 'models/booking_model.dart';
import 'models/city_ride_model.dart';

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
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  //  CITY RIDE — Pickup Locations (neighborhoods & landmarks)
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<PickupLocation> cityLocations = [
    // ── کابل ──────────────────────────────────────────────────────────────
    PickupLocation(id: 'KBL_AIR', nameFa: 'فرودگاه کابل', namePs: 'د کابل هوایی ډګر',
        addressFa: 'فرودگاه بین‌المللی حامد کرزی، کابل', addressPs: 'د حامد کرزي نړیوال هوایی ډګر، کابل',
        cityId: 'KBL', lat: 34.5659, lng: 69.2122),
    PickupLocation(id: 'KBL_SNW', nameFa: 'شهر نو', namePs: 'مشر ښار',
        addressFa: 'شهر نو، ناحیه ۱۰، کابل', addressPs: 'مشر ښار، ناحیه ۱۰، کابل',
        cityId: 'KBL', lat: 34.5269, lng: 69.1803),
    PickupLocation(id: 'KBL_WZK', nameFa: 'وزیر اکبر خان', namePs: 'وزیر اکبر خان',
        addressFa: 'وزیر اکبر خان، کابل', addressPs: 'وزیر اکبر خان، کابل',
        cityId: 'KBL', lat: 34.5330, lng: 69.1945),
    PickupLocation(id: 'KBL_MKR', nameFa: 'میکرورایان', namePs: 'مایکروریان',
        addressFa: 'میکرورایان ۴، کابل', addressPs: 'مایکروریان ۴، کابل',
        cityId: 'KBL', lat: 34.5282, lng: 69.2098),
    PickupLocation(id: 'KBL_KHR', nameFa: 'خیرخانه', namePs: 'خیرخانه',
        addressFa: 'خیرخانه، ناحیه ۱۵، کابل', addressPs: 'خیرخانه، ناحیه ۱۵، کابل',
        cityId: 'KBL', lat: 34.5717, lng: 69.1625),
    PickupLocation(id: 'KBL_K3', nameFa: 'کارته سه', namePs: 'سویم کارته',
        addressFa: 'کارته سه، کابل', addressPs: 'سویم کارته، کابل',
        cityId: 'KBL', lat: 34.5180, lng: 69.1730),
    PickupLocation(id: 'KBL_K4', nameFa: 'کارته چار', namePs: 'څلورم کارته',
        addressFa: 'کارته چار، کابل', addressPs: 'څلورم کارته، کابل',
        cityId: 'KBL', lat: 34.5130, lng: 69.1840),
    PickupLocation(id: 'KBL_DBA', nameFa: 'دشت برچی', namePs: 'دشت برچي',
        addressFa: 'دشت برچی، ناحیه ۱۳، کابل', addressPs: 'دشت برچي، ناحیه ۱۳، کابل',
        cityId: 'KBL', lat: 34.4949, lng: 69.1030),
    PickupLocation(id: 'KBL_KPN', nameFa: 'کارته پروان', namePs: 'د پروان کارته',
        addressFa: 'کارته پروان، کابل', addressPs: 'د پروان کارته، کابل',
        cityId: 'KBL', lat: 34.5455, lng: 69.1643),
    PickupLocation(id: 'KBL_DAR', nameFa: 'دارالامان', namePs: 'دارالامان',
        addressFa: 'دارالامان، کابل', addressPs: 'دارالامان، کابل',
        cityId: 'KBL', lat: 34.4891, lng: 69.1432),
    PickupLocation(id: 'KBL_TAI', nameFa: 'تایمنی', namePs: 'تایمني',
        addressFa: 'تایمنی، کابل', addressPs: 'تایمني، کابل',
        cityId: 'KBL', lat: 34.5211, lng: 69.1658),
    PickupLocation(id: 'KBL_PLC', nameFa: 'پل چرخی', namePs: 'د چرخي پل',
        addressFa: 'پل چرخی، کابل', addressPs: 'د چرخي پل، کابل',
        cityId: 'KBL', lat: 34.5044, lng: 69.2556),
    PickupLocation(id: 'KBL_KBZ', nameFa: 'کوته باغچه', namePs: 'کوته باغچه',
        addressFa: 'کوته باغچه، کابل', addressPs: 'کوته باغچه، کابل',
        cityId: 'KBL', lat: 34.5410, lng: 69.2580),
    PickupLocation(id: 'KBL_CHM', nameFa: 'چهاراهی حبیبیه', namePs: 'د حبیبیې چارلاری',
        addressFa: 'چهاراهی حبیبیه، کابل', addressPs: 'د حبیبیې چارلاری، کابل',
        cityId: 'KBL', lat: 34.5187, lng: 69.2248),
    PickupLocation(id: 'KBL_UNI', nameFa: 'پوهنتون کابل', namePs: 'د کابل پوهنتون',
        addressFa: 'پوهنتون کابل، کارته چار', addressPs: 'د کابل پوهنتون، څلورم کارته',
        cityId: 'KBL', lat: 34.5214, lng: 69.1826),

    // ── هرات ──────────────────────────────────────────────────────────────
    PickupLocation(id: 'HEA_AIR', nameFa: 'فرودگاه هرات', namePs: 'د هرات هوایی ډګر',
        addressFa: 'فرودگاه بین‌المللی هرات', addressPs: 'د هرات نړیوال هوایی ډګر',
        cityId: 'HEA', lat: 34.2099, lng: 62.2283),
    PickupLocation(id: 'HEA_CTR', nameFa: 'مرکز شهر هرات', namePs: 'د هرات د ښار مرکز',
        addressFa: 'میدان شاه هرات، هرات', addressPs: 'د شاه هرات ډګر، هرات',
        cityId: 'HEA', lat: 34.3504, lng: 62.2064),
    PickupLocation(id: 'HEA_MSJ', nameFa: 'مسجد جامع هرات', namePs: 'د هرات جامع جوماتونه',
        addressFa: 'مسجد جامع هرات', addressPs: 'د هرات جامع جوماتونه',
        cityId: 'HEA', lat: 34.3480, lng: 62.1997),
    PickupLocation(id: 'HEA_GZR', nameFa: 'گذرگاه', namePs: 'ګذرګاه',
        addressFa: 'گذرگاه، هرات', addressPs: 'ګذرګاه، هرات',
        cityId: 'HEA', lat: 34.3610, lng: 62.1950),
    PickupLocation(id: 'HEA_KND', nameFa: 'کهنه فروشی', namePs: 'زوړ بازار',
        addressFa: 'شهر کهنه، هرات', addressPs: 'زوړ ښار، هرات',
        cityId: 'HEA', lat: 34.3450, lng: 62.1870),
    PickupLocation(id: 'HEA_INJ', nameFa: 'انجیل', namePs: 'انجیل',
        addressFa: 'انجیل، هرات', addressPs: 'انجیل، هرات',
        cityId: 'HEA', lat: 34.3777, lng: 62.1627),

    // ── مزار شریف ─────────────────────────────────────────────────────────
    PickupLocation(id: 'MZR_AIR', nameFa: 'فرودگاه مزار', namePs: 'د مزار هوایی ډګر',
        addressFa: 'فرودگاه مزار شریف، بلخ', addressPs: 'د مزار شریف هوایی ډګر، بلخ',
        cityId: 'MZR', lat: 36.6630, lng: 67.2090),
    PickupLocation(id: 'MZR_RWZ', nameFa: 'روضه مبارک', namePs: 'د مزار شریف روضه',
        addressFa: 'روضه مبارک مزار شریف', addressPs: 'د مزار شریف ولوله روضه',
        cityId: 'MZR', lat: 36.7077, lng: 67.1083),
    PickupLocation(id: 'MZR_CTR', nameFa: 'مرکز شهر', namePs: 'د ښار مرکز',
        addressFa: 'مرکز مزار شریف', addressPs: 'د مزار شریف مرکز',
        cityId: 'MZR', lat: 36.7097, lng: 67.1100),
    PickupLocation(id: 'MZR_KHB', nameFa: 'خیابان پنج', namePs: 'پنځه واله سړک',
        addressFa: 'خیابان ۵، مزار شریف', addressPs: 'پنځمه سړک، مزار شریف',
        cityId: 'MZR', lat: 36.7148, lng: 67.1210),
    PickupLocation(id: 'MZR_BLK', nameFa: 'بلخ', namePs: 'بلخ',
        addressFa: 'ولسوالی بلخ، بلخ', addressPs: 'د بلخ ولسوالي، بلخ',
        cityId: 'MZR', lat: 36.7604, lng: 66.8985),

    // ── قندهار ────────────────────────────────────────────────────────────
    PickupLocation(id: 'KDH_AIR', nameFa: 'فرودگاه قندهار', namePs: 'د کندهار هوایی ډګر',
        addressFa: 'فرودگاه قندهار', addressPs: 'د کندهار هوایی ډګر',
        cityId: 'KDH', lat: 31.5058, lng: 65.8479),
    PickupLocation(id: 'KDH_CTR', nameFa: 'مرکز شهر قندهار', namePs: 'د کندهار د ښار مرکز',
        addressFa: 'چهار راه قندهار', addressPs: 'د کندهار چارلاری',
        cityId: 'KDH', lat: 31.6180, lng: 65.7150),
    PickupLocation(id: 'KDH_MRJ', nameFa: 'میرویس میدان', namePs: 'میرویس میدان',
        addressFa: 'میدان میرویس، قندهار', addressPs: 'د میرویس میدان، کندهار',
        cityId: 'KDH', lat: 31.6265, lng: 65.7319),
    PickupLocation(id: 'KDH_SPJ', nameFa: 'سپین جلده', namePs: 'سپین جلده',
        addressFa: 'سپین جلده، قندهار', addressPs: 'سپین جلده، کندهار',
        cityId: 'KDH', lat: 31.5997, lng: 65.7034),

    // ── جلال آباد ─────────────────────────────────────────────────────────
    PickupLocation(id: 'JAL_CTR', nameFa: 'مرکز جلال آباد', namePs: 'د جلال آباد مرکز',
        addressFa: 'چهار راه جلال آباد', addressPs: 'د جلال آباد چارلاری',
        cityId: 'JAL', lat: 34.4272, lng: 70.4485),
    PickupLocation(id: 'JAL_UNI', nameFa: 'پوهنتون ننگرهار', namePs: 'د ننګرهار پوهنتون',
        addressFa: 'پوهنتون ننگرهار، جلال آباد', addressPs: 'د ننګرهار پوهنتون، جلال آباد',
        cityId: 'JAL', lat: 34.4355, lng: 70.4610),
    PickupLocation(id: 'JAL_SRK', nameFa: 'سرک عمومی', namePs: 'عمومي سړک',
        addressFa: 'جاده عمومی جلال آباد', addressPs: 'عمومي سړک جلال آباد',
        cityId: 'JAL', lat: 34.4200, lng: 70.4350),

    // ── کندز ──────────────────────────────────────────────────────────────
    PickupLocation(id: 'KNZ_CTR', nameFa: 'مرکز کندز', namePs: 'د کندز مرکز',
        addressFa: 'چهار راه کندز', addressPs: 'د کندز چارلاری',
        cityId: 'KNZ', lat: 36.7286, lng: 68.8681),
    PickupLocation(id: 'KNZ_BSM', nameFa: 'بسمه قلعه', namePs: 'بسمه قلعه',
        addressFa: 'بسمه قلعه، کندز', addressPs: 'بسمه قلعه، کندز',
        cityId: 'KNZ', lat: 36.7420, lng: 68.8870),

    // ── غزنی ──────────────────────────────────────────────────────────────
    PickupLocation(id: 'GHZ_CTR', nameFa: 'مرکز غزنی', namePs: 'د غزني مرکز',
        addressFa: 'چهار راه غزنی', addressPs: 'د غزني چارلاری',
        cityId: 'GHZ', lat: 33.5536, lng: 68.4192),
    PickupLocation(id: 'GHZ_BZR', nameFa: 'بازار غزنی', namePs: 'د غزني بازار',
        addressFa: 'بازار غزنی', addressPs: 'د غزني بازار',
        cityId: 'GHZ', lat: 33.5470, lng: 68.4100),

    // ── بامیان ────────────────────────────────────────────────────────────
    PickupLocation(id: 'BAM_CTR', nameFa: 'مرکز بامیان', namePs: 'د بامیان مرکز',
        addressFa: 'بازار بامیان', addressPs: 'د بامیان بازار',
        cityId: 'BAM', lat: 34.8196, lng: 67.8280),
    PickupLocation(id: 'BAM_BDH', nameFa: 'بت‌های بامیان', namePs: 'د بامیان بوتان',
        addressFa: 'مجسمه‌های باستانی بامیان', addressPs: 'د بامیان لرغوني مجسمې',
        cityId: 'BAM', lat: 34.8400, lng: 67.8265),

    // ── خوست ──────────────────────────────────────────────────────────────
    PickupLocation(id: 'KHO_CTR', nameFa: 'مرکز خوست', namePs: 'د خوست مرکز',
        addressFa: 'چهار راه خوست', addressPs: 'د خوست چارلاری',
        cityId: 'KHO', lat: 33.3338, lng: 69.9169),

    // ── گردیز ─────────────────────────────────────────────────────────────
    PickupLocation(id: 'PKT_CTR', nameFa: 'مرکز گردیز', namePs: 'د ګردیز مرکز',
        addressFa: 'بازار گردیز، پکتیا', addressPs: 'د ګردیز بازار، پکتیا',
        cityId: 'PKT', lat: 33.6012, lng: 69.2277),

    // ── پل خمری ───────────────────────────────────────────────────────────
    PickupLocation(id: 'BGL_CTR', nameFa: 'مرکز پل خمری', namePs: 'د پل خمري مرکز',
        addressFa: 'پل خمری، بغلان', addressPs: 'پل خمري، بغلان',
        cityId: 'BGL', lat: 35.9427, lng: 68.7167),

    // ── تالقان ────────────────────────────────────────────────────────────
    PickupLocation(id: 'TAK_CTR', nameFa: 'مرکز تالقان', namePs: 'د تالقان مرکز',
        addressFa: 'بازار تالقان، تخار', addressPs: 'د تالقان بازار، تخار',
        cityId: 'TAK', lat: 36.7347, lng: 69.5153),

    // ── شبرغان ────────────────────────────────────────────────────────────
    PickupLocation(id: 'JOZ_CTR', nameFa: 'مرکز شبرغان', namePs: 'د شبرغان مرکز',
        addressFa: 'بازار شبرغان، جوزجان', addressPs: 'د شبرغان بازار، جوزجان',
        cityId: 'JOZ', lat: 36.6550, lng: 65.7550),

    // ── میمنه ─────────────────────────────────────────────────────────────
    PickupLocation(id: 'FRB_CTR', nameFa: 'مرکز میمنه', namePs: 'د میمنې مرکز',
        addressFa: 'بازار میمنه، فاریاب', addressPs: 'د میمنې بازار، فاریاب',
        cityId: 'FRB', lat: 35.9208, lng: 64.7710),

    // ── چاریکار (پروان) ───────────────────────────────────────────────────
    PickupLocation(id: 'PAR_CTR', nameFa: 'مرکز چاریکار', namePs: 'د چاریکار مرکز',
        addressFa: 'بازار چاریکار، پروان', addressPs: 'د چاریکار بازار، پروان',
        cityId: 'PAR', lat: 35.0135, lng: 69.1736),

    // ── لشکرگاه (هلمند) ──────────────────────────────────────────────────
    PickupLocation(id: 'HLM_CTR', nameFa: 'مرکز لشکرگاه', namePs: 'د لشکرګاه مرکز',
        addressFa: 'لشکرگاه، هلمند', addressPs: 'لشکرګاه، هلمند',
        cityId: 'HLM', lat: 31.5933, lng: 64.3703),

    // ── فیض آباد (بدخشان) ────────────────────────────────────────────────
    PickupLocation(id: 'BDX_CTR', nameFa: 'مرکز فیض آباد', namePs: 'د فیض آباد مرکز',
        addressFa: 'بازار فیض آباد، بدخشان', addressPs: 'د فیض آباد بازار، بدخشان',
        cityId: 'BDX', lat: 37.1299, lng: 70.5799),

    // ── فراه ──────────────────────────────────────────────────────────────
    PickupLocation(id: 'FAR_CTR', nameFa: 'مرکز فراه', namePs: 'د فراه مرکز',
        addressFa: 'بازار فراه', addressPs: 'د فراه بازار',
        cityId: 'FAR', lat: 32.3740, lng: 62.1131),

    // ── زرنج (نیمروز) ─────────────────────────────────────────────────────
    PickupLocation(id: 'NIM_CTR', nameFa: 'مرکز زرنج', namePs: 'د زرنج مرکز',
        addressFa: 'بازار زرنج، نیمروز', addressPs: 'د زرنج بازار، نیمروز',
        cityId: 'NIM', lat: 31.0089, lng: 61.8714),
  ];

  static PickupLocation? locationById(String id) {
    try { return cityLocations.firstWhere((l) => l.id == id); }
    catch (_) { return null; }
  }

  static List<PickupLocation> locationsByCityId(String cityId) =>
      cityLocations.where((l) => l.cityId == cityId).toList();

  // ─── Ride Options ────────────────────────────────────────────────────────
  static const List<CityRideOption> rideOptions = [
    CityRideOption(
      id: 'ECONOMY',
      nameFa: 'اقتصادی', namePs: 'اقتصادي',
      descFa: 'سدان معمولی، مناسب‌ترین قیمت', descPs: 'عادي سیډان، ترټولو ارزانه',
      vehicleType: CityRideVehicleType.economy,
      baseFare: 80, perKmFare: 15,
      capacity: 3, minWaitMin: 3, maxWaitMin: 7,
    ),
    CityRideOption(
      id: 'COMFORT',
      nameFa: 'راحتی', namePs: 'آرامه',
      descFa: 'خودرو مدرن، راحت و تمیز', descPs: 'عصري موټر، آرام او پاک',
      vehicleType: CityRideVehicleType.comfort,
      baseFare: 130, perKmFare: 24,
      capacity: 4, minWaitMin: 5, maxWaitMin: 12,
    ),
    CityRideOption(
      id: 'SUV',
      nameFa: 'جیپ', namePs: 'جیپ',
      descFa: 'جیپ بزرگ، مناسب برای گروه', descPs: 'لوی جیپ، د ډلو لپاره مناسب',
      vehicleType: CityRideVehicleType.suv,
      baseFare: 200, perKmFare: 35,
      capacity: 6, minWaitMin: 5, maxWaitMin: 15,
    ),
  ];

  static CityRideOption? rideOptionById(String id) {
    try { return rideOptions.firstWhere((o) => o.id == id); }
    catch (_) { return null; }
  }

  // ─── Mock Drivers ─────────────────────────────────────────────────────────
  static const List<MockDriver> _drivers = [
    MockDriver(id: 'DR1', name: 'احمد خان', phone: '0700123456',
        vehicleMake: 'Toyota', vehicleModel: 'Corolla', plate: 'ک-۱۲۳۴۵',
        rating: 4.9, totalTrips: 1240, photoInitials: 'ا',
        lat: 34.5285, lng: 69.1730),
    MockDriver(id: 'DR2', name: 'محمد یوسف', phone: '0799876543',
        vehicleMake: 'Toyota', vehicleModel: 'Camry', plate: 'ک-۷۸۹۱۰',
        rating: 4.7, totalTrips: 876, photoInitials: 'م',
        lat: 34.5310, lng: 69.1810),
    MockDriver(id: 'DR3', name: 'عبدالله نوری', phone: '0701555666',
        vehicleMake: 'Honda', vehicleModel: 'Accord', plate: 'ک-۳۳۴۴۵',
        rating: 4.8, totalTrips: 2010, photoInitials: 'ع',
        lat: 34.5340, lng: 69.1690),
    MockDriver(id: 'DR4', name: 'خالد میرویس', phone: '0788112233',
        vehicleMake: 'Toyota', vehicleModel: 'Land Cruiser', plate: 'ک-۵۵۶۶۷',
        rating: 4.6, totalTrips: 3570, photoInitials: 'خ',
        lat: 34.5255, lng: 69.1850),
    MockDriver(id: 'DR5', name: 'نورالله حیدری', phone: '0703998877',
        vehicleMake: 'Mitsubishi', vehicleModel: 'Pajero', plate: 'ک-۹۹۰۰۱',
        rating: 4.8, totalTrips: 643, photoInitials: 'ن',
        lat: 34.5380, lng: 69.1760),
  ];

  static MockDriver driverForOption(String optionId) {
    final idx = optionId == 'ECONOMY' ? 0 : optionId == 'COMFORT' ? 1 : 3;
    return _drivers[idx % _drivers.length];
  }

  /// All drivers — used to show nearby markers on the radar map.
  static List<MockDriver> get nearbyDrivers => _drivers;
}