import 'package:flutter/material.dart';

class AddUpdatePage extends StatelessWidget {
  const AddUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product",style: TextStyle(fontFamily: "Poppins"),),
        centerTitle: true,
        leading: IconButton(onPressed: (){debugPrint("back");}, icon: Icon(Icons.arrow_back_ios,color: Colors.blueAccent, )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: double.infinity ,
                // color: Colors.grey.shade300,
                // margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // IconButton(onPressed: (){}, icon: Icon(Icons.browse_gallery, size: 32,)

                    Icon(Icons.image_outlined, size: 52,color: Colors.black,),
                    SizedBox(height: 8,),
                    Text("Upload Image",style: TextStyle(color: Colors.black54,fontFamily: "Poppins"),)
                  ],
                ),
              ),
              const SizedBox(height: 18),

              const Text("name",style: TextStyle(fontFamily: "Poppins"),),
              const SizedBox(height: 8),
              _customTextField(),

              const SizedBox(height: 18),
              const Text("price",style: TextStyle(fontFamily: "Poppins"),),
              const SizedBox(height: 8),
              _customTextField(suffix: const Text("\$", style: TextStyle(color: Colors.grey),)),
              
              const SizedBox(height: 18),
              const Text("description",style: TextStyle(fontFamily: "Poppins"),),
              const SizedBox(height: 8,),
              _customTextField(
                maxLines: 3
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height:48 ,
                child: ElevatedButton(
                  onPressed: (){debugPrint("btn pressed");},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                  ),

                 child: const Text("ADD",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: "Poppins"),)),
              ),

              const SizedBox(height: 24,),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: (){debugPrint("btn clicked");},
                  style: OutlinedButton.styleFrom(
                    // backgroundColor: Colors.white,
                    foregroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: const BorderSide(
                      color: Colors.redAccent
                    )
                    
                  ),
                  

                  child: const Text("DELETE",style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold,fontFamily: "Poppins")),),
              )




              


            ],
          ),
        ),
        
      )
    );
  }
  Widget _customTextField({int maxLines=1, Widget? suffix}){
    return TextField(
      maxLines: maxLines,
      decoration:InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:  BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 14),
      )
    );
  }
}