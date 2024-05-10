import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:closet_conscious/core/connectivity/presentation/blocs/connectivity_bloc.dart';
import 'package:closet_conscious/generated/l10n.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final S loc = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.offlineStatus),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/SVG_CC_Logo.svg',
              width: 100, // Adjust the width as needed
              height: 100, // Adjust the height as needed
            ),
            const SizedBox(height: 20),
            Text(
              loc.appName,
              textAlign: TextAlign.center,
              style: const TextStyle( // Add const
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => BlocProvider.of<ConnectivityBloc>(context).add(CheckConnectivity()),
              child: Text(loc.retryConnection),
            ),
          ],
        ),
      ),
    );
  }
}
