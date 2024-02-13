import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/utils.dart';

class SearchWidget extends StatefulWidget {
  final FocusNode focus;

  const SearchWidget({super.key, required this.focus});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> with StateDelayedInit {
  late final TextEditingController controller;
  late final FocusNode focus;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    focus = widget.focus; //FocusNode();
    focus.addListener(() {
      if (!focus.hasFocus) setState(() {});
    });
    registerDelayedInit(() {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(() => bloc.updateSearchText(controller.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = controller.text.isEmpty;
    return TextField(
      style: const TextStyle(
        fontSize: 20,
        height: 1.3,
        color: SuperheroesColors.text,
      ),
      cursorColor: SuperheroesColors.text,
      cursorRadius: const Radius.circular(2),
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        // isDense: true,
        filled: true,
        fillColor: SuperheroesColors.card.withOpacity(0.75),
        contentPadding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxHeight: 48),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: isEmpty ? 1 : 2, color: isEmpty ? Colors.white24 : SuperheroesColors.text),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 2, color: SuperheroesColors.text),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white54,
          size: 24,
        ),
        suffix: GestureDetector(
          onTap: () {
            controller.clear();
            // focus.requestFocus();
            setState(() {});
          },
          child: const Icon(
            Icons.close,
            color: SuperheroesColors.text,
            size: 24,
          ),
        ),
        hintText: 'Search',
        hintStyle: const TextStyle(color: Colors.white24),
      ),
      controller: controller,
      focusNode: focus,
      onTapOutside: (_) => Fx.unFocus(),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    // focus.dispose();
    super.dispose();
  }
}
