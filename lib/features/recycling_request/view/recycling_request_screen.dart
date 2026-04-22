import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/recycling_request/cubit/recycling_request_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/material_card_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input_field.dart';

class RecyclingRequestScreen extends StatelessWidget {
  const RecyclingRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecyclingRequestCubit()..getCenters(),
      child: const _RecyclingRequestView(),
    );
  }
}

class _RecyclingRequestView extends StatelessWidget {
  const _RecyclingRequestView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'add_process.recycling'.tr(),
          style: const TextStyle(
            color: Colors.black,
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
                  style: const TextStyle(
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
                      isSelected: cubit.selectedMaterial == 'ورق',
                      onTap: () => cubit.selectMaterial('ورق'),
                    ),
                    MaterialCardWidget(
                      title: 'add_process.plastic'.tr(),
                      icon: Icons.eco_outlined,
                      isSelected: cubit.selectedMaterial == 'بلاستيك',
                      onTap: () => cubit.selectMaterial('بلاستيك'),
                    ),
                    MaterialCardWidget(
                      title: 'add_process.electronics'.tr(),
                      icon: Icons.devices_other_outlined,
                      isSelected: cubit.selectedMaterial == 'إلكترونيات',
                      onTap: () => cubit.selectMaterial('إلكترونيات'),
                    ),
                    MaterialCardWidget(
                      title: 'add_process.metal'.tr(),
                      icon: Icons.precision_manufacturing_outlined,
                      isSelected: cubit.selectedMaterial == 'معدن',
                      onTap: () => cubit.selectMaterial('معدن'),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// CENTER
                Text(
                  'add_process.center'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                if (cubit.isLoadingCenters)
                  const Center(child: CircularProgressIndicator())
                else if (cubit.centers.isEmpty)
                  const Center(child: Text("No centers available"))
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
                  style: const TextStyle(
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
                  style: const TextStyle(
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
