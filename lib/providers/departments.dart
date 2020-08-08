import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './department.dart';
import './category.dart';
import './product.dart';

class Departments with ChangeNotifier {
  List<Department> _departments = [];
  List<Category> _categories = [];
  List<Product> _products = [];

  Future<void> getDepts(String admin) async {
    List<Department> _departmentList = [];
    List _departList = await Firestore.instance
        .collection('Departments')
        .getDocuments()
        .then((snap) => snap.documents.where((element) => element['admin'] == admin).toList());

    for (int i = 0; i < _departList.length; i++) {
      _departmentList.add(Department(
        name: _departList[i]['name'],
        adminName: _departList[i]['admin'],
      ));
    }

    _departments = _departmentList;
    notifyListeners();
  }

  Future<void> getCats(String admin, String deptName) async {
    List<Category> _categoriesList = [];
    List _catList = await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection('Categories')
        .getDocuments()
        .then((snap) => snap.documents.where((element) => element['admin'] == admin).toList());

    for (int i = 0; i < _catList.length; i++) {
      _categoriesList.add(Category(
        name: _catList[i]['name'],
        adminName: _catList[i]['admin'],
      ));
    }

    _categories = _categoriesList;
    notifyListeners();
  }

  Future<void> getProds(String admin, String deptName, String catName) async {
    List<Product> _productsList = [];
    List _prodList = await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection("Categories")
        .document(catName)
        .collection('Products')
        .getDocuments()
        .then((snap) => snap.documents.where((element) => element['admin'] == admin).toList());

    for (int i = 0; i < _prodList.length; i++) {
      _productsList.add(Product(
          name: _prodList[i]['name'],
          adminName: _prodList[i]['admin'],
          price: _prodList[i]['price'],
          quantity: _prodList[i]['quantity'],
          isAvailable: _prodList[i]['isAvailable'],
          description: _prodList[i]['description'],
          imageUrl: _prodList[i]['imageUrl']));
    }

    _products = _productsList;
    notifyListeners();
  }

  Future<Product> getProdById(String name) async {
    Product prod;
    List _departList = await Firestore.instance
        .collection('Departments')
        .getDocuments()
        .then((snap) => snap.documents);
    for (int i = 0; i < _departList.length; i++) {
      List _catList = await Firestore.instance
          .collection('Departments')
          .document(_departList[i].documentID.toString())
          .collection('Categories')
          .getDocuments()
          .then((snap) => snap.documents);
      for (int j = 0; j < _catList.length; j++) {
        List _prodList = await Firestore.instance
            .collection('Departments')
            .document(_departList[i].documentID.toString())
            .collection('Categories')
            .document(_catList[j].documentID.toString())
            .collection('Products')
            .getDocuments()
            .then((snap) => snap.documents);
        for (int k = 0; k < _prodList.length; k++) {
          if (_prodList[k]['name'] == name) {
            prod = Product(
                adminName: _prodList[k]['admin'],
                name: _prodList[k]['name'],
                price: _prodList[k]['price'],
                quantity: _prodList[k]['quantity'],
                isAvailable: _prodList[k]['isAvailable'],
                description: _prodList[k]['description'],
                imageUrl: _prodList[k]['imageUrl']);
          }
        }
      }
    }
    notifyListeners();
    return prod;
  }

  Future<void> addProduct(Product prod, String catName, String deptName) async {
    await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection('Categories')
        .document(catName)
        .collection('Products')
        .document(prod.name)
        .setData({
      'admin': prod.adminName,
      'name': prod.name,
      'quantity': prod.quantity,
      'description': prod.description,
      'price': prod.price,
      'isAvailable': prod.isAvailable,
      'imageUrl': prod.imageUrl
    });
    _products.add(prod);
    notifyListeners();
  }

