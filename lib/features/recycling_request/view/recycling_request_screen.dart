import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/recycling_request/cubit/recycling_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

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
      backgroundColor: AppColors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
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

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// MATERIAL
                Text(
                  'add_process.select_material'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.8,
                  children: [
                    MaterialCardWidget(
                      title: 'add_process.paper'.tr(),
                      icon: Icons.description_outlined,
                      isSelected: cubit.selectedMaterial == 'ÙˆØ±Ù‚',
                      onTap: () => cubit.selectMaterial('ÙˆØ±Ù‚'),
                    ),
                    MaterialCardWidget(
                      title: 'add_process.plastic'.tr(),
                      icon: Icons.eco_outlined,
                      isSelected: cubit.selectedMaterial == 'Ø¨Ù„Ø§Ø³ØªÙŠÙƒ',
                      onTap: () => cubit.selectMaterial('Ø¨Ù„Ø§Ø³ØªÙŠÙƒ'),
                    ),
                    MaterialCardWidget(
                      title: 'add_process.electronics'.tr(),
                      icon: Icons.devices_other_outlined,
                      isSelected: cubit.selectedMaterial == 'Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª',
                      onTap: () => cubit.selectMaterial('Ø¥Ù„ÙƒØªØ±ÙˆÙ†ÙŠØ§Øª'),
                    ),
                    MaterialCardWidget(
                      title: 'add_process.metal'.tr(),
                      icon: Icons.precision_manufacturing_outlined,
                      isSelected: cubit.selectedMaterial == 'Ù…Ø¹Ø¯Ù†',
                      onTap: () => cubit.selectMaterial('Ù…Ø¹Ø¯Ù†'),
                    ),
                  ],
                ),

                const SizedBox(height: 1),

                /// CENTER
                Text(
                  'add_process.center'.tr(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: cubit.selectedCenter,
                        hint: Text('add_process.choose_center'.tr()),
                        isExpanded: true,
                        items: cubit.centers.map((center) {
                          return DropdownMenuItem<String>(
                            value: center,
                            child: Text(center),
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
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: cubit.pickImage,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
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
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'ØªÙ… Ø§Ù„ØªØ¹Ø±Ù Ø¹Ù„Ù‰: ${cubit.predictionResult}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ù†Ø³Ø¨Ø© Ø§Ù„Ø¯Ù‚Ø©: ${cubit.confidence.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.green.shade700,
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
          );
        },
      ),
    );
  }
}


