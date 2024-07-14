import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/data/type_data.dart';
import '../../../core/utilities/routes.dart';
import '../../upload_item/widgets/image_display_widget.dart';
import '../../../generated/l10n.dart';
import '../../../core/widgets/icon_row_builder.dart';
import '../presentation/bloc/edit_item_bloc.dart';
import '../../declutter_items/presentation/widgets/declutter_options_bottom_sheet.dart';

class EditItemPage extends StatefulWidget {
  final ThemeData myClosetTheme;
  final String itemId;
  final String initialName;
  final double initialAmountSpent;
  final String? initialImageUrl;
  final String? initialItemType;
  final String? initialSpecificType;
  final String? initialClothingLayer;
  final String? initialOccasion;
  final String? initialSeason;
  final String? initialColour;
  final String? initialColourVariation;

  const EditItemPage({
    super.key,
    required this.myClosetTheme,
    required this.itemId,
    required this.initialName,
    required this.initialAmountSpent,
    this.initialImageUrl,
    this.initialItemType,
    this.initialSpecificType,
    this.initialClothingLayer,
    this.initialOccasion,
    this.initialSeason,
    this.initialColour,
    this.initialColourVariation,
  });

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late final TextEditingController _itemNameController;
  late final TextEditingController _amountSpentController;
  File? _imageFile;
  String? _imageUrl;
  String? selectedItemType;
  String? selectedSpecificType;
  String? selectedClothingLayer;
  String? _amountSpentError;
  String? selectedOccasion;
  String? selectedSeason;
  String? selectedColour;
  String? selectedColourVariation;
  bool _isChanged = false; // Updated to manage state change tracking

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.initialName);
    _amountSpentController = TextEditingController(text: widget.initialAmountSpent.toString());
    _imageUrl = widget.initialImageUrl;
    selectedItemType = widget.initialItemType;
    selectedSpecificType = widget.initialSpecificType;
    selectedClothingLayer = widget.initialClothingLayer;
    selectedOccasion = widget.initialOccasion;
    selectedSeason = widget.initialSeason;
    selectedColour = widget.initialColour;
    selectedColourVariation = widget.initialColourVariation;
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
        _isChanged = true; // Update the change tracking flag
      });
      if (mounted) {
        context.read<EditItemBloc>().add(UpdateImageEvent(file));
      }
    }
  }

  void _handleUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<EditItemBloc>().add(const SubmitFormEvent()); // Dispatch SubmitFormEvent
    }
  }

  void _openDeclutterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => DeclutterBottomSheet(
        currentItemId: widget.itemId,
        isFromMyCloset: true, // Set this based on your requirements
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditItemBloc(
        itemNameController: _itemNameController,
        amountSpentController: _amountSpentController,
        itemId: widget.itemId,
        initialName: widget.initialName,
        initialAmountSpent: widget.initialAmountSpent,
        initialImageUrl: widget.initialImageUrl,
        initialItemType: widget.initialItemType,
        initialSpecificType: widget.initialSpecificType,
        initialClothingLayer: widget.initialClothingLayer,
        initialOccasion: widget.initialOccasion,
        initialSeason: widget.initialSeason,
        initialColour: widget.initialColour,
        initialColourVariation: widget.initialColourVariation,
      )..add(FetchItemDetailsEvent(widget.itemId)),
      child: Builder(
        builder: (context) {
          return BlocConsumer<EditItemBloc, EditItemState>(
            listener: (context, state) {
              if (state is EditItemUpdateSuccess) {
                Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
              } else if (state is EditItemUpdateFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is EditItemLoaded) {
                // Update the controller values when the state is loaded
                _itemNameController.text = state.itemName;
                _amountSpentController.text = state.amountSpent.toString();
                setState(() {
                  _imageUrl = state.imageUrl;
                  selectedItemType = state.selectedItemType;
                  selectedSpecificType = state.selectedSpecificType;
                  selectedClothingLayer = state.selectedClothingLayer;
                  selectedOccasion = state.selectedOccasion;
                  selectedSeason = state.selectedSeason;
                  selectedColour = state.selectedColour;
                  selectedColourVariation = state.selectedColourVariation;
                });
              }
            },
            builder: (context, state) {
              if (state is EditItemLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Theme(
                data: widget.myClosetTheme,
                child: Scaffold(
                  backgroundColor: widget.myClosetTheme.colorScheme.surface,
                  appBar: AppBar(
                    title: Text(S.of(context).editPageTitle, style: widget.myClosetTheme.textTheme.titleMedium),
                    backgroundColor: widget.myClosetTheme.colorScheme.secondary,
                    leading: _isChanged
                        ? null
                        : IconButton(
                      icon: Icon(Icons.arrow_back, color: widget.myClosetTheme.colorScheme.onPrimary),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        // Top Section: Image Display
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: ImageDisplayWidget(
                                  imageUrl: _imageUrl,
                                  file: _imageFile,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Metadata Section
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _itemNameController,
                                      decoration: InputDecoration(
                                        labelText: S.of(context).item_name,
                                        labelStyle: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return S.of(context).pleaseEnterItemName;
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _isChanged = true; // Update the change tracking flag
                                        });
                                        context.read<EditItemBloc>().add(FieldChangedEvent());
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _amountSpentController,
                                      decoration: InputDecoration(
                                        labelText: S.of(context).amountSpentLabel,
                                        hintText: S.of(context).enterAmountSpentHint,
                                        errorText: _amountSpentError,
                                        labelStyle: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChanged = true; // Update the change tracking flag
                                        });
                                        context.read<EditItemBloc>().add(FieldChangedEvent());
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      S.of(context).selectItemType,
                                      style: widget.myClosetTheme.textTheme.bodyMedium,
                                    ),
                                    ...buildIconRows(
                                      TypeDataList.itemGeneralTypes(context),
                                      selectedItemType,
                                          (dataKey) {
                                        setState(() {
                                          _isChanged = true; // Update the change tracking flag
                                        });
                                        context.read<EditItemBloc>().add(ItemTypeChangedEvent(dataKey));
                                      },
                                      context,
                                      true, // Pass the isFromMyCloset parameter
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      S.of(context).selectOccasion,
                                      style: widget.myClosetTheme.textTheme.bodyMedium,
                                    ),
                                    ...buildIconRows(
                                      TypeDataList.occasions(context),
                                      selectedOccasion,
                                          (dataKey) {
                                        setState(() {
                                          _isChanged = true; // Update the change tracking flag
                                        });
                                        context.read<EditItemBloc>().add(OccasionChangedEvent(dataKey));
                                      },
                                      context,
                                      true, // Pass the isFromMyCloset parameter
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      S.of(context).selectSeason,
                                      style: widget.myClosetTheme.textTheme.bodyMedium,
                                    ),
                                    ...buildIconRows(
                                      TypeDataList.seasons(context),
                                      selectedSeason,
                                          (dataKey) {
                                        setState(() {
                                          _isChanged = true; // Update the change tracking flag
                                        });
                                        context.read<EditItemBloc>().add(SeasonChangedEvent(dataKey));
                                      },
                                      context,
                                      true, // Pass the isFromMyCloset parameter
                                    ),
                                    const SizedBox(height: 12),
                                    if (selectedItemType == 'Shoes') ...[
                                      Text(
                                        S.of(context).selectShoeType,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      ...buildIconRows(
                                        TypeDataList.shoeTypes(context),
                                        selectedSpecificType,
                                            (dataKey) {
                                          setState(() {
                                            _isChanged = true; // Update the change tracking flag
                                          });
                                          context.read<EditItemBloc>().add(SpecificTypeChangedEvent(dataKey));
                                        },
                                        context,
                                        true, // Pass the isFromMyCloset parameter
                                      ),
                                    ],
                                    if (selectedItemType == 'Accessory') ...[
                                      Text(
                                        S.of(context).selectAccessoryType,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      ...buildIconRows(
                                        TypeDataList.accessoryTypes(context),
                                        selectedSpecificType,
                                            (dataKey) {
                                          setState(() {
                                            _isChanged = true; // Update the change tracking flag
                                          });
                                          context.read<EditItemBloc>().add(SpecificTypeChangedEvent(dataKey));
                                        },
                                        context,
                                        true, // Pass the isFromMyCloset parameter
                                      ),
                                    ],
                                    if (selectedItemType == 'Clothing') ...[
                                      Text(
                                        S.of(context).selectClothingType,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      ...buildIconRows(
                                        TypeDataList.clothingTypes(context),
                                        selectedSpecificType,
                                            (dataKey) {
                                          setState(() {
                                            _isChanged = true; // Update the change tracking flag
                                          });
                                          context.read<EditItemBloc>().add(SpecificTypeChangedEvent(dataKey));
                                        },
                                        context,
                                        true, // Pass the isFromMyCloset parameter
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        S.of(context).selectClothingLayer,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      ...buildIconRows(
                                        TypeDataList.clothingLayers(context),
                                        selectedClothingLayer,
                                            (dataKey) {
                                          setState(() {
                                            _isChanged = true; // Update the change tracking flag
                                          });
                                          context.read<EditItemBloc>().add(ClothingLayerChangedEvent(dataKey));
                                        },
                                        context,
                                        true, // Pass the isFromMyCloset parameter
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    Text(
                                      S.of(context).selectColour,
                                      style: widget.myClosetTheme.textTheme.bodyMedium,
                                    ),
                                    ...buildIconRows(
                                      TypeDataList.colors(context),
                                      selectedColour,
                                          (dataKey) {
                                        setState(() {
                                          _isChanged = true; // Update the change tracking flag
                                        });
                                        context.read<EditItemBloc>().add(ColourChangedEvent(dataKey));
                                      },
                                      context,
                                      true, // Pass the isFromMyCloset parameter
                                    ),
                                    if (selectedColour != 'Black' &&
                                        selectedColour != 'White' &&
                                        selectedColour != null) ...[
                                      const SizedBox(height: 12),
                                      Text(
                                        S.of(context).selectColourVariation,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      ...buildIconRows(
                                        TypeDataList.colorVariations(context),
                                        selectedColourVariation,
                                            (dataKey) {
                                          setState(() {
                                            _isChanged = true; // Update the change tracking flag
                                          });
                                          context.read<EditItemBloc>().add(ColourVariationChangedEvent(dataKey));
                                        },
                                        context,
                                        true, // Pass the isFromMyCloset parameter
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Bottom Section: Button
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 70.0, left: 16.0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: _isChanged ? _handleUpdate : _openDeclutterSheet,
                            child: Text(
                              _isChanged ? S.of(context).update : S.of(context).declutter,
                              style: widget.myClosetTheme.textTheme.labelLarge,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
