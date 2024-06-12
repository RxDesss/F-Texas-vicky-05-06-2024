// ignore_for_file: prefer_const_constructors

import 'package:demo_project/GetX%20Controller/searchproductController.dart';
import 'package:demo_project/Screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProduct extends StatefulWidget {
  
  const SearchProduct({super.key});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final SearchProductController searchProductController = Get.put(SearchProductController());
  final ScrollController _controller = ScrollController();
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _controller.addListener(_loadMore);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: Colors.white,
      appBar: AppBar(
              backgroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              
              child: TextField(
                onChanged: (value)  {
                   searchProductController.filterProducts(value);
                },
                controller: _filterController,
                decoration: InputDecoration(
                  hintText: 'Search by SKU',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                String searchText = _filterController.text.toLowerCase();
                searchProductController.filterProducts(searchText);
             
              },
            ),
          ],
        ),
      ),
      body: Obx(() => ListView.builder(
        controller: _controller,
        itemCount: searchProductController.filteredProducts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              productDetailController.getProductDetail(searchProductController.filteredProducts[index]['sku']);
            },
            child: Container(
              width: MediaQuery.of(context).size.width*0.8,
              // height: 100,
              margin:EdgeInsets.all(MediaQuery.of(context).size.height*0.015),
              padding:EdgeInsets.all(MediaQuery.of(context).size.height*0.015),
              decoration: BoxDecoration(
              color: const Color(0xFFd2d5de),
               borderRadius:BorderRadius.circular(10),
                boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1), // shadow color
        spreadRadius: 5, // spread radius
        blurRadius: 7, // blur radius
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
              ),
              child: Column(
                children: [
                Row(
                  children: [
                    Text('Product Code: ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: const Color(0xFFCC0001)),),
                     Text(searchProductController.filteredProducts[index]['sku'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: const Color(0xFF292e7e)), )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                 SizedBox(
              
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description: ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: const Color(0xFFCC0001)),),
                       SizedBox(
                        width:MediaQuery.of(context).size.width*0.55,
                        child: Text(searchProductController.filteredProducts[index]['description'].replaceAll(RegExp(r'<[^>]*>|<\/[^>]*>'), '',),style: TextStyle(color: const Color(0xFF767475),fontSize: 16),maxLines: 3, overflow: TextOverflow.ellipsis,))
                    ],
                               ),
                 ),
               
                ],
                
              ),
            ),
          );
        },
      )),
    );
  }
}