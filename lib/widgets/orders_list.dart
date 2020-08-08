import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:printing/printing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;

import '../providers/orders.dart';
import '../providers/login.dart';

class OrdersList extends StatelessWidget {
  final String orderType;

  OrdersList(this.orderType);

  void _printReceipt(OrderItem ord) async {
    int phoneNumber;

    phoneNumber = await Firestore.instance
        .collection('Contact')
        .document('Phone No')
        .get()
        .then((snap) => snap['phoneNo']);
    Printing.layoutPdf(onLayout: (pageFormat) {
      final doc = pw.Document();

      doc.addPage(pw.MultiPage(
        build: (context) => [
          pw.Column(
            children: [
              pw.Text('Rahul Enterprises',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, fontSize: 30)),
              pw.SizedBox(height: 35, width: double.infinity),
              pw.Text('$phoneNumber',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 25)),
              pw.SizedBox(height: 15, width: double.infinity),
              pw.Text('Home Delivery',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 25)),
              pw.SizedBox(height: 15, width: double.infinity),
              pw.Text('#${ord.id}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 40, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 15, width: double.infinity),
              pw.Text('${ord.userName}',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: 25)),
              pw.SizedBox(height: 15, width: double.infinity),
              pw.Text('${ord.phone}',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: 25)),
              pw.SizedBox(height: 15, width: double.infinity),
              pw.Text('${ord.address}',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: 25),
                  maxLines: 2),
              pw.SizedBox(height: 15, width: double.infinity),
              pw.Row(
                children: [
                  pw.Text('Payment Method: ',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 25)),
                  pw.Text('CASH', style: pw.TextStyle(fontSize: 25)),
                ],
              ),
              pw.SizedBox(height: 35, width: double.infinity),
              pw.Table.fromTextArray(
                border: null,
                headerAlignment: pw.Alignment.centerLeft,
                cellAlignment: pw.Alignment.centerLeft,
                cellHeight: 30,
                headerHeight: 30,
                headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 25,
                ),
                cellStyle: pw.TextStyle(
                  fontSize: 25,
                ),
                headers: ['Item', 'Qty', 'Price', 'Total'],
                data: [
                  [
                    '${ord.products[0].prodName}',
                    '${ord.products[0].quantity}',
                    '${ord.products[0].price}',
                    '${ord.amount}'
                  ]
                ],
              ),
              pw.Text('Thank You',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ));
      return doc.save();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<SignIn>(context);
    final ord = Provider.of<Orders>(context);
    List<OrderItem> reqOrders = [];
    switch (orderType) {
      case 'pending':
        {
          reqOrders = ord.pendingOrders;
        }
        break;

      case 'placed':
        {
          reqOrders = ord.placedOrders;
        }
        break;

      case 'dispatched':
        {
          reqOrders = ord.dispatchedOrders;
        }
        break;

      case 'completed':
        {
          reqOrders = ord.completedOrders;
        }
        break;

      case 'cancelled':
        {
          reqOrders = ord.cancelledOrders;
        }
        break;
    }

    if (reqOrders.length == 0) {
      return Center(
        child: Text('No $orderType orders found'),
      );
    }
    return Container(
      child: GridView.count(
        crossAxisCount: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.4,
        children: reqOrders
            .map((item) => Card(
                  child: Container(
                    height: (MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            50.0) *
                        0.40,
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText(
                          '${item.title}',
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.030,
                          ),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: ((MediaQuery.of(context).size.height -
                                      AppBar().preferredSize.height -
                                      50.0) *
                                  0.37) *
                              0.03,
                        ),
                        Text(
                          '${item.userName} (${item.email})',
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.024,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy hh:mm').format(item.dateTime),
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.02,
                          ),
                        ),
                        AutoSizeText(
                          'ID: ${item.id}',
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.02,
                          ),
                          maxLines: 1,
                        ),
                        Text(
                          'Quantity: ${item.products[0].quantity}',
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.02,
                          ),
                        ),
                        Text(
                          'Total: ₹${item.amount}',
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.02,
                          ),
                        ),
                        SizedBox(
                          height: ((MediaQuery.of(context).size.height -
                                      AppBar().preferredSize.height -
                                      50.0) *
                                  0.37) *
                              0.03,
                        ),
                        AutoSizeText(
                          '${item.address}',
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.024,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          'Contact: ${item.phone}',
                          style: TextStyle(
                            fontSize: (MediaQuery.of(context).size.height -
                                    AppBar().preferredSize.height) *
                                0.024,
                          ),
                          maxLines: 1,
                        ),
                        if (orderType == 'pending' || orderType == 'placed')
                          SizedBox(
                            height: ((MediaQuery.of(context).size.height -
                                        AppBar().preferredSize.height -
                                        50.0) *
                                    0.37) *
                                0.03,
                          ),
                        if (orderType == 'pending')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  onPressed: () {
                                    Provider.of<Orders>(context)
                                        .cancelOrder(auth.username, item);
                                  },
                                  color: Colors.red,
                                  child: Text(
                                    'Reject',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              AppBar().preferredSize.height) *
                                          0.025,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FlatButton(
                                  onPressed: () async {
                                    await Provider.of<Orders>(context)
                                        .updateStatus(
                                            auth.username, item, 'placed');
                                  },
                                  color: Colors.green,
                                  child: Text(
                                    'Accept',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              AppBar().preferredSize.height) *
                                          0.025,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (orderType == 'placed')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  onPressed: () {
                                    Provider.of<Orders>(context)
                                        .cancelOrder(auth.username, item);
                                  },
                                  color: Colors.red,
                                  child: Text(
                                    'Cancel',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              AppBar().preferredSize.height) *
                                          0.025,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: FlatButton(
                                  onPressed: () async {
                                    await Provider.of<Orders>(context)
                                        .updateStatus(
                                            auth.username, item, 'dispatched');
                                  },
                                  color: Colors.green,
                                  child: Text(
                                    'Dispatch',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              AppBar().preferredSize.height) *
                                          0.025,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (orderType == 'dispatched')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  onPressed: () {
                                    _printReceipt(item);
                                  },
                                  color: Colors.green,
                                  child: Text(
                                    'Print Receipt',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: (MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              AppBar().preferredSize.height) *
                                          0.025,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
