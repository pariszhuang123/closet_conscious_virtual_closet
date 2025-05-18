part of 'premium_feature_access_bloc.dart';

abstract class PremiumFeatureAccessEvent extends Equatable {
  const PremiumFeatureAccessEvent();
}

class CheckUploadItemCreationAccessEvent extends PremiumFeatureAccessEvent {

  const CheckUploadItemCreationAccessEvent();

  @override
  List<Object?> get props => [];
}

class CheckEditItemCreationAccessEvent extends PremiumFeatureAccessEvent {

  const CheckEditItemCreationAccessEvent();

  @override
  List<Object?> get props => [];
}

class CheckSelfieCreationAccessEvent extends PremiumFeatureAccessEvent {

  const CheckSelfieCreationAccessEvent();

  @override
  List<Object?> get props => [];
}

class CheckEditClosetCreationAccessEvent extends PremiumFeatureAccessEvent {

  const CheckEditClosetCreationAccessEvent();

  @override
  List<Object?> get props => [];
}

class CheckOutfitCreationAccessEvent extends PremiumFeatureAccessEvent {
  const CheckOutfitCreationAccessEvent();

  @override
  List<Object?> get props => [];
}


class CheckCustomizeAccessEvent extends PremiumFeatureAccessEvent {
  const CheckCustomizeAccessEvent();

  @override
  List<Object?> get props => [];
}
