/// All user-facing strings in Dari and Pashto.
/// English only used as key names (internal), never rendered.
class AppStrings {
  AppStrings._();

  // ─── App ───────────────────────────────────────────────────────────────────
  static const Map<String, String> appName = {
    'fa': 'سیر۳۴',
    'ps': 'سیر۳۴',
  };
  static const Map<String, String> appTagline = {
    'fa': 'رزرو آنلاین تاکسی بین شهری افغانستان',
    'ps': 'د افغانستان د ښارونو ترمنځ آنلاین ټکسي',
  };

  // ─── Language Selection ────────────────────────────────────────────────────
  static const Map<String, String> selectLanguage = {
    'fa': 'زبان را انتخاب کنید',
    'ps': 'ژبه غوره کړئ',
  };
  static const Map<String, String> dari = {
    'fa': 'دری',
    'ps': 'دري',
  };
  static const Map<String, String> pashto = {
    'fa': 'پشتو',
    'ps': 'پښتو',
  };
  static const Map<String, String> continueBtn = {
    'fa': 'ادامه',
    'ps': 'دوام',
  };

  // ─── Auth ──────────────────────────────────────────────────────────────────
  static const Map<String, String> login = {
    'fa': 'ورود',
    'ps': 'ننوتل',
  };
  static const Map<String, String> register = {
    'fa': 'ثبت نام',
    'ps': 'نوم لیکنه',
  };
  static const Map<String, String> forgotPassword = {
    'fa': 'فراموشی رمز عبور',
    'ps': 'پټ نوم هیر شوی',
  };
  static const Map<String, String> phoneNumber = {
    'fa': 'شماره تیلیفون',
    'ps': 'د تیلیفون شمیره',
  };
  static const Map<String, String> password = {
    'fa': 'رمز عبور',
    'ps': 'پټ نوم',
  };
  static const Map<String, String> confirmPassword = {
    'fa': 'تایید رمز عبور',
    'ps': 'د پټ نوم تایید',
  };
  static const Map<String, String> fullName = {
    'fa': 'نام و نام خانوادگی',
    'ps': 'بشپړ نوم',
  };
  static const Map<String, String> dontHaveAccount = {
    'fa': 'حساب ندارید؟',
    'ps': 'حساب نلرئ؟',
  };
  static const Map<String, String> alreadyHaveAccount = {
    'fa': 'حساب دارید؟',
    'ps': 'حساب لرئ؟',
  };
  static const Map<String, String> verifyPhone = {
    'fa': 'تایید شماره تیلیفون',
    'ps': 'د تیلیفون شمیره تایید',
  };
  static const Map<String, String> otpSentTo = {
    'fa': 'کد تایید ارسال شد به',
    'ps': 'د تایید کوډ ولیږل شو',
  };
  static const Map<String, String> verify = {
    'fa': 'تایید',
    'ps': 'تایید',
  };
  static const Map<String, String> resendCode = {
    'fa': 'ارسال مجدد کد',
    'ps': 'کوډ بیا ولیږئ',
  };
  static const Map<String, String> logout = {
    'fa': 'خروج از حساب',
    'ps': 'له حساب وتل',
  };

  // ─── Navigation ────────────────────────────────────────────────────────────
  static const Map<String, String> home = {
    'fa': 'خانه',
    'ps': 'کور',
  };
  static const Map<String, String> myTrips = {
    'fa': 'سفرهای من',
    'ps': 'زما سفرونه',
  };
  static const Map<String, String> profile = {
    'fa': 'پروفایل',
    'ps': 'پروفایل',
  };
  static const Map<String, String> notifications = {
    'fa': 'اعلان ها',
    'ps': 'خبرتیاوې',
  };

