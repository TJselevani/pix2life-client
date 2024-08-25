import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pix2life/config/app/app_palette.dart';
import 'package:pix2life/config/common/normal_rounded_button.dart';
import 'package:pix2life/functions/notifications/error.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  String selectedPlan = 'Monthly';
  String selectedPaymentMethod = 'Credit/Debit card';
  int monthlyCharge = 18;
  int annualCharge = 15 * 12;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.whiteColor,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              SizedBox(height: ScreenUtil().setHeight(2)),
              _buildSubtitle(),
              SizedBox(height: ScreenUtil().setHeight(20)),
              _buildPlanOption('Monthly', monthlyCharge),
              SizedBox(height: ScreenUtil().setHeight(20)),
              _buildPlanOption('Annually', annualCharge),
              SizedBox(height: ScreenUtil().setHeight(40)),
              _buildPaymentMethodTitle(),
              SizedBox(height: ScreenUtil().setHeight(20)),
              _buildPaymentMethodOption(
                  'Credit/Debit card', Icons.credit_card_rounded),
              SizedBox(height: ScreenUtil().setHeight(20)),
              _buildPaymentMethodOption('Paypal', Icons.paypal),
              Expanded(child: Container()),
              _buildActionButton(),
              SizedBox(height: ScreenUtil().setHeight(10)),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppPalette.whiteColor,
      elevation: 0,
    );
  }

  Widget _buildTitle() {
    return Text(
      'Choose a plan',
      style: TextStyle(
        fontSize: ScreenUtil().setSp(40),
        fontFamily: 'Poppins',
        color: AppPalette.blackColor,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      "Monthly or Yearly? It's your call",
      style: TextStyle(
        fontSize: ScreenUtil().setSp(18),
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppPalette.blackColor2,
      ),
    );
  }

  Widget _buildPlanOption(String planType, int charge) {
    final isSelected = selectedPlan == planType;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPlan = planType;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: isSelected ? AppPalette.greenColor : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
          color: AppPalette.blackColor.withOpacity(0.8),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ScreenUtil().setHeight(8),
                  horizontal: ScreenUtil().setWidth(18)),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        planType,
                        style: TextStyle(
                          color: AppPalette.whiteColor,
                          fontFamily: 'Poppins',
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "\$${charge}.00",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: ScreenUtil().setSp(25),
                            fontWeight: FontWeight.w700,
                            color: AppPalette.greenColor,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  planType == 'Monthly' ? ' /month' : ' /year',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ScreenUtil().setSp(15),
                                fontWeight: FontWeight.w500,
                                color: AppPalette.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: ScreenUtil().setHeight(32),
                right: ScreenUtil().setWidth(32),
                child: Container(
                  width: ScreenUtil().setWidth(12),
                  height: ScreenUtil().setWidth(12),
                  decoration: BoxDecoration(
                    color: AppPalette.greenColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTitle() {
    return Text(
      "Payment Method",
      style: TextStyle(
        fontSize: ScreenUtil().setSp(22),
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800,
        color: AppPalette.blackColor,
      ),
    );
  }

  Widget _buildPaymentMethodOption(String method, IconData icon) {
    final isSelected = selectedPaymentMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPalette.blackColor.withOpacity(0.8),
          border: Border.all(
            width: 1,
            color: isSelected ? AppPalette.greenColor : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppPalette.greenColor,
                  size: ScreenUtil().setWidth(37),
                ),
                SizedBox(width: ScreenUtil().setWidth(20)),
                Text(
                  method,
                  style: TextStyle(
                    color: AppPalette.whiteColor,
                    fontFamily: 'Poppins',
                    fontSize: ScreenUtil().setSp(20),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: ScreenUtil().setHeight(10),
                right: ScreenUtil().setWidth(20),
                child: Container(
                  width: ScreenUtil().setWidth(12),
                  height: ScreenUtil().setWidth(12),
                  decoration: BoxDecoration(
                    color: AppPalette.greenColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    return isLoading
        ? Center(
            child: LoadingAnimationWidget.horizontalRotatingDots(
              color: AppPalette.greenColor,
              size: ScreenUtil().setWidth(70),
            ),
          )
        : SizedBox(
            width: double.infinity,
            child: RoundedButton(
              useColor: true,
              name: 'Proceed with payment',
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                print(
                    'Selected Plan: $selectedPlan, Payment Method: $selectedPaymentMethod');
                if (selectedPlan == 'Monthly') {
                  print('Amount: \$${monthlyCharge}.00 /month');
                } else {
                  print('Amount: \$${annualCharge}.00 /year');
                }

                final int amount =
                    selectedPlan == 'Monthly' ? monthlyCharge : annualCharge;

                switch (selectedPaymentMethod) {
                  case 'Paypal':
                    // await PayPalService.instance.createPayment(context);
                    break;
                  case 'Credit/Debit card':
                    // await StripeService.instance.makePayment(amount, "usd");
                    break;
                  default:
                    ErrorSnackBar.show(
                      context: context,
                      message: 'Payment Currently Unavailable',
                    );
                }
                setState(() {
                  isLoading = false;
                });
              },
            ),
          );
  }
}
