import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/themes/app_colors.dart';
import '../cubit/order_cubit.dart';
import 'widget/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit()..getOrders("all"),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatefulWidget {
  const _OrdersView();

  @override
  State<_OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<_OrdersView>
    with TickerProviderStateMixin {
  late TabController tabController;
  int _currentTabIndex = 0;

  final tabs = ["all", "pending", "accepted", "rejected"];

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: tabs.length, vsync: this);

    tabController.addListener(() {
      if (tabController.index == _currentTabIndex) return;

      _currentTabIndex = tabController.index;
      context.read<OrderCubit>().getOrders(tabs[_currentTabIndex]);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("orders.title".tr()),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: "orders.all".tr()),
            Tab(text: "orders.pending".tr()),
            Tab(text: "orders.accepted".tr()),
            Tab(text: "orders.rejected".tr()),
          ],
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderSuccess) {
            if (state.orders.isEmpty) {
              return Center(child: Text("orders.no_orders".tr()));
            }

            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return OrderCard(order: state.orders[index]);
              },
            );
          }

          if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