  // ─── Home / Search ─────────────────────────────────────────────────────────
  static const Map<String, String> whereFrom = {
    'fa': 'از کجا؟',
    'ps': 'له چیرې؟',
  };
  static const Map<String, String> whereTo = {
    'fa': 'به کجا؟',
    'ps': 'چیرته؟',
  };
  static const Map<String, String> travelDate = {
    'fa': 'تاریخ سفر',
    'ps': 'د سفر نیټه',
  };
  static const Map<String, String> passengerCount = {
    'fa': 'تعداد مسافران',
    'ps': 'د مسافرینو شمیر',
  };
  static const Map<String, String> searchTrips = {
    'fa': 'جستجوی سفر',
    'ps': 'د سفر لټون',
  };
  static const Map<String, String> search = {
    'fa': 'جستجو',
    'ps': 'لټون',
  };
  static const Map<String, String> popularRoutes = {
    'fa': 'مسیرهای محبوب',
    'ps': 'مشهور لارې',
  };
  static const Map<String, String> greeting = {
    'fa': 'سلام',
    'ps': 'سلام',
  };
  static const Map<String, String> readyForJourney = {
    'fa': 'آماده سفر هستید؟',
    'ps': 'د سفر لپاره چمتو یئ؟',
  };

  // ─── Search Results ────────────────────────────────────────────────────────
  static const Map<String, String> availableTrips = {
    'fa': 'سفرهای موجود',
    'ps': 'موجود سفرونه',
  };
  static const Map<String, String> noTripsFound = {
    'fa': 'سفری یافت نشد',
    'ps': 'سفر ونه موندل شو',
  };
  static const Map<String, String> sortBy = {
    'fa': 'مرتب سازی',
    'ps': 'ترتیب',
  };
  static const Map<String, String> filterBy = {
    'fa': 'فیلتر',
    'ps': 'فلټر',
  };
  static const Map<String, String> lowestPrice = {
    'fa': 'ارزان ترین',
    'ps': 'ترټولو ارزانه',
  };
  static const Map<String, String> highestPrice = {
    'fa': 'گران ترین',
    'ps': 'ترټولو ګرانه',
  };
  static const Map<String, String> earliestTime = {
    'fa': 'زودترین',
    'ps': 'ترټولو ژر',
  };
  static const Map<String, String> latestTime = {
    'fa': 'دیرترین',
    'ps': 'ترټولو ناوخته',
  };

  // ─── Trip Card / Details ───────────────────────────────────────────────────
  static const Map<String, String> departure = {
    'fa': 'حرکت',
    'ps': 'روانیدل',
  };
  static const Map<String, String> arrival = {
    'fa': 'رسیدن',
    'ps': 'رسیدل',
  };
  static const Map<String, String> duration = {
    'fa': 'مدت سفر',
    'ps': 'د سفر موده',
  };
  static const Map<String, String> seatsAvailable = {
    'fa': 'صندلی موجود',
    'ps': 'خالي کرسۍ',
  };
  static const Map<String, String> price = {
    'fa': 'قیمت',
    'ps': 'قیمت',
  };
  static const Map<String, String> afghani = {
    'fa': 'افغانی',
    'ps': 'افغانۍ',
  };
  static const Map<String, String> vehicleType = {
    'fa': 'نوع وسیله',
    'ps': 'د موټر ډول',
  };
  static const Map<String, String> driverName = {
    'fa': 'نام راننده',
    'ps': 'د موټروان نوم',
  };
  static const Map<String, String> companyName = {
    'fa': 'نام شرکت',
    'ps': 'د شرکت نوم',
  };
  static const Map<String, String> selectTrip = {
    'fa': 'انتخاب سفر',
    'ps': 'سفر غوره کړئ',
  };
  static const Map<String, String> tripDetails = {
    'fa': 'جزئیات سفر',
    'ps': 'د سفر تفصیل',
  };
  static const Map<String, String> services = {
    'fa': 'خدمات',
    'ps': 'خدمتونه',
  };
  static const Map<String, String> ac = {
    'fa': 'تهویه مطبوع',
    'ps': 'تودوخه کنټرول',
  };
  static const Map<String, String> wifi = {
    'fa': 'وای فای',
    'ps': 'وای فای',
  };
  static const Map<String, String> luggage = {
    'fa': 'مجوز چمدان',
    'ps': 'بستې اجازه',
  };
  static const Map<String, String> stops = {
    'fa': 'توقف ها',
    'ps': 'درنګونه',
  };
  static const Map<String, String> driverInfo = {
    'fa': 'اطلاعات راننده',
    'ps': 'د موټروان معلومات',
  };
  static const Map<String, String> vehicleInfo = {
    'fa': 'اطلاعات وسیله',
    'ps': 'د موټر معلومات',
  };
  static const Map<String, String> plateNumber = {
    'fa': 'شماره پلیت',
    'ps': 'د پلیټ شمیره',
  };
  static const Map<String, String> rating = {
    'fa': 'امتیاز',
    'ps': 'ریټینګ',
  };

