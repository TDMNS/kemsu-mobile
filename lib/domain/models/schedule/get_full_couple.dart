String getOddCoupleStr(coupleAll, coupleOdd) {
  List<String> parts = [];
  if (coupleAll.isNotEmpty) parts.add(coupleAll);
  if (coupleOdd.isNotEmpty) parts.add(coupleOdd);
  return parts.join(',\n');
}

String getEvenCoupleStr(coupleAll, coupleEven) {
  List<String> parts = [];
  if (coupleAll.isNotEmpty) parts.add(coupleAll);
  if (coupleEven.isNotEmpty) parts.add(coupleEven);
  return parts.join(',\n');
}
