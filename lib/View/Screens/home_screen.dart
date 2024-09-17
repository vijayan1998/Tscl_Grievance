import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trichy_iccc_grievance/Controller/user_request.dart';
import 'package:trichy_iccc_grievance/Utils/Constant/app_pages_names.dart';
import 'package:trichy_iccc_grievance/View/Screens/grievance_detail.dart';
import 'package:trichy_iccc_grievance/View/Screens/my_reports.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
   final UserController _userController = UserController();
   @override
  void initState() {
    _loadUserData();
    super.initState();
  }
 Future<void> _loadUserData() async {
    await _userController.fetchUserData(); // Replace 'userId' with actual user ID
    setState(() {}); // Update the screen after data is fetched
  }
  @override
  Widget build(BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
     
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black), // Ensure the drawer icon is visible
         leading: Padding(
           padding: const EdgeInsets.only(left: 15),
           child: Image.asset("assets/images/logo.png",),
         ),
    //       actions: [
    //       Padding(
    //         padding: const EdgeInsets.only(right: 20.0),
    //         child: InkWell(
    //           onTap: () {
    //            // Navigator.pushNamed(context, AppPageNames.notificationScreen);
    //               Fluttertoast.showToast(
    //   msg: 'No Notification',
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.blue,
    //   textColor: Colors.white,
    //   fontSize: 15.0,
    // ); 
    //           },
    //           child: const Icon(
    //             Icons.notifications_outlined,
    //             size: 30,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //     ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
              height: 0.8,
            ),
          ),
        ),
        body:  Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const Image(image: AssetImage("assets/images/trichy.png"),height: 229,width: 358,),
              const SizedBox(height: 15,),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                         width: screenWidth*0.27,
                         //height: screenHeight*0.10,
                        decoration:  BoxDecoration(
                          //boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 1)],
                        borderRadius: BorderRadius.circular(5),color: const Color.fromRGBO(255, 240, 240, 1)),
                        child:  Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                          
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  
              Text('${_userController.itemCount}' ,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500 ),),
            
                                 // SizedBox(width: 30,),
                                
                                  const Image(image: AssetImage("assets/icons/user_check-1.jpg"),height: 29,width: 29,)
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(AppLocalizations.of(context)!.totalreq,style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        ),
                      ),
                        Container(
                         width: screenWidth*0.27,
                        // height: screenHeight*0.10,
                        decoration:  BoxDecoration(
                          //boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 1)],
                        borderRadius: BorderRadius.circular(5),color: const Color.fromRGBO(218, 213, 248, 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                          
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                 
               Text('${_userController.statusCount}' ,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500 ),),
            
                                 // SizedBox(width: 30,),
                                  const Image(image: AssetImage("assets/icons/hot_request-1.jpg"),height: 29,width: 29,)
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(AppLocalizations.of(context)!.openreq,style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        ),
                      ),
                        Container(
                         width: screenWidth*0.27,
                        // height: screenHeight*0.10,
                        decoration:  BoxDecoration(
                          //boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 1)],
                        borderRadius: BorderRadius.circular(5),color: const Color.fromRGBO(225, 255, 245, 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                          
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                
              Text('${_userController.closedCount}' ,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500 ),),
          
                                 // SizedBox(width: 30,),
                                  const Image(image: AssetImage("assets/icons/all_open-1.jpg"),height: 29,width: 29,)
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(AppLocalizations.of(context)!.closereq,style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400),),
                              )
                            ],
                          ),
                        ),
                      )

                    ],
                  ),
              const SizedBox(height: 20,),
              Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => const GrievanceDetail()));
            },child: Container(
              height:screenHeight*0.17 ,//148
              width: screenWidth*0.4,//172
              color: const Color.fromRGBO(238, 245, 255, 1),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SvgPicture.asset(
            "assets/icons/raising.svg",
            width: 32,
            height: 40,
          ),
               const SizedBox(height: 15,),
                   Text(AppLocalizations.of(context)!.raisetick,style: const TextStyle(color: Colors.black54),textAlign: TextAlign.center,)
                ],
              ),
            ),),
             InkWell(onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReports()));
             },child: Container(
              height: screenHeight*0.17,
              width: screenWidth*0.4,
             color: const Color.fromRGBO(238, 245, 255, 1),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
            "assets/icons/track.svg",
            width: 32,
            height: 40,
          ),
               const SizedBox(height: 15,),
                   Text(AppLocalizations.of(context)!.trackurgri,style: const TextStyle(color: Colors.black54),textAlign: TextAlign.center,)
                ],
              ),
            ),)
          ],
        ),
        const SizedBox(height: 10,),
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(onTap: (){
                  Navigator.pushNamed(context, AppPageNames.profileScreen);
            },child: Container(
              height: screenHeight*0.17,
              width: screenWidth*0.4,
              color: const Color.fromRGBO(238, 245, 255, 1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SvgPicture.asset(
            "assets/icons/profile.svg",
            width: 32,
            height: 40,
          ),
               const SizedBox(height: 15,),
                   Text(AppLocalizations.of(context)!.profile,style: const TextStyle(color: Colors.black54),)
                ],
              ),
            ),),
             InkWell(onTap: (){
                 Navigator.pushNamed(context, AppPageNames.faqScreen);
             },child: Container(
              height: screenHeight*0.17,
              width: screenWidth*0.4,
              color: const Color.fromRGBO(238, 245, 255, 1),
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 SvgPicture.asset(
            "assets/icons/faq.svg",
            width: 32,
            height: 40,
          ),
               const SizedBox(height: 15,),
                  Text(AppLocalizations.of(context)!.faq,style: const TextStyle(color: Colors.black54),textAlign: TextAlign.center,)
                ],
              ),
            ),)
          ],
        )
      ],
    )
            ]
          ),
        ),
    );
  }
}
