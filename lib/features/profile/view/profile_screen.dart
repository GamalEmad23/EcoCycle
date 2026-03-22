import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: CustomeText(
          text: "profile.title",
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),

      body: Stack(
       children: [
       /// User Profile Image
       Positioned(
         top: h*.025,
         right: w*.025,
         left: w*.025,
         child: CircleAvatar(
           backgroundColor: AppColors.lightGreen4,
           maxRadius: w*.19
           ),
       ),
       Positioned(
         top: h*.035,
         right: w*.025,
         left: w*.025,
         child: CircleAvatar(
           maxRadius: w*.17
           ),
       ),
            
       /// User Name 
       Positioned(
         top: h*.22,
         left: w*.1,
         right: w*.1,
         child: Center(child: CustomeText(text: "profile.name" , fontSize: 19, fontWeight: FontWeight.bold,))),
       
            
       /// User Rate
       Positioned(
         top: h*.27,
         right: w*.025,
         left: w*.025,
         child: Center(
           child: Container(
             height: h*.04,
             width: w*.5,
             decoration: BoxDecoration(
               color: AppColors.lightGreen3,
               borderRadius: BorderRadius.circular(20)
             ),
             child: Row(
               mainAxisAlignment: .center,
               children: [
                 CustomeText(text: "profile.badge" , fontSize: 16, fontWeight: FontWeight.w600,),
                 Icon(Icons.workspace_premium,color: AppColors.green,)
               ],
             ),
           ),
         ),
       ),
            
      /// Amountes Cards
      Positioned(
       top: h*.34,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: w*.031),
          child: Row(
            children: [
              customeProfileCard(h: h, w: w, text: 'stats.points', rate: '4.8K',),
              customeProfileCard(h: h, w: w, text: 'stats.recycled', rate: '15.2',),
              customeProfileCard(h: h, w: w, text: 'stats.rank', rate: '124',),
            ],
          ),
        ),
      ),
      
      
       ]
       ),
    );
  }
}

class customeProfileCard extends StatelessWidget {
  const customeProfileCard({
    super.key,
    required this.h,
    required this.w, required this.text, required this.rate,
  });

  final double h;
  final double w;
  final String text;
  final String rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: w*.012),
      child: Container(
       height: h*.11,
       width: w*.28,
       decoration: BoxDecoration(
         color: Colors.white,
         boxShadow: [
           BoxShadow(
             blurRadius: 2,
             color: Colors.black38,
             offset: Offset(2, 3),
             spreadRadius: 1
           ),
         ],
         borderRadius: BorderRadius.circular(10),
       ),
       child: Column(
        mainAxisAlignment: .center,
        children: [
          CustomeText(text: text, fontSize: 19,),
          CustomeText(text: rate, fontSize: 18, textColor: AppColors.primaryDark,),
        ],
       ),
      ),
    );
  }
}
