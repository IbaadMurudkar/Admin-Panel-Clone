import 'dart:io';
import 'dart:typed_data';

import 'package:admin_panel/controllers/menu_controller.dart';
import 'package:admin_panel/screens/loading_manager.dart';
import 'package:admin_panel/widgets/buttons.dart';
import 'package:admin_panel/widgets/header.dart';
import 'package:admin_panel/widgets/responsive.dart';
import 'package:admin_panel/widgets/side_menu.dart';
import 'package:admin_panel/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../services/global_methods.dart';
import '../services/utils.dart';

class UploadProductForm extends StatefulWidget {
  const UploadProductForm({Key? key}) : super(key: key);

  @override
  State<UploadProductForm> createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  int groupValue = 1;
  bool isPiece = false;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  String categoryValue = 'Vegetables';
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    titleController.clear();
    priceController.clear();
    isPiece = false;
    groupValue = 1;
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  void initState() {
    titleController = TextEditingController();
    priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    priceController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void uploadForm() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      if (_pickedImage == null) {
        GlobalMethods.errorDialog(
            subtitle: 'Please pick up an image', context: context);
        return;
      }
      final _uuid = const Uuid().v4();
      try {
        setState(() {
          _isLoading = true;
        });
        fb.StorageReference storageRef =
            fb.storage().ref().child('productsImages').child(_uuid + 'jpg');
        final fb.UploadTaskSnapshot uploadTaskSnapshot =
            await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
        Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('products').doc(_uuid).set({
          'id': _uuid,
          'title': titleController.text,
          'price': priceController.text,
          'salePrice': 0.1,
          'imageUrl': imageUri.toString(),
          'productCategoryName': categoryValue,
          'isOnSale': false,
          'isPiece': isPiece,
          'createdAt': Timestamp.now(),
        });
        _clearForm();
        Fluttertoast.showToast(
          msg: "Product uploaded successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    isPiece = false;
    groupValue = 1;
    priceController.clear();
    titleController.clear();
    setState(() {
      _pickedImage = null;
      webImage = Uint8List(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    Color color = Utils(context).color;
    final theme = Utils(context).getTheme;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    var inputDecoration = InputDecoration(
        filled: true,
        fillColor: scaffoldColor,
        border: InputBorder.none,
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: color, width: 1)));
    return Scaffold(
      key: context.read<MenuController>().getAddProductScaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(child: SideMenu()),
            Expanded(
                flex: 5,
                child: SingleChildScrollView(
                    controller: ScrollController(),
                    child: Column(
                      children: [
                        Header(
                            showTexField: false,
                            title: 'Add Products Screen',
                            fct: () {
                              context
                                  .read<MenuController>()
                                  .controlAddProductsMenu();
                            }),
                        Container(
                          width: size.width > 650 ? 650 : size.width,
                          color: Theme.of(context).cardColor,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextWidget(
                                  text: 'Products Title*',
                                  color: color,
                                  textSize: 18,
                                  isTitle: true,
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  key: const ValueKey('Title'),
                                  controller: titleController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter a Title';
                                    }
                                    return null;
                                  },
                                  decoration: inputDecoration,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: FittedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                text: 'Price in \$*',
                                                color: color,
                                                textSize: 18,
                                                isTitle: true,
                                              ),
                                              const SizedBox(height: 10),
                                              SizedBox(
                                                width: 100,
                                                child: TextFormField(
                                                  key: const ValueKey('Price'),
                                                  controller: priceController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter Price';
                                                    }
                                                    return null;
                                                  },
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .allow(
                                                            RegExp(r'[0-9.]'))
                                                  ],
                                                  decoration: inputDecoration,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              TextWidget(
                                                text: 'Product Category*',
                                                color: color,
                                                textSize: 18,
                                                isTitle: true,
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                color: scaffoldColor,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: categoryDropDown(),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              TextWidget(
                                                text: 'Measure Unit*',
                                                color: color,
                                                textSize: 18,
                                                isTitle: true,
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  TextWidget(
                                                      text: 'Kg',
                                                      color: color,
                                                      textSize: 18),
                                                  Radio(
                                                      value: 1,
                                                      groupValue: groupValue,
                                                      activeColor: Colors.green,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          groupValue = 1;
                                                          isPiece = false;
                                                        });
                                                      }),
                                                  TextWidget(
                                                      text: 'Piece',
                                                      color: color,
                                                      textSize: 18),
                                                  Radio(
                                                      value: 2,
                                                      groupValue: groupValue,
                                                      activeColor: Colors.green,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          groupValue = 2;
                                                          isPiece = true;
                                                        });
                                                      })
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 4,
                                        child: Container(
                                            height: size.width > 650
                                                ? 350
                                                : size.width * 0.45,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: _pickedImage == null
                                                ? dottedBorder(color: color)
                                                : ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: kIsWeb
                                                        ? Image.memory(
                                                            webImage,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.file(
                                                            _pickedImage!,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ))),
                                    Expanded(
                                        flex: 1,
                                        child: FittedBox(
                                          child: Column(
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _pickedImage = null;
                                                      webImage = Uint8List(8);
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Clean',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  )),
                                              TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    'Upload Image',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  )),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ButtonsWidget(
                                          onPressed: clearForm,
                                          text: 'Clear Form',
                                          icon: IconlyBold.danger,
                                          backgroundColor: Colors.red),
                                      ButtonsWidget(
                                          onPressed: () {
                                            uploadForm();
                                          },
                                          text: 'Upload',
                                          icon: IconlyBold.upload,
                                          backgroundColor: Colors.blue),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        print('No image has been picked');
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        print('No image has been picked');
      }
    } else {
      print('Something went wrong');
    }
  }

  Widget dottedBorder({required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        color: color,
        borderType: BorderType.RRect,
        dashPattern: const [6.7],
        radius: const Radius.circular(12),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.image_outlined,
                size: 50,
                color: Colors.black,
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  _pickImage();
                },
                child: TextWidget(
                    text: 'Choose an Image', color: Colors.blue, textSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget categoryDropDown() {
    return DropdownButtonHideUnderline(
        child: DropdownButton<String>(
      value: categoryValue,
      onChanged: (value) {
        setState(() {
          categoryValue = value!;
        });
      },
      hint: const Text('Select '),
      items: const [
        DropdownMenuItem(
          value: 'Vegetables',
          child: Text('Vegetables'),
        ),
        DropdownMenuItem(
          value: 'Fruits',
          child: Text('Fruits'),
        ),
        DropdownMenuItem(
          value: 'Grains',
          child: Text('Grains'),
        ),
        DropdownMenuItem(
          value: 'Nuts',
          child: Text('Nuts'),
        ),
        DropdownMenuItem(
          value: 'Herbs',
          child: Text('Herbs'),
        ),
        DropdownMenuItem(
          value: 'Spices',
          child: Text('Spices'),
        ),
      ],
    ));
  }
}
