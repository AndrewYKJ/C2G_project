import 'package:flutter/material.dart';
import 'package:jpan_flutter/const/app_colors.dart';

enum IncidentType { general, flood, sos }

enum GeneralSubCat { street, school, hospital, river }

enum SOSSubCat { dangerous, major }

enum Street { potholes, brokentraffic }

enum School { facilities }

enum Hospital { injuries }

enum River { riverpollution, chemicaldumping }

enum Dangerous { electrocution, housefire }

enum MajorEvent { flood, accident, earthquake, landslide }

Map<IncidentType, String> incidentTypeName = {
  IncidentType.general: 'General Incident',
  IncidentType.flood: 'Flood Warning Incident',
  IncidentType.sos: 'SOS Incident',
};

Map<IncidentType, Type?> incidentType = {
  IncidentType.general: GeneralSubCat,
  IncidentType.flood: null,
  IncidentType.sos: SOSSubCat
};
Map<GeneralSubCat, String> generalCategoryName = {
  GeneralSubCat.street: 'Street',
  GeneralSubCat.school: 'School',
  GeneralSubCat.hospital: 'Hospital',
  GeneralSubCat.river: 'River'
};

Map<GeneralSubCat, Map> generalSubCategory = {
  GeneralSubCat.street: streetCategoryName,
  GeneralSubCat.school: schoolCategoryName,
  GeneralSubCat.hospital: hospitalCategoryName,
  GeneralSubCat.river: riverCategoryName
};

Map<Street, String> streetCategoryName = {
  Street.potholes: 'Potholes',
  Street.brokentraffic: 'Broken Traffic Light'
};

Map<School, String> schoolCategoryName = {
  School.facilities: 'Facilities',
};

Map<River, String> riverCategoryName = {
  River.riverpollution: 'River Pollutions',
  River.chemicaldumping: 'Chemical pollution'
};

Map<Hospital, String> hospitalCategoryName = {
  Hospital.injuries: 'Injuries',
};

Map<SOSSubCat, Map> sosSubCategory = {
  SOSSubCat.dangerous: dangerousName,
  SOSSubCat.major: majorEventName,
};

Map<SOSSubCat, String> sosCategoryName = {
  SOSSubCat.dangerous: 'Dangerous Situation',
  SOSSubCat.major: 'Major Event',
};

Map<MajorEvent, String> majorEventName = {
  MajorEvent.flood: 'Flood',
  MajorEvent.accident: 'Car Accident',
  MajorEvent.earthquake: 'Earthquake',
  MajorEvent.landslide: 'Landslide'
};

Map<Dangerous, String> dangerousName = {
  Dangerous.electrocution: 'Electrocution',
  Dangerous.housefire: 'House Fire',
};
Map<Enum, Color?> generalSubColor = {
  GeneralSubCat.street: AppColors.bluetagBackground(),
  GeneralSubCat.school: AppColors.pupletagBackground(),
  GeneralSubCat.hospital: AppColors.greentagBackground(),
  GeneralSubCat.river: AppColors.tealtagBackground()
};

Map<SOSSubCat, Color?> sosSubColor = {
  SOSSubCat.dangerous: AppColors.orangetagBackground(),
  SOSSubCat.major: AppColors.redtagBackground()
};

Map<dynamic, String> imagesIcon = {
  IncidentType.general: 'general incident_icon.png',
  IncidentType.flood: 'flood warning incident_icon.png',
  IncidentType.sos: 'sos incident_icon.png',
  'Street': 'street_icon.png',
  'School': 'school_icon.png',
  'Hospital': 'hospital_icon.png',
  "River": 'river_icon.png',
  "Broken Traffic Light": 'broken traffic light_icon.png',
  "Potholes": 'potholes_icon.png',
  "Facilities": "facilities_icon.png",
  "Injuries": 'injuries_icon.png',
  'River Pollutions': 'river pollution_icon.png',
  'Chemical pollution': 'chemical dumping_icon.png',
  'Dangerous Situation': 'dangerous situation_icon.png',
  'Major Event': 'flood_icon.png',
  "Flood": 'flood_icon.png',
  'Car Accident': 'car accident_icon.png',
  'Earthquake': 'earthquake_icon.png',
  'Landslide': "landslide_icon.png",
  "Electrocution": "Mask Group 305.png",
  "House Fire": 'house fire_icon.png'
};