  Future<void> updateProduct(
      Product prod, String catName, String deptName) async {
    await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection('Categories')
        .document(catName)
        .collection('Products')
        .document(prod.name)
        .updateData({
      'admin': prod.adminName,
      'name': prod.name,
      'quantity': prod.quantity,
      'description': prod.description,
      'price': prod.price,
      'isAvailable': prod.isAvailable,
      'imageUrl': prod.imageUrl
    });
    _products[_products
        .lastIndexWhere((product) => product.name == prod.name)] = prod;
    notifyListeners();

    List userList = await Firestore.instance
        .collection('Users')
        .getDocuments()
        .then((value) => value.documents);
    if (userList == null) {
      return;
    }
    for (int i = 0; i < userList.length; i++) {
      List cart = await Firestore.instance
          .collection('Users')
          .document(userList[i].documentID.toString())
          .collection('Cart')
          .getDocuments()
          .then((value) => value.documents);
      if (cart == null) {
        continue;
      }
      for (int j = 0; j < cart.length; j++) {
        if (cart[j]['prodName'] == prod.name) {
          await Firestore.instance
              .collection('Users')
              .document(userList[i].documentID.toString())
              .collection('Cart')
              .document(prod.name)
              .updateData({
            'prodName': prod.name,
          });
        }
      }
    }
  }

  Future<void> deleteProduct(
      String prodName, String catName, String deptName) async {
    _products.removeWhere((prod) => prod.name == prodName);
    notifyListeners();
    await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection('Categories')
        .document(catName)
        .collection('Products')
        .document(prodName)
        .delete();
    notifyListeners();

    List userList = await Firestore.instance
        .collection('Users')
        .getDocuments()
        .then((value) => value.documents);
    if (userList == null) {
      return;
    }
    for (int i = 0; i < userList.length; i++) {
      List cart = await Firestore.instance
          .collection('Users')
          .document(userList[i].documentID.toString())
          .collection('Cart')
          .getDocuments()
          .then((value) => value.documents);
      if (cart == null) {
        continue;
      }
      for (int j = 0; j < cart.length; j++) {
        if (cart[i]['prodName'] == prodName) {
          await Firestore.instance
              .collection('Users')
              .document(userList[i].documentID.toString())
              .collection('Cart')
              .document(prodName)
              .delete();
        }
      }
    }
  }

  Future<void> addCategory(String deptName, Category cat) async {
    await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection('Categories')
        .document(cat.name)
        .setData({
      'name': cat.name,
      'admin': cat.adminName,
    });
    _categories.add(cat);
    notifyListeners();
  }

  Future<void> updateCategory(String deptName, Category cat) async {
    await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection('Categories')
        .document(cat.name)
        .updateData({
      'name': cat.name,
      'admin': cat.adminName,
    });
    _categories[_categories.lastIndexWhere((categ) => categ.name == cat.name)] =
        cat;
    notifyListeners();
  }

  Future<void> deleteCategory(String deptName, String catName) async {
    _categories.removeWhere((cat) => cat.name == catName);
    notifyListeners();
    await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .collection('Categories')
        .document(catName)
        .delete();
    notifyListeners();
  }

  Future<void> addDepartment(Department dept) async {
    await Firestore.instance
        .collection('Departments')
        .document(dept.name)
        .setData({
      'name': dept.name,
      'admin': dept.adminName,
    });
    _departments.add(dept);
    notifyListeners();
  }

  Future<void> updateDepartment(Department dept) async {
    await Firestore.instance
        .collection('Departments')
        .document(dept.name)
        .updateData({
      'name': dept.name,
      'admin': dept.adminName,
    });
    _departments[_departments
        .lastIndexWhere((department) => department.name == dept.name)] = dept;
    notifyListeners();
  }

  Future<void> deleteDepartment(String deptName) async {
    _departments.removeWhere((dept) => dept.name == deptName);
    notifyListeners();
    await Firestore.instance
        .collection('Departments')
        .document(deptName)
        .delete();
    notifyListeners();
  }

  List<Department> get departments {
    return [..._departments];
  }

  List<Category> get categories {
    return [..._categories];
  }

  List<Product> get products {
    return [..._products];
  }
}
