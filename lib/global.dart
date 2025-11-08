import 'package:lordan_v1/extensions/role_type.dart';
import 'package:lordan_v1/models/user_model.dart';
import 'package:lordan_v1/service/user_storage_service.dart';

class GlobalData {
  static int? messageCount = 0;
  static bool autoPlay = false;
  static String? planInProgresss;
  static bool hd_quality = false;

  static String email = "Guest User";
  static String? uid;
  static String plan = 'Free';
  static String? mode;
  static String? language = 'en';
  static bool isLoading = false;
  static dynamic session; // If you store Supabase Session
  static AppUser? user; // If you store Supabase User
  static List<Object> allRoles = [];
  static void setAutoReply(bool autoreply) => autoPlay = autoreply;
  // Setters
  static void setEmail(String newEmail) => email = newEmail;
  static void setUid(String? newUid) => uid = newUid;
  static void setPlan(String newPlan) => plan = newPlan;
  static void setCount(int newMessageCount) => messageCount = newMessageCount;
  static void setHdQuality(bool hdQuality) => hd_quality = hdQuality;

  static void setLanguage(String? newLang) => language = newLang;
  static void setLoading(bool value) => isLoading = value;
  static void setSession(dynamic newSession) => session = newSession;
  static void setUser(dynamic newUser) => user = newUser;

  static final Set<RoleType> _selectedRoles = {};

  static Set<RoleType> get selectedRoles => Set.unmodifiable(_selectedRoles);

  static void toggleRole(RoleType role,
      {bool allowPremium = false, bool isPremiumUser = false}) {
    if (role.isPremium && !isPremiumUser && !allowPremium) {
      print("Role already exist");
      print(_selectedRoles);
      print(selectedRoles);
      return;
    }

    if (_selectedRoles.contains(role)) {
      _selectedRoles.remove(role);
    } else {
      print("role added $role");
      _selectedRoles.add(role);
      print(_selectedRoles);
      print(selectedRoles);
    }
  }

  // Reset all data
  static void reset() {
    email = "";
    uid = null;
    plan = 'Free';
    mode = null;
    language = null;
    isLoading = false;
    session = null;
    user = null;
  }
}
