const int minGuessesBeforeGrowingSequence = 10000;
// \xbf-\xdf is a range for almost all special uppercase letter like Ä and so on
final RegExp startUpper = RegExp(r'^[A-Z\xbf-\xdf][^A-Z\xbf-\xdf]+$');
final RegExp endUpper = RegExp(r'^[^A-Z\xbf-\xdf]+[A-Z\xbf-\xdf]$');
// \xdf-\xff is a range for almost all special lowercase letter like ä and so on
final RegExp allUpper = RegExp(r'^[A-Z\xbf-\xdf]+$');
final RegExp allUpperInverted = RegExp(r'^[^a-z\xdf-\xff]+$');
final RegExp allLower = RegExp(r'^[a-z\xdf-\xff]+$');
final RegExp allLowerInverted = RegExp(r'^[^A-Z\xbf-\xdf]+$');
final RegExp oneLower = RegExp(r'[a-z\xdf-\xff]');
final RegExp oneUpper = RegExp(r'[A-Z\xbf-\xdf]');
final RegExp alphaInverted =
    RegExp(r'[^A-Za-z\xbf-\xdf]', caseSensitive: false);
final RegExp allDigit = RegExp(r'^\d+$');