  // ─── Vehicle Types ─────────────────────────────────────────────────────────
  static const Map<String, String> sedan = {
    'fa': 'سدان',
    'ps': 'سیډان',
  };
  static const Map<String, String> suv = {
    'fa': 'جیپ',
    'ps': 'جیپ',
  };
  static const Map<String, String> van = {
    'fa': 'ون',
    'ps': 'وین',
  };
  static const Map<String, String> minibus = {
    'fa': 'مینی بس',
    'ps': 'مینی بس',
  };

  // ─── Seat Selection ────────────────────────────────────────────────────────
  static const Map<String, String> selectSeat = {
    'fa': 'صندلی را انتخاب کنید',
    'ps': 'کرسۍ غوره کړئ',
  };
  static const Map<String, String> seatAvailable = {
    'fa': 'موجود',
    'ps': 'خالي',
  };
  static const Map<String, String> seatBooked = {
    'fa': 'رزرو شده',
    'ps': 'ذخیره شوی',
  };
  static const Map<String, String> seatSelected = {
    'fa': 'انتخاب شده',
    'ps': 'غوره شوی',
  };
  static const Map<String, String> driver = {
    'fa': 'راننده',
    'ps': 'موټروان',
  };
  static const Map<String, String> continueBooking = {
    'fa': 'ادامه رزرو',
    'ps': 'د ذخیرې دوام',
  };

  // ─── Booking ───────────────────────────────────────────────────────────────
  static const Map<String, String> bookingProcess = {
    'fa': 'فرآیند رزرو',
    'ps': 'د ذخیرې پروسه',
  };
  static const Map<String, String> passengerInfo = {
    'fa': 'اطلاعات مسافر',
    'ps': 'د مسافر معلومات',
  };
  static const Map<String, String> contactInfo = {
    'fa': 'اطلاعات تماس',
    'ps': 'د اړیکې معلومات',
  };
  static const Map<String, String> paymentMethod = {
    'fa': 'روش پرداخت',
    'ps': 'د تادیې طریقه',
  };
  static const Map<String, String> bookingConfirmation = {
    'fa': 'تایید رزرو',
    'ps': 'د ذخیرې تایید',
  };
  static const Map<String, String> nationalId = {
    'fa': 'شماره تذکره',
    'ps': 'د تذکرې شمیره',
  };
  static const Map<String, String> email = {
    'fa': 'ایمیل',
    'ps': 'برېښنالیک',
  };
  static const Map<String, String> emergencyContact = {
    'fa': 'تماس اضطراری',
    'ps': 'بیړنۍ اړیکه',
  };
  static const Map<String, String> onlinePayment = {
    'fa': 'پرداخت آنلاین',
    'ps': 'آنلاین تادیه',
  };
  static const Map<String, String> payAtPickup = {
    'fa': 'پرداخت در لحظه سوار شدن',
    'ps': 'د سوار کیدو پر وخت تادیه',
  };
  static const Map<String, String> totalPrice = {
    'fa': 'مجموع مبلغ',
    'ps': 'ټول قیمت',
  };
  static const Map<String, String> confirmBooking = {
    'fa': 'تایید رزرو',
    'ps': 'ذخیره تایید کړئ',
  };
  static const Map<String, String> seat = {
    'fa': 'صندلی',
    'ps': 'کرسۍ',
  };

  // ─── Ticket ────────────────────────────────────────────────────────────────
  static const Map<String, String> digitalTicket = {
    'fa': 'بلیط دیجیتال',
    'ps': 'ډیجیټل ټکټ',
  };
  static const Map<String, String> bookingId = {
    'fa': 'شماره رزرو',
    'ps': 'د ذخیرې شمیره',
  };
  static const Map<String, String> shareTicket = {
    'fa': 'اشتراک گذاری بلیط',
    'ps': 'ټکټ شریک کړئ',
  };
  static const Map<String, String> downloadTicket = {
    'fa': 'دانلود بلیط',
    'ps': 'ټکټ ډاونلوډ کړئ',
  };
  static const Map<String, String> perSeat = {
    'fa': 'هر صندلی',
    'ps': 'هره کرسۍ',
  };
  static const Map<String, String> showToDriver = {
    'fa': 'این کد را به راننده نشان دهید',
    'ps': 'دا کوډ موټروان ته وښایه',
  };
  static const Map<String, String> bookingSuccess = {
    'fa': 'رزرو با موفقیت انجام شد',
    'ps': 'ذخیره بریالۍ وه',
  };
  static const Map<String, String> bookingDate = {
    'fa': 'تاریخ رزرو',
    'ps': 'د ذخیرې نیټه',
  };

