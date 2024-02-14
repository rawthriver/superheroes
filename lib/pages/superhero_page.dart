import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/exception/api_exception.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/pages/loading_error_page.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_icons.dart';
import 'package:superheroes/resources/superheroes_images.dart';
import 'package:superheroes/widgets/info_with_button.dart';
import 'package:superheroes/widgets/loading.dart';

class SuperheroPage extends StatefulWidget {
  final http.Client? client;
  final String id;

  const SuperheroPage({super.key, this.client, required this.id});

  @override
  State<SuperheroPage> createState() => _SuperheroPageState();
}

class _SuperheroPageState extends State<SuperheroPage> {
  late final SuperheroBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = SuperheroBloc(client: widget.client, id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: const Scaffold(
        backgroundColor: SuperheroesColors.background,
        body: SuperheroPageContent(),
      ),
    );
  }
}

class SuperheroPageContent extends StatelessWidget {
  const SuperheroPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<SuperheroPageState>(
      stream: bloc.observeSuperheroPageState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final state = snapshot.data!;
        switch (state) {
          case SuperheroPageState.loading:
            return const LoadingWidget();
          case SuperheroPageState.loaded:
            return const SuperheroWidget();
          case SuperheroPageState.error:
            return const LoadingErrorWidget();
        }
      },
    );
  }
}

class SuperheroWidget extends StatelessWidget {
  const SuperheroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<Superhero>(
      stream: bloc.observeSuperhero(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final hero = snapshot.data!;
        return CustomScrollView(
          slivers: [
            SuperheroAppBar(hero: hero),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  if (hero.powerstats.isNotEmpty()) PowerstatsWidget(powerstats: hero.powerstats),
                  BiographyWidget(biography: hero.biography),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const EmptyAppBar(),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 60),
            child: const LoadingIndicator(),
          ),
        ),
      ],
    );
  }
}

class LoadingErrorWidget extends StatelessWidget {
  const LoadingErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final SuperheroBloc bloc = Provider.of<SuperheroBloc>(context);
    return CustomScrollView(
      slivers: [
        const EmptyAppBar(),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 60),
            child: LoadingErrorPage(
              stream: bloc.errorSubject,
              retry: bloc.retry,
            ),
          ),
        ),
      ],
    );
  }
}

class EmptyAppBar extends StatelessWidget {
  const EmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: SuperheroesColors.background,
      foregroundColor: SuperheroesColors.text,
    );
  }
}

class SuperheroAppBar extends StatelessWidget {
  final Superhero hero;

  const SuperheroAppBar({
    super.key,
    required this.hero,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true,
      expandedHeight: 348,
      backgroundColor: SuperheroesColors.background,
      foregroundColor: SuperheroesColors.text,
      actions: const [FavoriteButton()],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          hero.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: SuperheroesColors.text,
          ),
        ),
        centerTitle: true,
        background: CachedNetworkImage(
          imageUrl: hero.image.url,
          fit: BoxFit.cover,
          placeholder: (context, url) => const ColoredBox(color: SuperheroesColors.card),
          errorWidget: (context, url, error) => Container(
            color: SuperheroesColors.card,
            padding: const EdgeInsets.symmetric(vertical: 42),
            child: Image.asset(
              SuperheroesImages.unknownBig,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SuperheroBloc>(context, listen: false);
    return StreamBuilder<bool>(
      stream: bloc.observeIsFavorite(),
      initialData: false,
      builder: (context, snapshot) {
        final isFavorite = snapshot.hasData && snapshot.data!;
        return GestureDetector(
          onTap: () => isFavorite ? bloc.removeFromFavorites() : bloc.addToFavorites(),
          child: Container(
            height: 52,
            width: 52,
            alignment: Alignment.center,
            child: Image.asset(
              isFavorite ? SuperheroesIcons.starFilled : SuperheroesIcons.starEmpty,
              width: 32,
              height: 32,
            ),
          ),
        );
      },
    );
  }
}

class PowerstatsWidget extends StatelessWidget {
  final Powerstats powerstats;

  const PowerstatsWidget({super.key, required this.powerstats});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Powerstats'.toUpperCase(),
          style: const TextStyle(
            color: SuperheroesColors.text,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const SizedBox(width: 16),
            PowerWidget(value: powerstats.intelligencePercent, name: 'Intelligence'),
            PowerWidget(value: powerstats.strengthPercent, name: 'Strength'),
            PowerWidget(value: powerstats.speedPercent, name: 'Speed'),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 20),
        Row(children: [
          const SizedBox(width: 16),
          PowerWidget(value: powerstats.durabilityPercent, name: 'Durability'),
          PowerWidget(value: powerstats.powerPercent, name: 'Power'),
          PowerWidget(value: powerstats.combatPercent, name: 'Combat'),
          const SizedBox(width: 16),
        ]),
        const SizedBox(height: 36),
      ],
    );
  }
}

class PowerWidget extends StatelessWidget {
  final double value;
  final String name;

  const PowerWidget({
    super.key,
    required this.value,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final color = calculateColor(value);
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 17),
            child: Text(
              '${(value * 100).toInt()}',
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          CustomPaint(
            painter: PowerstatPainter(value: value, color: color),
            size: const Size(66, 33),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 44),
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: SuperheroesColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color calculateColor(double value) {
    if (value <= 0.5) {
      return Color.lerp(Colors.red, Colors.orange, value / 0.5)!;
    } else {
      return Color.lerp(Colors.orange, Colors.green, (value - 0.5) / 0.5)!;
    }
  }
}

class PowerstatPainter extends CustomPainter {
  final double value;
  final Color color;

  PowerstatPainter({super.repaint, required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final paint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, pi, pi, false, paint);
    canvas.drawArc(rect, pi, pi * value, false, paint..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is PowerstatPainter ? oldDelegate.value != value : true;
  }
}

class BiographyWidget extends StatelessWidget {
  final Biography biography;

  const BiographyWidget({super.key, required this.biography});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: SuperheroesColors.card,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'bio'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SuperheroesColors.text,
                  ),
                ),
                const SizedBox(height: 8),
                BiographyItemWidget(name: 'Full name', value: biography.fullName),
                const SizedBox(height: 20),
                BiographyItemWidget(name: 'Aliases', value: biography.aliases.join(', ')),
                const SizedBox(height: 20),
                BiographyItemWidget(name: 'Place of birth', value: biography.placeOfBirth),
                const SizedBox(height: 8),
              ],
            ),
          ),
          if (biography.alignmentInfo != null) BiographyAlignmentWidget(alignment: biography.alignmentInfo!),
        ],
      ),
    );
  }
}

class BiographyItemWidget extends StatelessWidget {
  final String name;
  final String value;

  const BiographyItemWidget({
    super.key,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          name.toUpperCase(),
          style: const TextStyle(
            color: SuperheroesColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: SuperheroesColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class BiographyAlignmentWidget extends StatelessWidget {
  final AlignmentInfo alignment;

  const BiographyAlignmentWidget({
    super.key,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: RotatedBox(
        quarterTurns: 1,
        child: Container(
          width: 70,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: alignment.color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(
            alignment.name.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: SuperheroesColors.text,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}
