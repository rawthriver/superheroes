import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/resources/superheroes_colors.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
      controller.addListener(() => bloc.updateSearchText(controller.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return TextField(
      style: const TextStyle(
        fontSize: 20,
        height: 1.3,
        color: SuperheroesColors.text,
      ),
      cursorColor: SuperheroesColors.text,
      cursorRadius: const Radius.circular(2),
      decoration: InputDecoration(
        // isDense: true,
        filled: true,
        fillColor: SuperheroesColors.card.withOpacity(0.75),
        contentPadding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxHeight: 48),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2196F3)),
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.white54,
          size: 24,
        ),
        suffix: GestureDetector(
          onTap: controller.clear,
          child: const Icon(
            Icons.close,
            color: SuperheroesColors.text,
            size: 24,
          ),
        ),
      ),
      onChanged: (value) => bloc.updateSearchText(value),
      controller: controller,
    );
  }
}
