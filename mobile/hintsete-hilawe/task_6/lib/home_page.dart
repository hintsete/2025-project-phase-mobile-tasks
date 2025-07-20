import 'package:flutter/material.dart';
import 'package:task_6/add_update_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddUpdatePage()));
        },
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "July 14,2023",
                        style: TextStyle(fontSize: 12, color: Colors.grey, fontFamily: "Poppins"),
                      ),
                      Text.rich(
                        TextSpan(
                          text: "Hello, ",
                          children: [
                            TextSpan(
                              text: "Yohannes",
                              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 16,fontFamily: "Poppins"),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.notifications_none, color: Colors.black),
                  ),
                ],
              ),
            ),

            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Available Products",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,fontFamily: "Poppins"),
                  ),
                  IconButton(
                    onPressed: () {
                      debugPrint("search btn");
                    },
                    icon: const Icon(Icons.search, size: 24),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

          
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, idx) {
                  return _productCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _productCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              'images/Saint-Laurent.jpg', 
              fit: BoxFit.cover,
              height: 280,
              width: double.infinity,
            ),
          ),

          
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Saint Laurent Bag',
                      style: TextStyle(fontWeight: FontWeight.bold,fontFamily: "Poppins"),
                    ),
                    Text(
                      '\$120',
                      style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Luxury Handbag", style: TextStyle(color: Colors.grey,fontFamily: "Poppins")),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('(4.0)', style: TextStyle(color: Colors.grey,fontFamily: "Poppins")),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
