import 'package:flutter/material.dart';
import 'product.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  Future<List<Product>> products;

  Future<List<Product>> fetchProducts() async {
    http.Response response = await http.get('https://jsonkeeper.com/b/3GKZ');
    List<Product> _products = [];
    if (response.statusCode == 200) {
      //ok
      var jsonArray = jsonDecode(response.body) as List;
      _products = jsonArray.map((e) => Product.fromJson(e)).toList();
    }
    else {
      Toast.show(response.statusCode.toString(), context);
    }
    return _products;
  }

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            'Product Information',
            style: TextStyle(
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
          TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'Product Name'),
          ),
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Quantity'),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Price'),
          ),
          FutureBuilder(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Product> prds = snapshot.data;
                return RaisedButton.icon(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        quantityController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      Toast.show('please fill all fields', context);
                      return;
                    }
                    int q;
                    try {
                      q = int.parse(quantityController.text);
                    } catch (e) {
                      Toast.show('enter a valid integer', context);
                      return;
                    }

                    setState(() {
                      Product p = Product(
                          productName: nameController.text,
                          quantity: q,
                          price: double.parse(priceController.text));
                      prds.add(p);
                      nameController.clear();
                      quantityController.clear();
                      priceController.clear();
                    });
                  },
                  icon: Icon(Icons.add),
                  label: Text('add product'),
                );
              } else {
                return Text('no data');
              }
            },
          ),
          Text(
            'Your Products',
            style: TextStyle(
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                fontSize: 25.0),
          ),
          SizedBox(
            height: 8.0,
          ),
          FutureBuilder(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Product> _products = snapshot.data;
                if(_products.isNotEmpty)
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.blue,
                            leading: Text(
                              _products[index].productName,
                              style: TextStyle(
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0),
                            ),
                            title: Text('Price: ${_products[index].price}'),
                            subtitle: Text(
                                'Quantity: ${_products[index].quantity}'),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  _products.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                else
                  return Text('no products');
              }
                else {
                return SpinKitRipple(
                  color: Colors.black,
                  size: 50.0,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
