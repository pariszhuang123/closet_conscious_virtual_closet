
class TypeData {
  final String name;
  final String? imageUrl;

  const TypeData(this.name, [this.imageUrl]);
}

class TypeDataList {
  static const List<TypeData> seasons = [
    TypeData('Spring', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Spring.png'),
    TypeData('Summer', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Summer.png'),
    TypeData('Autumn', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Autumn.png'),
    TypeData('Winter', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/Winter.png'),
    TypeData('Multi', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Season/All_Temperature.png'),
  ];

  static const List<TypeData> clothingTypes = [
    TypeData('Top', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/t-shirt.png'),
    TypeData('Bottom', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-pant.png'),
    TypeData('One Piece', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Type/long-sleeves-dress.png'),
  ];

  static const List<TypeData> clothingLayers = [
    TypeData('Base', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Base_Layer.png'),
    TypeData('Mid', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Insulating_Layer.png'),
    TypeData('Outer', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Clothing%20Layer/Outer_Layer.png'),
  ];

  static const List<TypeData> colors = [
    TypeData('Red', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/1.Red.svg'),
    TypeData('Blue', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/3.Blue.svg'),
    TypeData('Green', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/2.Green.svg'),
    TypeData('Yellow', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/4.Yellow.svg'),
    TypeData('Brown', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/5.Brown.svg'),
    TypeData('Grey', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/6.Grey.svg'),
    TypeData('Rainbow', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Multi-Colour.png'),
    TypeData('Black', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/Black.svg'),
    TypeData('White', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour/White.svg'),
  ];

  static const List<TypeData> colorVariations = [
    TypeData('Light', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Light.svg'),
    TypeData('Medium', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Medium.svg'),
    TypeData('Dark', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Colour%20Variation/Dark.svg'),
  ];

  static const List<TypeData> accessoryTypes = [
    TypeData('Bag', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/5.shoulder-bag.png'),
    TypeData('Belt', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/6.belt.png'),
    TypeData('Eyewear', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/2.sunglasses.png'),
    TypeData('Gloves', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/8.gloves.png'),
    TypeData('Hat', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/1.hat.png'),
    TypeData('Jewellery', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/7.ring.png'),
    TypeData('Scarf', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/3.scarf.png'),
    TypeData('Tie', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Accessory%20Type/4.tie.png'),
  ];

  static const List<TypeData> itemGeneralTypes = [
    TypeData('Clothing', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/shirt.png'),
    TypeData('Shoes', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Shoe.png'),
    TypeData('Accessory', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Item%20General%20Type/Accessory.png'),
  ];

  static const List<TypeData> shoeTypes = [
    TypeData('Boots', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/4.boot.png'),
    TypeData('Casual', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/1.sandals.png'),
    TypeData('Athletic', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/2.running-shoe.png'),
    TypeData('Formal', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/3.high-heels.png'),
    TypeData('Niche', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Shoe%20Type/5.football.png'),
  ];
  static const List<TypeData> occasions = [
    TypeData('Active', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/hiking.png'),
    TypeData('Casual', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/casual.png'),
    TypeData('Workplace', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/working-with-laptop.png'),
    TypeData('Social', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/friends.png'),
    TypeData('Event', 'https://vrhytwexijijwhlicqfw.supabase.co/storage/v1/object/public/closet-conscious-assets/Closet/Upload/Occasion/flamenco-dancers-sexy-couple-silhouettes.png'),
  ];
}
