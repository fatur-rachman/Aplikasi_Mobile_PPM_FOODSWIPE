import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import 'package:pesan_menu_application/models/menu_model.dart';
import 'package:http/http.dart' as myHttp;
import 'package:pesan_menu_application/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the correct launch and canLaunch functions
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider())
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.montserratTextTheme(),
          scaffoldBackgroundColor: Colors.grey[100],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController namaController = TextEditingController();
  TextEditingController nomorMejaController = TextEditingController();

  final String urlMenu = "https://script.google.com/macros/s/AKfycby65jQ-MhcREveqvABmwLhPITupIcMhE63BzmVM_wBYFZYIIqeiXAbJijr8BSoijCUU/exec";

  Future<List<MenuModel>> getAllData() async {
    List<MenuModel> listMenu = [];
    var response = await myHttp.get(Uri.parse(urlMenu));
    List data = json.decode(response.body);

    data.forEach((element) {
      listMenu.add(MenuModel.fromJson(element));
    });

    return listMenu;
  }

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        PaymentMethod selectedPayment = PaymentMethod.cash; // Default to cash

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Container(
                height: 400, // Ubah tinggi sesuai kebutuhan
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama",
                        style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Masukkan nama Anda",
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Nomor Meja",
                        style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: nomorMejaController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Masukkan nomor meja Anda",
                        ),
                      ),
                      SizedBox(height: 20),
                      Consumer<CartProvider>(
                        builder: (context, value, _) {
                          String strPesanan = "";
                          value.cart.forEach((element) {
                            strPesanan += "\n${element.name} (${element.quantity.toString()})";
                          });
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Harga: Rp. ${value.totalPrice}",
                                style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              if (selectedPayment == PaymentMethod.qr)
                                Image.asset(
                                  'assets/images/qr_kode.jpeg', 
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  String phone = "6289610053608";
                                  String pembayaran = selectedPayment == PaymentMethod.qr ? "Pembayaran : qr" : "Pembayaran : cash";
                                  String pesanan = "Nama: ${namaController.text}\n" +
                                      "Nomor Meja: ${nomorMejaController.text}\n" +
                                      "Pesanan:\n$strPesanan" +
                                      "\nTotal Harga: Rp. ${value.totalPrice}\n" +
                                      pembayaran;

                                  String whatsappUrl = "https://wa.me/$phone?text=${Uri.encodeComponent(pesanan)}";

                                  if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
                          await launchUrl(Uri.parse(whatsappUrl));
                        } else {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text("Tidak dapat membuka WhatsApp"),
                                    ));
                                  }
                                },
                                child: Text("Pesan Sekarang"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                  textStyle: GoogleFonts.montserrat(fontSize: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Pilih Metode Pembayaran:"),
                                  SizedBox(width: 10),
                                  DropdownButton<PaymentMethod>(
                                    value: selectedPayment,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedPayment = value!;
                                      });
                                    },
                                    items: [
                                      DropdownMenuItem(
                                        value: PaymentMethod.qr,
                                        child: Text("QR"),
                                      ),
                                      DropdownMenuItem(
                                        value: PaymentMethod.cash,
                                        child: Text("Cash"),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Menu Makanan & Minuman",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        child: badges.Badge(
          badgeContent: Consumer<CartProvider>(
            builder: (context, value, _) {
              return Text(
                (value.totalItems > 0) ? value.totalItems.toString() : "",
                style: GoogleFonts.montserrat(color: Colors.white),
              );
            },
          ),
          child: Icon(Icons.shopping_bag),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: getAllData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            MenuModel menu = snapshot.data![index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(menu.image),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            menu.name,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            menu.description,
                                            style: GoogleFonts.montserrat(fontSize: 14),
                                          ),
                                          SizedBox(height: 12),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Rp. " + menu.price.toString(),
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      Provider.of<CartProvider>(context, listen: false).addRemove(menu.name, menu.id, false, menu.price);
                                                    },
                                                    icon: Icon(Icons.remove_circle, color: Colors.red),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Consumer<CartProvider>(
                                                    builder: (context, value, _) {
                                                      var id = value.cart.indexWhere((element) => element.menuId == snapshot.data![index].id);
                                                      return Text(
                                                        (id == -1) ? "0" : value.cart[id].quantity.toString(),
                                                        style: GoogleFonts.montserrat(fontSize: 15),
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      Provider.of<CartProvider>(context, listen: false).addRemove(menu.name, menu.id, true, menu.price);
                                                    },
                                                    icon: Icon(Icons.add_circle, color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: Text("Tidak Ada Data"));
                      }
                    }
                  },
                ),
              ),
              // Add this SizedBox to provide padding at the bottom of the ListView
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

enum PaymentMethod {
  qr,
  cash,
}