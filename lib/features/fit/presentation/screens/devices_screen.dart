import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../cubit/devices_cubit.dart';
import '../../data/models/fitness_hub_models.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  final List<Map<String, dynamic>> _allProviders = [
    {'key': 'apple_health', 'name': 'Apple Health', 'emoji': '🍎'},
    {'key': 'whoop', 'name': 'Whoop', 'emoji': '⚫'},
    {'key': 'oura', 'name': 'Oura Ring', 'emoji': '💍'},
    {'key': 'fitbit', 'name': 'Fitbit', 'emoji': '⌚'},
    {'key': 'google_fit', 'name': 'Google Fit', 'emoji': '🏃'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<DevicesCubit>().loadDevices();
  }

  void _toggleConnection(String provider, String name, bool isConnected) {
    if (isConnected) {
      context.read<DevicesCubit>().disconnectDevice(provider);
    } else {
      context.read<DevicesCubit>().connectDevice(provider, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
      appBar: AppBar(
        title: const Text('Connected Devices'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<DevicesCubit, DevicesState>(
        listener: (context, state) {
          if (state is DevicesError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is DevicesLoading || state is DevicesInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          List<FitDevice> connectedDevices = [];
          if (state is DevicesLoaded) {
            connectedDevices = state.devices;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.fitOrange.withValues(alpha: 0.1),
                        borderRadius: AppRadius.borderLg,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(LucideIcons.watch, color: AppColors.fitOrange),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Connected Devices', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                          Text('Sync wearables & apps', style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.fitOrange.withValues(alpha: 0.05),
                    border: Border.all(color: AppColors.fitOrange.withValues(alpha: 0.3)),
                    borderRadius: AppRadius.borderXl,
                  ),
                  child: Text(
                    'Connect your wearable to keep all your health data in one place. Live device sync automatically updates your dashboard.',
                    style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                  ),
                ),
                const SizedBox(height: 24),
                Column(
                  children: _allProviders.map((p) {
                    final providerKey = p['key'] as String;
                    final fitDevice = connectedDevices.where((d) => d.provider == providerKey && d.status == 'connected').firstOrNull;
                    final bool connected = fitDevice != null;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkBgSurface : AppColors.lightBgSurface,
                        borderRadius: AppRadius.borderXl,
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkBgBase : AppColors.lightBgBase,
                              borderRadius: AppRadius.borderLg,
                            ),
                            alignment: Alignment.center,
                            child: Text(p['emoji'] as String, style: const TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['name'] as String, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)),
                                const SizedBox(height: 4),
                                Text(
                                  connected ? 'Connected · synced ${fitDevice.lastSyncAt}' : 'Not connected',
                                  style: GoogleFonts.inter(fontSize: 10, color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: connected ? Colors.transparent : AppColors.fitOrange,
                              foregroundColor: connected ? (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted) : Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.borderLg,
                                side: connected ? BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder) : BorderSide.none,
                              ),
                              elevation: 0,
                              minimumSize: const Size(0, 36),
                            ),
                            onPressed: () => _toggleConnection(providerKey, p['name'] as String, connected),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(connected ? LucideIcons.unlink : LucideIcons.link2, size: 14),
                                const SizedBox(width: 6),
                                Text(connected ? 'Disconnect' : 'Connect', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
