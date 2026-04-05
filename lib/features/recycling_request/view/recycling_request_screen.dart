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
      create: (context) => RecyclingRequestCubit(),
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
          'recycling'.tr(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocConsumer<RecyclingRequestCubit, RecyclingRequestState>(
        listener: (context, state) {
          if (state is RecyclingRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('request_sent_success'.tr()),
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
          final cubit = context.read<RecyclingRequestCubit>();
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'select_material'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
                      title: 'paper'.tr(),
                      icon: Icons.description_outlined,
                      isSelected: cubit.selectedMaterial == 'ورق',
                      onTap: () => cubit.selectMaterial('ورق'),
                    ),
                    MaterialCardWidget(
                      title: 'plastic'.tr(),
                      icon: Icons.eco_outlined,
                      isSelected: cubit.selectedMaterial == 'بلاستيك',
                      onTap: () => cubit.selectMaterial('بلاستيك'),
                    ),
                    MaterialCardWidget(
                      title: 'electronics'.tr(),
                      icon: Icons.devices_other_outlined,
                      isSelected: cubit.selectedMaterial == 'إلكترونيات',
                      onTap: () => cubit.selectMaterial('إلكترونيات'),
                    ),
                    MaterialCardWidget(
                      title: 'metal'.tr(),
                      icon: Icons.precision_manufacturing_outlined,
                      isSelected: cubit.selectedMaterial == 'معدن',
                      onTap: () => cubit.selectMaterial('معدن'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'center'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: cubit.selectedCenter,
                      hint: Text(
                        'choose_center'.tr(),
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: ['مركز تدوير الخليج', 'إيكو بوينت المروج'].map((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (val) => cubit.selectCenter(val),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'estimated_weight'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                CustomInputField(
                  hintText: 'enter_weight'.tr(),
                  onChanged: (val) => cubit.updateWeight(val),
                ),
                const SizedBox(height: 24),
                Text(
                  'upload_image'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => cubit.pickImage(),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                              ? 'image_uploaded_success'.tr()
                              : 'upload_here'.tr(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'confirm'.tr(),
                  isLoading: state is RecyclingRequestLoading,
                  onPressed: () => cubit.submitRequest(),
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
