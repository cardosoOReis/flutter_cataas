import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neubrutalism_ui/neubrutalism_ui.dart';

import '../cubit/cat_filter_cubit/cat_filter_cubit.dart';
import '../cubit/main_cat_cubit/main_cat_cubit.dart';
import '../extensions/build_context_extensions.dart';

class SaySomethingTextField extends StatelessWidget {
  const SaySomethingTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CatFilterCubit>();
    return NeuContainer(
      color: const Color.fromARGB(255, 214, 140, 164),
      borderRadius: BorderRadius.circular(15),
      child: Row(
        children: [
          const SizedBox(width: 6),
          const Icon(Icons.tag_outlined),
          const SizedBox(width: 13),
          Expanded(
            child: TextField(
              onSubmitted: (_) {
                context.read<MainCatCubit>().onNewCatTap(cubit.state);
              },
              controller: cubit.catTextController,
              decoration: InputDecoration(
                hintText: context.l10n.addTextToCatInputHint,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: cubit.onCatTextClear,
            icon: const Icon(Icons.clear_outlined),
          ),
        ],
      ),
    );
  }
}
