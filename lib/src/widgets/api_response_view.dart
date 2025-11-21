import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../data/data.dart';

class ApiResponseView<T> extends StatelessWidget {
  final ApiResponse<T>? response;
  final Widget Function(List<T>) responseBuilder;
  final Function()? retry;
  final String? emptyMessage;
  final bool showErrorMessage;
  final Widget? loadingView;
  const ApiResponseView({
    super.key,
    required this.responseBuilder,
    this.response,
    this.emptyMessage,
    this.retry,
    this.showErrorMessage = true,
    this.loadingView,
  });

  @override
  Widget build(BuildContext context) {
    if (response == null) {
      return loadingView ?? Center(child: CircularProgressIndicator(strokeWidth: 1));
    }

    if (!response!.success!) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showErrorMessage) ...[Text("${response!.message}"), Gap(4)],
          Center(
            child: InkWell(onTap: retry, child: const Icon(Icons.refresh_rounded)),
          ),
        ],
      );
    }

    final List<T> items = response!.items ?? [];

    if (items.isEmpty) {
      return Center(child: Text(emptyMessage ?? 'Aucune donnée'));
    }

    return responseBuilder(items);
  }
}
