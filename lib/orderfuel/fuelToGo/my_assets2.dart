import 'package:flutter/material.dart';
import 'package:test_prj/components/my_button.dart';
import 'package:test_prj/orderfuel/doorStepDelivery/assets_page.dart';
import 'package:test_prj/orderfuel/fuelToGo/assets_page2.dart';

class MyAssets2 extends StatefulWidget {
  const MyAssets2({super.key});

  @override
  State<MyAssets2> createState() => _AssetsState();
}

class _AssetsState extends State<MyAssets2> {
  int selectedValue = 1;

  Widget customRadio(String text, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedValue = index;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
              color: (selectedValue == index) ? Colors.black : Colors.blueGrey,
            ),
          ),
          Radio<int>(
            value: index,
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
            },
            activeColor: Colors.black,
          ),
        ],
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: Size(280, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10),
        ),
        side: BorderSide(
          color: (selectedValue == index) ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [
                    Color.fromRGBO(211, 83, 7, 1),
                    Color.fromRGBO(252, 130, 59, 1),
                    Color.fromRGBO(252, 130, 59, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0, left: 20),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 45.0, left: 100),
                    child: Text(
                      'Assets',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  customRadio("Genset", 1),
                  SizedBox(
                    height: 10,
                  ),
                  customRadio("Heavy Machinery", 2),
                  SizedBox(
                    height: 10,
                  ),
                  customRadio("Equipments", 3),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 219),
              child: Text(
                'Add Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 73,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Asset Name (eg: genset1)',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 73,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Asset Capacity/Power (eg: 120kva)',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 73,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Fuel capacity(eg: 200 litres)',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AssetsPage2(),)),
                  child: MyButton(text: 'Add Asset type')),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}