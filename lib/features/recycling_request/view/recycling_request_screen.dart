import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/recycling_request_cubit.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'إعادة التدوير',
            style: TextStyle(
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
                const SnackBar(
                  content: Text('تم إرسال الطلب بنجاح!'),
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
                  const Text(
                    'اختر نوع المواد',
                    style: TextStyle(
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
                        title: 'ورق',
                        icon: Icons.description_outlined,
                        isSelected: cubit.selectedMaterial == 'ورق',
                        onTap: () => cubit.selectMaterial('ورق'),
                      ),
                      MaterialCardWidget(
                        title: 'بلاستيك',
                        icon: Icons.eco_outlined,
                        isSelected: cubit.selectedMaterial == 'بلاستيك',
                        onTap: () => cubit.selectMaterial('بلاستيك'),
                      ),
                      MaterialCardWidget(
                        title: 'إلكترونيات',
                        icon: Icons.devices_other_outlined,
                        isSelected: cubit.selectedMaterial == 'إلكترونيات',
                        onTap: () => cubit.selectMaterial('إلكترونيات'),
                      ),
                      MaterialCardWidget(
                        title: 'معدن',
                        icon: Icons.precision_manufacturing_outlined,
                        isSelected: cubit.selectedMaterial == 'معدن',
                        onTap: () => cubit.selectMaterial('معدن'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'المركز',
                    style: TextStyle(
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
                        hint: const Text(
                          'اختر المركز',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
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
                  const Text(
                    'الوزن التقديري',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomInputField(
                    hintText: 'أدخل الوزن (كجم)',
                    onChanged: (val) => cubit.updateWeight(val),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'تحميل صورة الإثبات',
                    style: TextStyle(
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
                                ? 'تم رفع الصورة بنجاح'
                                : 'اضغط هنا لرفع الصورة',
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
                    text: 'تأكيد العملية',
                    isLoading: state is RecyclingRequestLoading,
                    onPressed: () => cubit.submitRequest(),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
