import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/login.dart';
import '../providers/departments.dart';
import '../providers/product.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String admin;
  final ImagePicker _picker = ImagePicker();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _quantityFocusNode = FocusNode();
  File _image;
  // final _imageUrlController = TextEditingController();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  String productName, catName, deptName;
  var _editedProduct = Product(
    adminName: '',
    name: '',
    description: '',
    price: 0,
    quantity: 1,
    isAvailable: true,
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
    'quantity': '',
    'price': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;
  var _isImageLoading = false;

  @override
  void initState() {
    // _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final args = ModalRoute.of(context).settings.arguments as List<String>;
      if (args.length == 3) {
        productName = args[0];
        catName = args[1];
        deptName = args[2];
      } else if (args.length == 2) {
        catName = args[0];
        deptName = args[1];
      }
      admin = Provider.of<SignIn>(context).username;
      if (productName != null) {
        setState(() {
          _isLoading = true;
        });
        _editedProduct = await Provider.of<Departments>(context, listen: false)
            .getProdById(productName);
        setState(() {
          _initValues = {
            'title': _editedProduct.name,
            'description': _editedProduct.description,
            'quantity': _editedProduct.quantity.toString(),
            'price': _editedProduct.price.toString(),
            'imageUrl': _editedProduct.imageUrl,
          };
          _isLoading = false;
        });
        // _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _quantityFocusNode.dispose();
    _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    // _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> getImage() async {
    var tempImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(tempImage.path);
    });
  }

  // void _updateImageUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     if ((!_imageUrlController.text.startsWith('http') &&
  //         !_imageUrlController.text.startsWith('https'))) {
  //       return;
  //     }
  //     setState(() {});
  //   }
  // }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (productName != null) {
      await Provider.of<Departments>(context, listen: false).updateProduct(
        _editedProduct,
        catName,
        deptName,
      );
    } else {
      try {
        await Provider.of<Departments>(context, listen: false).addProduct(
          _editedProduct,
          catName,
          deptName,
        );
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: productName == null ? Text('Add Product') : Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          adminName: admin,
                          name: value,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          quantity: _editedProduct.quantity,
                          isAvailable:
                              _editedProduct.quantity > 0 ? true : false,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_quantityFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (int.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          adminName: admin,
                          name: _editedProduct.name,
                          price: int.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          quantity: _editedProduct.quantity,
                          isAvailable:
                              _editedProduct.quantity > 0 ? true : false,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['quantity'],
                      decoration: InputDecoration(labelText: 'Quantity'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _quantityFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a quantity.';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (int.parse(value) < 0) {
                          return 'Please enter a number greater than equal to zero.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          adminName: admin,
                          name: _editedProduct.name,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          quantity: int.parse(value),
                          isAvailable:
                              _editedProduct.quantity > 0 ? true : false,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return null;
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          adminName: admin,
                          name: _editedProduct.name,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          quantity: _editedProduct.quantity,
                          isAvailable:
                              _editedProduct.quantity > 0 ? true : false,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height) *
                              0.2,
                          height: (MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height) *
                              0.2,
                          margin: EdgeInsets.only(
                            top: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.05,
                            right: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.03,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: (MediaQuery.of(context).size.height -
                                      AppBar().preferredSize.height) *
                                  0.001,
                              color: Colors.grey,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: _isImageLoading
                              ? Center(child: CircularProgressIndicator())
                              : _initValues['imageUrl'] == null || _initValues['imageUrl'] == '' 
                                  ? Text('Choose Image')
                                  : CachedNetworkImage(
                                      fit: BoxFit.contain,
                                      imageUrl: _initValues['imageUrl'],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await getImage();
                            setState(() {
                              _isImageLoading = true;
                            });
                            StorageReference ref = FirebaseStorage.instance
                                .ref()
                                .child(_image.path);
                            StorageUploadTask storageUploadTask =
                                ref.putFile(_image);
                            StorageTaskSnapshot taskSnapshot =
                                await storageUploadTask.onComplete;
                            String imageUrl =
                                await taskSnapshot.ref.getDownloadURL();
                            setState(() {
                              _initValues['imageUrl'] = imageUrl;
                              _isImageLoading = false;
                            });
                            _editedProduct = Product(
                              adminName: admin,
                              name: _editedProduct.name,
                              price: _editedProduct.price,
                              description: _editedProduct.imageUrl,
                              imageUrl: _initValues['imageUrl'],
                              quantity: _editedProduct.quantity,
                              isAvailable:
                                  _editedProduct.quantity > 0 ? true : false,
                            );
                          },
                          color: Colors.teal,
                          child: Text('Pick from gallery'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
