import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/config_reader.dart';
import 'service_closed_app.dart';

class PreShutdownWrapper extends StatefulWidget {
  final Widget child;
  const PreShutdownWrapper({super.key, required this.child});

  @override
  State<PreShutdownWrapper> createState() => _PreShutdownWrapperState();
}

class _PreShutdownWrapperState extends State<PreShutdownWrapper> {
  Timer? _ticker;
  Duration _remaining = Duration.zero;
  bool _shouldClose = false;

  @override
  void initState() {
    super.initState();
    final cutoff = ConfigReader.shutdownAfter;
    final showBanner = ConfigReader.showShutdownBanner;

    if (cutoff == null || !showBanner) return;

    void update() {
      final now = DateTime.now();
      final diff = cutoff.difference(now);
      if (diff.isNegative || diff.inSeconds == 0) {
        setState(() => _shouldClose = true);
        _ticker?.cancel();
      } else {
        setState(() => _remaining = diff);
      }
    }

    update();
    // Update every 30s (fine-grained enough, low CPU)
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => update());
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final days = d.inDays;
    final hrs = d.inHours % 24;
    final mins = d.inMinutes % 60;
    if (days > 0) return '${days}d ${hrs}h ${mins}m';
    if (d.inHours > 0) return '${d.inHours}h ${mins}m';
    return '${d.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final cutoff = ConfigReader.shutdownAfter;
    final showBanner = ConfigReader.showShutdownBanner;

    // If we reached cutoff → show closed app
    if (_shouldClose) {
      return ServiceClosedApp(
        title: ConfigReader.shutdownTitle,
        message: ConfigReader.shutdownMessage,
      );
    }

    // No banner? Just render the real app
    if (cutoff == null || !showBanner) {
      return widget.child;
    }

    final msg = ConfigReader.shutdownBannerText;

    // Draw the banner above the app using a Stack
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        children: [
          // Your real app
          Positioned.fill(child: widget.child),

          // Simple fixed banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF366D59),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0,2))],
                ),
                child: DefaultTextStyle(
                  style: const TextStyle(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          msg,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(_fmt(_remaining), style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
