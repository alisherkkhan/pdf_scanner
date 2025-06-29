import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOrder { newestFirst, oldestFirst }

final sortOrderProvider = StateProvider<SortOrder>((ref) {
  return SortOrder.newestFirst;
});
