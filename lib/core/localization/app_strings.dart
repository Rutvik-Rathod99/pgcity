enum AppLanguage {
  english('English', 'EN', '🇺🇸'),
  gujarati('ગુજરાતી', 'GU', '🇮🇳'),
  hindi('हिन्दी', 'HI', '🇮🇳');

  final String label;
  final String code;
  final String flag;
  const AppLanguage(this.label, this.code, this.flag);
}

class AppStrings {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      // Navigation
      'nav_explore': 'Explore',
      'nav_map': 'Map Search',
      'nav_liked': 'Shortlisted',
      'nav_profile': 'Profile',
      'nav_admin': 'Admin',

      // Home & Search
      'app_title': 'PGCity Ahmedabad',
      'app_subtitle': 'Curated verified PGs near CEPT, Nirma, PDPU & SG Highway',
      'search_hint': 'Search by PG name, locality (Navrangpura, Satellite...)',
      'filter_all': 'All PGs',
      'filter_girls': 'Girls PG',
      'filter_boys': 'Boys PG',
      'filter_coed': 'Co-Ed Living',
      'filter_price': 'Budget',
      'filter_under_10k': 'Under ₹10,000',
      'filter_above_10k': '₹10,000+',
      'curated_count': 'verified spaces found in Ahmedabad',

      // PG Details
      'monthly_rent': 'Monthly Rent',
      'food_kitchen': 'Food & Kitchen',
      'amenities': 'Key Amenities',
      'virtual_tour': '360° Room Tour',
      'contact_owner': 'Contact Landlord',
      'enroll_now': 'Enroll & Book',
      'house_rules': 'House Rules & Curfew',
      'sharing_options': 'Sharing Options',
      'verified_badge': 'PGCity 100% Physically Verified',

      // Profile & Settings
      'my_profile': 'My Profile',
      'guest_user': 'Guest Explorer',
      'sign_in_cta': 'Sign In / Register',
      'sign_in_desc': 'Sign in to shortlist PGs, unlock contacts & track enrollments.',
      'my_enrollments': 'My Enrollments',
      'account_settings': 'Appearance & Preferences',
      'theme_mode': 'App Appearance (Light / Dark)',
      'font_style': 'Typography & Font Family',
      'language_selection': 'App Language',
      'in_app_rating': 'Rate PGCity on App Store',
      'terms_conditions': 'Terms and Conditions',
      'privacy_policy': 'Privacy Policy & DPDP Notice',
      'admin_portal': 'Admin Onboarding Portal',
      'log_out': 'Log Out',
      'app_version': 'App Version',
      'delete_account': 'Delete Account (Right to Erasure)',
      'delete_apple_account': 'Delete Apple Account (Apple Guideline 5.1.1v)',

