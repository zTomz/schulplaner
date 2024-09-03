abstract class SvgPictures {
  static const String path = "assets/svg/";
  static const String extension = ".svg";

  static String _get(String name) => "$path$name$extension";

  static String googleLogo = _get("google_logo");
}
