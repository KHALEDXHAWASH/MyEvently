import 'package:evently_c14_online_sun/core/resources/colors_manager.dart';
import 'package:evently_c14_online_sun/data/data_model/userDM.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfileHeaderWidget extends StatelessWidget {
  const CustomProfileHeaderWidget(
      {super.key,
       this.userName,
       this.userAccount,
      required this.userImage});

  final String? userName;
  final String? userAccount;
  final String userImage;

  @override
  Widget build(BuildContext context) {
    return Container(


      decoration: BoxDecoration(
          color: ColorsManager.blue,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(36.r))),
      child: Padding(
        
        padding: REdgeInsets.all(16),
        child: SafeArea(
          child: Row(
          
            children: [
              SizedBox(height: 24.h,),
              Image.asset(userImage),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      userDM.currentUser!.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      userDM.currentUser!.email,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