  // ─── My Trips ──────────────────────────────────────────────────────────────
  static const Map<String, String> upcoming = {
    'fa': 'آینده',
    'ps': 'راتلونکی',
  };
  static const Map<String, String> completed = {
    'fa': 'تکمیل شده',
    'ps': 'بشپړ شوی',
  };
  static const Map<String, String> cancelled = {
    'fa': 'لغو شده',
    'ps': 'لغوه شوی',
  };
  static const Map<String, String> noUpcomingTrips = {
    'fa': 'سفر آینده ای ندارید',
    'ps': 'راتلونکی سفر نلرئ',
  };
  static const Map<String, String> viewTicket = {
    'fa': 'مشاهده بلیط',
    'ps': 'ټکټ وګورئ',
  };
  static const Map<String, String> cancelTrip = {
    'fa': 'لغو سفر',
    'ps': 'سفر لغوه کړئ',
  };

  // ─── Profile ───────────────────────────────────────────────────────────────
  static const Map<String, String> myProfile = {
    'fa': 'پروفایل من',
    'ps': 'زما پروفایل',
  };
  static const Map<String, String> editProfile = {
    'fa': 'ویرایش پروفایل',
    'ps': 'پروفایل سمول',
  };
  static const Map<String, String> languageSettings = {
    'fa': 'تنظیمات زبان',
    'ps': 'د ژبې تنظیمات',
  };
  static const Map<String, String> appSettings = {
    'fa': 'تنظیمات برنامه',
    'ps': 'د اپلیکیشن تنظیمات',
  };
  static const Map<String, String> helpSupport = {
    'fa': 'راهنما و پشتیبانی',
    'ps': 'مرسته او ملاتړ',
  };
  static const Map<String, String> aboutApp = {
    'fa': 'درباره برنامه',
    'ps': 'د اپلیکیشن اړه',
  };
  static const Map<String, String> totalBookings = {
    'fa': 'مجموع رزروها',
    'ps': 'ټولې ذخیرې',
  };
  static const Map<String, String> member = {
    'fa': 'عضو',
    'ps': 'غړی',
  };

  // ─── Common ────────────────────────────────────────────────────────────────
  static const Map<String, String> back = {
    'fa': 'بازگشت',
    'ps': 'شاته',
  };
  static const Map<String, String> next = {
    'fa': 'بعدی',
    'ps': 'بل',
  };
  static const Map<String, String> save = {
    'fa': 'ذخیره',
    'ps': 'خوندي کول',
  };
  static const Map<String, String> cancel = {
    'fa': 'لغو',
    'ps': 'لغوه',
  };
  static const Map<String, String> confirm = {
    'fa': 'تایید',
    'ps': 'تایید',
  };
  static const Map<String, String> yes = {
    'fa': 'بله',
    'ps': 'هو',
  };
  static const Map<String, String> no = {
    'fa': 'خیر',
    'ps': 'نه',
  };
  static const Map<String, String> loading = {
    'fa': 'در حال بارگذاری...',
    'ps': 'لوډیږي...',
  };
  static const Map<String, String> hours = {
    'fa': 'ساعت',
    'ps': 'ساعت',
  };
  static const Map<String, String> passengers = {
    'fa': 'مسافر',
    'ps': 'مسافر',
  };
  static const Map<String, String> from = {
    'fa': 'از',
    'ps': 'له',
  };
  static const Map<String, String> to = {
    'fa': 'به',
    'ps': 'ته',
  };
  static const Map<String, String> today = {
    'fa': 'امروز',
    'ps': 'نن',
  };
  static const Map<String, String> tomorrow = {
    'fa': 'فردا',
    'ps': 'سبا',
  };

