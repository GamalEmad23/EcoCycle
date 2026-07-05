import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/widgets/arabic_text.dart';
import 'package:eco_cycle/features/recycling_request/cubit/recycling_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:eco_cycle/core/utils/recycling_material.dart';
import 'package:eco_cycle/core/responsive/responsive_layout.dart';

import 'widgets/material_card_widget.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_input_field.dart';

class RecyclingRequestScreen extends StatelessWidget {
  const RecyclingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecyclingRequestCubit()..getCenters(),
      child: const _RecyclingRequestView(),
    );
  }
}

class _RecyclingRequestView extends StatelessWidget {
  const _RecyclingRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'add_process.recycling'.tr(),
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocConsumer<RecyclingRequestCubit, RecyclingRequestState>(
        listener: (context, state) {
          if (state is RecyclingRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('add_process.request_sent_success'.tr()),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is RecyclingRequestError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.watch<RecyclingRequestCubit>();

          return ResponsiveContent(
            maxWidth: 800,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// MATERIAL
                  Text(
                    'add_process.select_material'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) => GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: constraints.maxWidth >= 720 ? 4 : 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: constraints.maxWidth >= 720
                          ? 1.45
                          : 1.8,
                      children: [
                        MaterialCardWidget(
                          title: 'add_process.paper'.tr(),
                          icon: Icons.description_outlined,
                          isSelected:
                              cubit.selectedMaterial == RecyclingMaterial.paper,
                          onTap: () =>
                              cubit.selectMaterial(RecyclingMaterial.paper),
                        ),
                        MaterialCardWidget(
                          title: 'add_process.plastic'.tr(),
                          icon: Icons.eco_outlined,
                          isSelected:
                              cubit.selectedMaterial ==
                              RecyclingMaterial.plastic,
                          onTap: () =>
                              cubit.selectMaterial(RecyclingMaterial.plastic),
                        ),
                        MaterialCardWidget(
                          title: 'add_process.electronics'.tr(),
                          icon: Icons.devices_other_outlined,
                          isSelected:
                              cubit.selectedMaterial ==
                              RecyclingMaterial.electronics,
                          onTap: () => cubit.selectMaterial(
                            RecyclingMaterial.electronics,
                          ),
                        ),
                        MaterialCardWidget(
                          title: 'add_process.metal'.tr(),
                          icon: Icons.precision_manufacturing_outlined,
                          isSelected:
                              cubit.selectedMaterial == RecyclingMaterial.metal,
                          onTap: () =>
                              cubit.selectMaterial(RecyclingMaterial.metal),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 1),

                  /// CENTER
                  Text(
                    'add_process.center'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (cubit.isLoadingCenters)
                    Center(
                      child: LottieBuilder.asset(
                        "assets/lotties/Green eco earth animation.json",
                        height: 100,
                      ),
                    )
                  else if (cubit.centers.isEmpty)
                    Center(child: Text("common.no_centers".tr()))
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: cubit.selectedCenter,
                          hint: Text(
                            'add_process.choose_center'.tr(),
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                          isExpanded: true,
                          dropdownColor: AppColors.white,
                          style: TextStyle(color: AppColors.textPrimary),
                          iconEnabledColor: AppColors.textPrimary,
                          items: cubit.centers.map((center) {
                            return DropdownMenuItem<String>(
                              value: center,
                              child: ArabicText(center),
                            );
                          }).toList(),
                          onChanged: cubit.selectCenter,
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  /// WEIGHT
                  Text(
                    'add_process.estimated_weight'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  CustomInputField(
                    hintText: 'add_process.enter_weight'.tr(),
                    onChanged: cubit.updateWeight,
                  ),

                  const SizedBox(height: 24),

                  /// IMAGE
                  Text(
                    'add_process.upload_image'.tr(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: cubit.pickImage,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            cubit.image != null
                                ? Icons.check_circle_outline
                                : Icons.camera_enhance_outlined,
                            color: cubit.image != null
                                ? Colors.green
                                : const Color(0xFF00E676),
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cubit.image != null
                                ? 'add_process.image_uploaded_success'.tr()
                                : 'add_process.upload_here'.tr(),
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (cubit.image != null && cubit.predictionResult.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen3,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.green),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'تم التعرف على: ${RecyclingMaterial.displayName(cubit.predictionResult)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'نسبة الدقة: ${cubit.confidence.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  const SizedBox(height: 40),

                  /// BUTTON
                  CustomButton(
                    text: 'add_process.confirm'.tr(),
                    isLoading: state is RecyclingRequestLoading,
                    onPressed: cubit.submitRequest,
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