      // Auth
      'sign_in_title': 'Sign In to PGCity',
      'phone_otp_tab': 'Phone + OTP',
      'phone_pass_tab': 'Phone + Pass',
      'email_pass_tab': 'Email + Pass',
      'continue_google': 'Continue with Google',
      'sign_in_apple': 'Sign in with Apple',
      'create_account': 'Create Account',
      'skip_guest': 'Skip & Explore as Guest →',
    },
    'gu': {
      // Navigation
      'nav_explore': 'શોધો (Explore)',
      'nav_map': 'નકશો (Map)',
      'nav_liked': 'પસંદ કરેલ (Liked)',
      'nav_profile': 'પ્રોફાઇલ (Profile)',
      'nav_admin': 'એડમિન (Admin)',

      // Home & Search
      'app_title': 'પીજી સિટી અમદાવાદ',
      'app_subtitle': 'CEPT, Nirma, PDPU અને SG હાઇવે નજીક ચકાસાયેલ PGs',
      'search_hint': 'પીજીનું નામ અથવા વિસ્તાર શોધો (નવરંગપુરા, સેટેલાઇટ...)',
      'filter_all': 'બધા PGs',
      'filter_girls': 'ગર્લ્સ પીજી',
      'filter_boys': 'બોય્ઝ પીજી',
      'filter_coed': 'કો-એડ લિવિંગ',
      'filter_price': 'બજેટ',
      'filter_under_10k': '₹૧૦,૦૦૦ થી ઓછું',
      'filter_above_10k': '₹૧૦,૦૦૦+',
      'curated_count': 'અમદાવાદમાં ચકાસાયેલ રૂમો ઉપલબ્ધ',

      // PG Details
      'monthly_rent': 'માસિક ભાડું',
      'food_kitchen': 'જમવાનું અને રસોડું',
      'amenities': 'સુવિધાઓ',
      'virtual_tour': '૩૬૦° રૂમ ટૂર',
      'contact_owner': 'માલિકનો સંપર્ક કરો',
      'enroll_now': 'એડમિશન અરજી કરો',
      'house_rules': 'પીજીના નિયમો',
      'sharing_options': 'શેરિંગ વિકલ્પો',
      'verified_badge': 'પીજી સિટી ૧૦૦% ચકાસાયેલ',

      // Profile & Settings
      'my_profile': 'મારી પ્રોફાઇલ',
      'guest_user': 'મહેમાન વપરાશકર્તા',
      'sign_in_cta': 'સાઇન ઇન / રજીસ્ટર કરો',
      'sign_in_desc': 'પીજી સાચવવા અને સંપર્ક અનલૉક કરવા સાઇન ઇન કરો.',
      'my_enrollments': 'મારી અરજીઓ',
      'account_settings': 'દેખાવ અને સેટિંગ્સ',
      'theme_mode': 'ડાર્ક / લાઇટ મોડ',
      'font_style': 'ફોન્ટ સ્ટાઇલ',
      'language_selection': 'ભાષા પસંદ કરો (Language)',
      'in_app_rating': 'પીજી સિટીને રેટિંગ આપો',
      'terms_conditions': 'નિયમો અને શરતો (Terms)',
      'privacy_policy': 'ગોપનીયતા નીતિ (Privacy)',
      'admin_portal': 'એડમિન પોર્ટલ',
      'log_out': 'લૉગ આઉટ',
      'app_version': 'એપ્લિકેશન વર્ઝન',
      'delete_account': 'એકાઉન્ટ ડિલીટ કરો',
      'delete_apple_account': 'એપલ એકાઉન્ટ ડિલીટ કરો (Apple 5.1.1v)',

      // Auth
      'sign_in_title': 'પીજી સિટીમાં સાઇન ઇન કરો',
      'phone_otp_tab': 'મોબાઇલ + OTP',
      'phone_pass_tab': 'મોબાઇલ + પાસવર્ડ',
      'email_pass_tab': 'ઇમેઇલ + પાસવર્ડ',
      'continue_google': 'Google સાથે ચાલુ રાખો',
      'sign_in_apple': 'Apple ID સાથે સાઇન ઇન',
      'create_account': 'નવું એકાઉન્ટ બનાવો',
      'skip_guest': 'મહેમાન તરીકે આગળ વધો →',
    },
    'hi': {
      // Navigation
      'nav_explore': 'खोजें (Explore)',
      'nav_map': 'मानचित्र (Map)',
      'nav_liked': 'पसंदीदा (Liked)',
      'nav_profile': 'प्रोफ़ाइल (Profile)',
      'nav_admin': 'एडमिन (Admin)',

      // Home & Search
      'app_title': 'पीजी सिटी अहमदाबाद',
      'app_subtitle': 'CEPT, Nirma, PDPU और SG हाईवे के पास सत्यापित PGs',
      'search_hint': 'पीजी का नाम या इलाका खोजें (नवरंगपुरा, सैटेलाइट...)',
      'filter_all': 'सभी PGs',
      'filter_girls': 'गर्ल्स पीजी',
      'filter_boys': 'बॉयज पीजी',
      'filter_coed': 'को-एड लिविंग',
      'filter_price': 'बजट',
      'filter_under_10k': '₹10,000 से कम',
      'filter_above_10k': '₹10,000+',
      'curated_count': 'सत्यापित पीजी अहमदाबाद में उपलब्ध',

      // PG Details
      'monthly_rent': 'मासिक किराया',
      'food_kitchen': 'भोजन एवं रसोई',
      'amenities': 'मुख्य सुविधाएं',
      'virtual_tour': '360° रूम टूर',
      'contact_owner': 'मालिक से संपर्क करें',
      'enroll_now': 'नामांकन आवेदन करें',
      'house_rules': 'नियम एवं शर्तें',
      'sharing_options': 'शेयरिंग विकल्प',
      'verified_badge': 'पीजी सिटी 100% सत्यापित',

      // Profile & Settings
      'my_profile': 'मेरी प्रोफ़ाइल',
      'guest_user': 'अतिथि उपयोगकर्ता',
      'sign_in_cta': 'साइन इन / रजिस्टर करें',
      'sign_in_desc': 'पीजी सेव करने और संपर्क नंबर देखने हेतु साइन इन करें।',
      'my_enrollments': 'मेरे नामांकन',
      'account_settings': 'दिखावट एवं प्राथमिकताएं',
      'theme_mode': 'डार्क / लाइट मोड',
      'font_style': 'फ़ॉन्ट स्टाइल',
      'language_selection': 'भाषा का चयन (Language)',
      'in_app_rating': 'ऐप को रेटिंग दें',
      'terms_conditions': 'नियम और शर्तें (Terms)',
      'privacy_policy': 'गोपनीयता नीति (Privacy)',
      'admin_portal': 'एडमिन पोर्टल',
      'log_out': 'लॉग आउट',
      'app_version': 'ऐप संस्करण',
      'delete_account': 'अकाउंट डिलीट करें',
      'delete_apple_account': 'एप्पल अकाउंट डिलीट करें (Apple 5.1.1v)',

      // Auth
      'sign_in_title': 'पीजी सिटी में साइन इन करें',
      'phone_otp_tab': 'मोबाइल + OTP',
      'phone_pass_tab': 'मोबाइल + पासवर्ड',
      'email_pass_tab': 'ईमेल + पासवर्ड',
      'continue_google': 'Google से जारी रखें',
      'sign_in_apple': 'Apple ID से साइन इन',
      'create_account': 'नया खाता बनाएं',
      'skip_guest': 'अतिथि के रूप में आगे बढ़ें →',
    },
  };

  static String get(String key, AppLanguage lang) {
    final code = lang == AppLanguage.gujarati ? 'gu' : (lang == AppLanguage.hindi ? 'hi' : 'en');
    return _translations[code]?[key] ?? _translations['en']?[key] ?? key;
  }
}
