import 'bip39.dart';
import 'bip39_french.dart';
import 'copy_left.dart';
import 'cute_pets.dart';
import 'farm_animals.dart';
import 'finances.dart';
import 'medieval_fantasy.dart';
import 'sci_fi.dart';
import 'tourism.dart';

enum Theme {
  bip39(label: 'bip39', themeData: bip39Data),
  bip39French(label: 'bip39_french', themeData: bip39FrenchData),
  copyLeft(label: 'copy_left', themeData: copyLeftData),
  cutePets(label: 'cute_pets', themeData: cutePetsData),
  farmAnimals(label: 'farm_animals', themeData: farmAnimalsData),
  finances(label: 'finances', themeData: financesData),
  medievalFantasy(label: 'medieval_fantasy', themeData: medievalFantasyData),
  sciFi(label: 'sci_fi', themeData: sciFiData),
  tourism(label: 'tourism', themeData: tourismData);

  final String _label;
  final Map<String, dynamic> _themeData;

  const Theme({required label, required themeData})
      : _label = label,
        _themeData = themeData;

  String get label => _label;

  Map<String, dynamic> get themeData => _themeData;
}
