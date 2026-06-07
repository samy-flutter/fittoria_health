import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/presentation/widgets/hub_grid.dart';
import '../../../../routes/route_names.dart';

class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('More'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: HubGrid(
        title: 'More',
        subtitle: 'Shop, learn & account',
        icon: LucideIcons.moreHorizontal,
        sections: [
          HubGridSectionData(
            title: 'Shop',
            items: [
              const HubGridItem(
                route: RouteNames.patientShop,
                label: 'Browse Products',
                desc: 'Health & fitness',
                icon: LucideIcons.shoppingBag,
                color: Color(0xFFEC4899),
              ),
              const HubGridItem(
                route: RouteNames.patientShopCart,
                label: 'Cart',
                desc: 'Your items',
                icon: LucideIcons.shoppingCart,
                color: Color(0xFFEC4899),
              ),
              const HubGridItem(
                route: RouteNames.patientShopOrders,
                label: 'My Orders',
                desc: 'Track orders',
                icon: LucideIcons.receipt,
                color: Color(0xFFF59E0B),
              ),
              const HubGridItem(
                route: RouteNames.patientShopAddresses,
                label: 'Addresses',
                desc: 'Delivery',
                icon: LucideIcons.mapPin,
                color: Color(0xFF3B82F6),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Learn',
            items: [
              const HubGridItem(
                route: RouteNames.patientAcademy,
                label: 'Academy',
                desc: 'Expert videos',
                icon: LucideIcons.graduationCap,
                color: Color(0xFF8B5CF6),
              ),
            ],
          ),
          HubGridSectionData(
            title: 'Account',
            items: [
              const HubGridItem(
                route: RouteNames.patientInvoices,
                label: 'Invoices',
                desc: 'Billing history',
                icon: LucideIcons.receipt,
                color: Color(0xFF6B7280),
              ),
              const HubGridItem(
                route: RouteNames.patientProfile,
                label: 'My Profile',
                desc: 'Settings',
                icon: LucideIcons.user,
                color: Color(0xFF0D6E6E),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
