abstract class SvgPictures {
  static const String path = "assets/svg/";
  static const String extension = ".svg";

  static String _get(String name) => "$path$name$extension";

  static String no_data_light = _get("no_data_light");
  static String no_data_dark = _get("no_data_dark");
}
