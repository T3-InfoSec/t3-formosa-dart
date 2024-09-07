import 'themes/themes.dart';
import 'theme_base.dart';

enum FormosaTheme {
  bip39(
    label: 'bip39',
    theme: ThemeBase(themeData: bip39Data),
  ),
  bip39French(
    label: 'bip39_french',
    theme: ThemeBase(themeData: bip39FrenchData),
  ),
  copyLeft(
    label: 'copy_left',
    theme: ThemeBase(themeData: copyLeftData),
  ),
  cutePets(
    label: 'cute_pets',
    theme: ThemeBase(themeData: cutePetsData),
  ),
  farmAnimals(
    label: 'farm_animals',
    theme: ThemeBase(themeData: farmAnimalsData),
  ),
  finances(
    label: 'finances',
    theme: ThemeBase(themeData: financesData),
  ),
  medievalFantasy(
    label: 'medieval_fantasy',
    theme: ThemeBase(themeData: medievalFantasyData),
  ),
  sciFi(
    label: 'sci_fi',
    theme: ThemeBase(themeData: sciFiData),
  ),
  medievalFantasyLight(
    label: 'medieval_fantasy_light',
    theme: ThemeBase(themeData: medievalFantasyLightData),
  ),
  tourism(
    label: 'tourism',
    theme: ThemeBase(themeData: tourismData),
  );



  final String _label;
  final ThemeBase _themeData;

  const FormosaTheme({required label, required theme})
      : _label = label,
        _themeData = theme;

  String get label => _label;

  ThemeBase get themeData => _themeData;
}
