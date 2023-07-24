import 'package:Lets_Chat/common/values/values.dart';
import 'package:Lets_Chat/common/widgets/app.dart';
import 'package:Lets_Chat/pages/contact/widgets/contact_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});

  AppBar _buildAppBar() {
    return transparentAppBar(
      title: Text(
        'Contact',
        style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('users number is ${controller.state.contactList.length}');
    return Scaffold(
      appBar: _buildAppBar(),
      body: ContactList(),
    );
  }
}
