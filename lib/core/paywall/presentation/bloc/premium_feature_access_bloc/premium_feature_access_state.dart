part of 'premium_feature_access_bloc.dart';

abstract class PremiumFeatureAccessState extends Equatable {
  const PremiumFeatureAccessState();
}

class InitialNavigateCoreState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class ItemAccessGrantedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class BronzeUploadItemDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class SilverUploadItemDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class GoldUploadItemDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class BronzeEditItemDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class SilverEditItemDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class GoldEditItemDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class BronzeSelfieDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class SilverSelfieDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class GoldSelfieDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class ClosetAccessGrantedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class BronzeEditClosetDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class SilverEditClosetDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class GoldEditClosetDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class ItemAccessErrorState extends PremiumFeatureAccessState {
  final String errorMessage;

  const ItemAccessErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class ClosetAccessErrorState extends PremiumFeatureAccessState {
  final String errorMessage;

  const ClosetAccessErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class OutfitAccessGrantedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class OutfitAccessDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class OutfitAccessErrorState extends PremiumFeatureAccessState {
  final String errorMessage;
  const OutfitAccessErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class CustomizeAccessGrantedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class CustomizeAccessDeniedState extends PremiumFeatureAccessState {
  @override
  List<Object?> get props => [];
}

class CustomizeAccessErrorState extends PremiumFeatureAccessState {
  final String errorMessage;
  const CustomizeAccessErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