  // ─── Errors / Validation ───────────────────────────────────────────────────
  static const Map<String, String> fieldRequired = {
    'fa': 'این فیلد الزامی است',
    'ps': 'دا برخه اړینه ده',
  };
  static const Map<String, String> invalidPhone = {
    'fa': 'شماره تیلیفون نامعتبر است',
    'ps': 'د تیلیفون شمیره ناسمه ده',
  };
  static const Map<String, String> passwordTooShort = {
    'fa': 'رمز عبور باید حداقل ۶ کاراکتر باشد',
    'ps': 'پټ نوم باید لږترلږه ۶ توري ولري',
  };
  static const Map<String, String> passwordsNotMatch = {
    'fa': 'رمزهای عبور یکسان نیستند',
    'ps': 'پټ نومونه سره سمون نه خوري',
  };
  static const Map<String, String> selectSeatFirst = {
    'fa': 'لطفا ابتدا صندلی را انتخاب کنید',
    'ps': 'مهرباني وکړه لومړی کرسۍ غوره کړئ',
  };
  static const Map<String, String> selectCities = {
    'fa': 'لطفا شهر مبدا و مقصد را انتخاب کنید',
    'ps': 'مهرباني وکړه د پیل او منزل ښارونه غوره کړئ',
  };
  static const Map<String, String> somethingWentWrong = {
    'fa': 'مشکلی پیش آمد، دوباره تلاش کنید',
    'ps': 'ستونزه رامنځته شوه، بیا هڅه وکړئ',
  };

  // ─── Cities ────────────────────────────────────────────────────────────────
  static const Map<String, String> kabul = {
    'fa': 'کابل',
    'ps': 'کابل',
  };
  static const Map<String, String> herat = {
    'fa': 'هرات',
    'ps': 'هرات',
  };
  static const Map<String, String> kandahar = {
    'fa': 'قندهار',
    'ps': 'کندهار',
  };
  static const Map<String, String> mazarSharif = {
    'fa': 'مزار شریف',
    'ps': 'مزار شریف',
  };
  static const Map<String, String> jalalabad = {
    'fa': 'جلال آباد',
    'ps': 'جلال آباد',
  };
  static const Map<String, String> kunduz = {
    'fa': 'کندز',
    'ps': 'کندز',
  };
  static const Map<String, String> bamyan = {
    'fa': 'بامیان',
    'ps': 'بامیان',
  };
  static const Map<String, String> ghazni = {
    'fa': 'غزنی',
    'ps': 'غزني',
  };

  // ─── Booking Status ────────────────────────────────────────────────────────
  static const Map<String, String> confirmed = {
    'fa': 'تایید شده',
    'ps': 'تایید شوی',
  };
  static const Map<String, String> pending = {
    'fa': 'در انتظار',
    'ps': 'انتظار',
  };

  // ─── My Trips Extra ────────────────────────────────────────────────────────
  static const Map<String, String> noBookings = {
    'fa': 'رزروی ندارید',
    'ps': 'ذخیره نلرئ',
  };
  static const Map<String, String> loginRequired = {
    'fa': 'برای مشاهده سفرها وارد حساب شوید',
    'ps': 'د سفرونو لیدو لپاره ننوتل اړین دي',
  };

  // ─── Profile Extra ────────────────────────────────────────────────────────
  static const Map<String, String> loginOrRegister = {
    'fa': 'ورود / ثبت نام',
    'ps': 'ننوتل / نوم لیکنه',
  };
  static const Map<String, String> guest = {
    'fa': 'مهمان',
    'ps': 'مهمان',
  };
  static const Map<String, String> bookings = {
    'fa': 'رزرو',
    'ps': 'ذخیره',
  };
  static const Map<String, String> changeLanguage = {
    'fa': 'تغییر زبان',
    'ps': 'ژبه بدلول',
  };
  static const Map<String, String> help = {
    'fa': 'راهنما',
    'ps': 'مرسته',
  };
  static const Map<String, String> about = {
    'fa': 'درباره',
    'ps': 'اړه',
  };

  // ─── Helper ────────────────────────────────────────────────────────────────
  static String get(Map<String, String> map, String lang) {
    return map[lang] ?? map['fa'] ?? '';
  }
}
