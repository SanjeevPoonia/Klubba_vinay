import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klubba/view/app_theme.dart';

class TextFieldShow extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldShow(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        validator: validator,
          controller: controller,
         // maxLength: 18,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
          ],
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldEmail extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldEmail(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator,
          controller: controller,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldLogin extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;
  Function onChanged;

  TextFieldLogin(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator,
          onChanged:(content){
          },
          controller: controller,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldRegister extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;
  double bottomInsets;

  TextFieldRegister(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller,required this.bottomInsets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          scrollPadding: EdgeInsets.only(bottom:bottomInsets + 40.0),
          validator: validator,
          controller: controller,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class TextFieldNumber extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  int maxLength;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldNumber(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller,required this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}




class TextFieldPincode extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  int maxLength;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;
  Function onChanged;

  TextFieldPincode(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller,required this.maxLength,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator,
          onChanged: onChanged(),
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}



class EmergencyNumber extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  int maxLength;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  EmergencyNumber(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller,required this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextFormField(
          validator: validator,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
               contentPadding: EdgeInsets.fromLTRB(7.0, 0.0, 0.0,15),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              fillColor: AppTheme.greyColor,
              filled: true,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class DisabledPhoneNumber extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  int maxLength;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  DisabledPhoneNumber(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller,required this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextFormField(
          validator: validator,
          enabled: false,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              border: InputBorder.none,
              counterText: "",
              contentPadding: EdgeInsets.fromLTRB(7.0, 0.0, 0.0,15),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              fillColor: Colors.grey.withOpacity(0.3),
              filled: true,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
class TextFieldRegister22 extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  int maxLength;
  Icon suffixIc;
  final String? Function(String?)? validator;
  var controller;

  TextFieldRegister22(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,required this.validator,this.controller,required this.maxLength});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          validator: validator,
          keyboardType: TextInputType.number,
          controller: controller,
          maxLength: maxLength,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              errorMaxLines: 3,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
class TextFieldShow2 extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;

  TextFieldShow2(
      {required this.labeltext, required this.fieldIC, required this.suffixIc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: fieldIC,
              ),
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
            //  prefixIcon: fieldIC,

              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
class TextFieldAddress extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;

  TextFieldAddress(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,this.controller});

  TextFieldState createState()=>TextFieldState();

}
class TextFieldPhone extends StatefulWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;
  var controller;

  TextFieldPhone(
      {required this.labeltext, required this.fieldIC, required this.suffixIc,this.controller});

  TextFieldPhoneState createState()=>TextFieldPhoneState();

}


class TextFieldPhoneState extends State<TextFieldPhone>
{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          keyboardType: TextInputType.number,
          controller: widget.controller,
          style: const TextStyle(
              fontSize: 15.0,
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
class TextFieldState extends State<TextFieldAddress>
{
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: widget.controller,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontWeight: FontWeight.w600
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,

              labelText: widget.labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}



class TextFieldWithIcon extends StatelessWidget {
  String labeltext;
  Icon fieldIC;
  Icon suffixIc;

  TextFieldWithIcon(
      {required this.labeltext, required this.fieldIC, required this.suffixIc});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: const TextStyle(
          fontSize: 15.0,
          color: Colors.black,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
            //prefixIcon: fieldIC,
            suffixIcon: Container(
              child: fieldIC,
            ),
            labelText: labeltext,
            labelStyle: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.7),
            )));
  }
}
class TextFieldWidget extends StatelessWidget {
  String labeltext;
  Widget fieldIC;
  Icon suffixIc;

  TextFieldWidget(
      {required this.labeltext, required this.fieldIC, required this.suffixIc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              // contentPadding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5),
              //prefixIcon: fieldIC,
              suffixIcon: Container(
                child: fieldIC,
              ),
              labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class CustomTextFieldWidget extends StatelessWidget {
  String labeltext;
  Icon suffixIc;

  CustomTextFieldWidget({required this.labeltext, required this.suffixIc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
            label: Row(
              children: [

                Text(labeltext),

                const Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),

              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class PhoneTextFieldWidget extends StatelessWidget {
  String labeltext;

  PhoneTextFieldWidget({required this.labeltext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              label: Row(
                children: [

                  Text(labeltext),

                  const Text('*', style: TextStyle(color: Colors.red)),
                ],
              ),
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}

class PinTextFieldWidget extends StatelessWidget {
  String labeltext;

  PinTextFieldWidget({required this.labeltext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
             labelText: labeltext,
              labelStyle: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.7),
              ))),
    );
  }
}
