import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/common_widgets.dart';
import 'package:kemsu_app/UI/views/calculation/calculation_bloc.dart';

class CalculationScreen extends StatefulWidget {
  const CalculationScreen({super.key});

  @override
  State<CalculationScreen> createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  final _calculationBloc = CalculationBloc(const CalculationState());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, Localizable.pageCalculation, canBack: false),
      body: BlocBuilder<CalculationBloc, CalculationState>(
        bloc: _calculationBloc,
        builder: (context, state) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.settings_applications, size: 64.0),
                Text(
                  'В разработке',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
