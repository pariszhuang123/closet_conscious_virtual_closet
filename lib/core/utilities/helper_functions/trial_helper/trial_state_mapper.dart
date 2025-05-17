import 'package:flutter/widgets.dart';
import '../../../data/type_data.dart';
import '../../../presentation/bloc/trial_bloc/trial_bloc.dart';

TypeData mapDeniedStateToTypeData(TrialState state, BuildContext context) {
  if (state is AccessFilterFeatureDenied) return TypeDataList.filter(context);
  if (state is AccessMultiClosetFeatureDenied) return TypeDataList.addCloset(context);
  if (state is AccessCustomizeFeatureDenied) return TypeDataList.arrange(context);
  if (state is AccessCalendarFeatureDenied) return TypeDataList.calendar(context);
  if (state is AccessOutfitCreationFeatureDenied) return TypeDataList.outfitsUpload(context);
  if (state is AccessUsageAnalyticsFeatureDenied) return TypeDataList.drawerInsights(context);
  throw Exception('Unhandled denied state: $state');
}
