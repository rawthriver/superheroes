import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:superheroes/blocs/superhero_bloc.dart';
import 'package:superheroes/model/biography.dart';
import 'package:superheroes/model/powerstats.dart';
import 'package:superheroes/model/superhero.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_icons.dart';

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
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class SuperheroAppBar extends StatelessWidget {
  const SuperheroAppBar({
    super.key,
    required this.hero,
  });

  final Superhero hero;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      stretch: true,
      pinned: true,
      floating: true, //try off
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
        final isFavorite = snapshot.hasData && snapshot.data != null && snapshot.data!;
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
      height: 300,
      alignment: Alignment.center,
      child: Text(
        biography.toJson().toString(),
        style: const TextStyle(color: SuperheroesColors.text),
      ),
    );
  }
}
