
import 'themes/themes.dart';
import 'theme_base.dart';

enum FormosaTheme {
  bip39(
    name: 'bip39',
    theme: ThemeBase(themeData: bip39Data),
  ),
  bip39French(
    name: 'bip39_french',
    theme: ThemeBase(themeData: bip39FrenchData),
  ),
  copyLeft(
    name: 'copy_left',
    theme: ThemeBase(themeData: copyLeftData),
  ),
  cutePets(
    name: 'cute_pets',
    theme: ThemeBase(themeData: cutePetsData),
  ),
  farmAnimals(
    name: 'farm_animals',
    theme: ThemeBase(themeData: farmAnimalsData),
  ),
  finances(
    name: 'finances',
    theme: ThemeBase(themeData: financesData),
  ),
  medievalFantasy(
    name: 'medieval_fantasy',
    theme: ThemeBase(themeData: medievalFantasyData),
  ),
  sciFi(
    name: 'sci_fi',
    theme: ThemeBase(themeData: sciFiData),
  ),
  medievalFantasyLight(
    name: 'medievalFantasyLight',
    theme: ThemeBase(themeData: medievalFantasyLightData),
  ),
  formosaGLobal(
    name: 'formosaGLobal',
    theme: ThemeBase(themeData: formosaGLobalData),
  ),
  tourism(
    name: 'tourism',
    theme: ThemeBase(themeData: tourismData),
  );


  final String _name;
  final ThemeBase _data;

  const FormosaTheme({required name, required theme})
      : _name = name,
        _data = theme;

  String get name => _name;

  ThemeBase get data => _data;
}
