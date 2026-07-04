// lib/utils/service_catalog.dart
//
// ✅ BHK services चा single source of truth — bhk_list_screen आणि
// wishlist_screen दोन्ही इथूनच data घेतात, duplicate maintain करावं लागत नाही.

class ServiceCatalog {
  static const Map<String, List<Map<String, String>>> furnished = {
    '1 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Inside & Outside), Fans/AC, Floor Scrubbing & Mopping, Tables/Chairs/Lamp/Frames/TV set etc.'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Inside & Outside), Fans/AC, Floor Scrubbing & Mopping, Bed (Inside/Outside)'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior), Cabinets & Trolly Cleaning (Inside & Outside, Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Exhaust (WetWiping), Hard Stain Removal, Drill Brush Scrubbing, Sink Cleaning, Mirrors/Glass wiping'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '2 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Inside & Outside), Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets (Inside & Outside), Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 2 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior), Steam Cleaner'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Exhaust (WetWiping), Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 2 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '3 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping, Tables/Chairs/Lamp/Frames/TV set etc.'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 3 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing, Chimney/Stove (Exterior), Cabinets & Trolly (Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 3 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '4 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 4 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior), Cabinets & Trolly (Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 4 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '5 BHK': [
      {'title': 'Hall Cleaning',     'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Bedroom Cleaning',  'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing, Bed (Inside/Outside) — 5 Bedrooms'},
      {'title': 'Kitchen Cleaning',  'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior), Cabinets & Trolly (Steam Cleaner)'},
      {'title': 'Bathroom Cleaning', 'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 5 Bathrooms'},
      {'title': 'Balcony Cleaning',  'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
  };

  static const Map<String, List<Map<String, String>>> unfurnished = {
    '1 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Outside), Fans/AC, Floor Scrubbing & Mopping'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Exhaust (WetWiping), Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '2 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Cabinets Cleaning (Outside), Fans/AC, Floor Scrubbing & Mopping — 2 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing & Mopping, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 2 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '3 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping — 3 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans, Floor Scrubbing, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 3 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '4 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping — 4 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 4 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
    '5 BHK': [
      {'title': 'Hall & Bedroom Cleaning', 'desc': 'Dry Dusting, Vacuuming, Wet Wiping, Fans/AC, Floor Scrubbing & Mopping — 5 Bedrooms'},
      {'title': 'Kitchen Cleaning',        'desc': 'Dry Dusting, Vacuuming, Fans, Floor Scrubbing, Chimney/Stove (Exterior Cleaning)'},
      {'title': 'Bathroom Cleaning',       'desc': 'Commode Pot Cleaning, Shower, Taps, Hard Stain Removal, Sink Cleaning, Mirrors/Glass wiping — 5 Bathrooms'},
      {'title': 'Balcony Cleaning',        'desc': 'Dry Dusting, Vacuuming, Floor Scrubbing'},
    ],
  };

  static const List<String> _bhkOrder = ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5 BHK'];

  /// index (0..4) वरून थेट services मिळवण्यासाठी — bhk_list_screen मध्ये वापरतो
  static List<Map<String, String>> byIndex(int index, {required bool isFurnished}) {
    final bhk = _bhkOrder[index % _bhkOrder.length];
    final map = isFurnished ? furnished : unfurnished;
    return map[bhk] ?? map['1 BHK']!;
  }

  /// product/wishlist item च्या title वरून BHK आणि furnished/unfurnished
  /// ओळखून योग्य services list परत देतो. BHK-related नसेल तर null.
  static List<Map<String, String>>? fromTitle(String title) {
    final t = title.toLowerCase();

    String? bhk;
    for (final b in _bhkOrder) {
      if (t.contains(b.toLowerCase()) || t.contains(b.toLowerCase().replaceAll(' ', ''))) {
        bhk = b;
        break;
      }
    }
    if (bhk == null) return null;

    final isFurnished = !t.contains('unfurnished');
    final map = isFurnished ? furnished : unfurnished;
    return map[bhk];
  }
}