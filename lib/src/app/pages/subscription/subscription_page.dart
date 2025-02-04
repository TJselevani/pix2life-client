import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pix2life/core/payment/paypal.dart';
import 'package:pix2life/core/payment/stripe.dart';
import 'package:pix2life/core/utils/alerts/failure.dart';
import 'package:pix2life/core/utils/logger/logger.dart';
import 'package:pix2life/core/utils/theme/app_palette.dart';
import 'package:pix2life/core/utils/theme/app_theme_provider.dart';
import 'package:pix2life/src/features/auth/presentation/widgets/auth_round_button.dart';
import 'package:provider/provider.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({super.key});

  @override
  State<SubscriptionsPage> createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  final logger = createLogger(SubscriptionsPage);
  String selectedPlan = 'Monthly';
  String selectedPaymentMethod = 'Credit/Debit card';
  int monthlyCharge = 18;
  int annualCharge = 15 * 12;
  bool isLoading = false;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    // Initialize isDarkMode based on themeProvider's current theme
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider =
          Provider.of<MyThemeProvider>(context, listen: false);
      setState(() {
        isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
            (themeProvider.themeMode == ThemeMode.system &&
                MediaQuery.of(context).platformBrightness == Brightness.dark);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<MyThemeProvider>(context);

    // Update dark mode state based on theme provider
    isDarkMode = themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            SizedBox(height: ScreenUtil().setHeight(2)),
            _buildSubtitle(),
            SizedBox(height: ScreenUtil().setHeight(20)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                  ],
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(10)),
            _buildActionButton(),
            SizedBox(height: ScreenUtil().setHeight(10)),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor:
          isDarkMode ? AppPalette.darkBackground : AppPalette.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(); // Navigate back to the previous screen
        },
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Choose a plan',
      style: TextStyle(
        fontSize: ScreenUtil().setSp(40),
        fontFamily: 'Poppins',
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
            color: isSelected ? AppPalette.green : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
          color: AppPalette.primaryBlack.withOpacity(0.8),
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
                          color: AppPalette.primaryWhite,
                          fontFamily: 'Poppins',
                          fontSize: ScreenUtil().setSp(25),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "\$$charge.00",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: ScreenUtil().setSp(25),
                            fontWeight: FontWeight.w700,
                            color: AppPalette.green,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  planType == 'Monthly' ? ' /month' : ' /year',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: ScreenUtil().setSp(15),
                                fontWeight: FontWeight.w500,
                                color: AppPalette.primaryWhite,
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
                    color: AppPalette.green,
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
          color: AppPalette.primaryBlack.withOpacity(0.8),
          border: Border.all(
            width: 1,
            color: isSelected ? AppPalette.green : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: AppPalette.green,
                  size: ScreenUtil().setWidth(37),
                ),
                SizedBox(width: ScreenUtil().setWidth(20)),
                Text(
                  method,
                  style: TextStyle(
                    color: AppPalette.primaryWhite,
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
                    color: AppPalette.green,
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
              color: AppPalette.green,
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
                logger.i(
                    'Selected Plan: $selectedPlan, Payment Method: $selectedPaymentMethod');
                final int amount =
                    selectedPlan == 'Monthly' ? monthlyCharge : annualCharge;

                try {
                  switch (selectedPaymentMethod) {
                    case 'Paypal':
                      PayPalService.instance.createPayment(context);
                      break;
                    case 'Credit/Debit card':
                      await StripeService.instance.makePayment(amount, "usd");
                      break;
                    default:
                      throw Exception('Payment method not supported');
                  }
                  // Optionally show success message here
                } catch (e) {
                  ErrorSnackBar.show(
                      context: context,
                      message: 'Payment Failed: ${e.toString()}');
                  logger.e('Error during payment: $e'); // Log detailed error
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
            ),
          );
  }
}
