import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: _buildBody(context, state),
        );
      },
    );
  }

  Stack _buildBody(BuildContext context, AuthState authState) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Your Notes'),
              ),
              leading: IconButton(
                icon: authState is Authenticated
                    ? Icon(Icons.exit_to_app)
                    : Icon(Icons.account_circle),
                iconSize: 28.0,
                onPressed: () => authState is Authenticated
                    ? context.read<AuthBloc>().add(Logout())
                    : print('go to login'),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.brightness_4),
                  onPressed: () => print('change theme'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
