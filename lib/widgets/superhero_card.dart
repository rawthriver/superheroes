import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:superheroes/blocs/main_bloc.dart';
import 'package:superheroes/model/alignment_info.dart';
import 'package:superheroes/resources/superheroes_colors.dart';
import 'package:superheroes/resources/superheroes_images.dart';

class SuperheroCard extends StatelessWidget {
  final SuperheroInfo info;
  final VoidCallback action;
  final bool swipeEnabled;

  const SuperheroCard({
    super.key,
    required this.info,
    required this.action,
    this.swipeEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: SuperheroesColors.card,
          borderRadius: BorderRadius.circular(swipeEnabled ? 0 : 8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          AvatarWidget(info: info),
          const SizedBox(width: 12),
          DescriptionWidget(info: info),
          if (info.alignment != null) AlignmentWidget(alignment: info.alignment!),
        ]),
      ),
    );
  }
}

class AlignmentWidget extends StatelessWidget {
  final AlignmentInfo alignment;

  const AlignmentWidget({
    super.key,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(6),
        color: alignment.color,
        child: Text(
          alignment.name.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: SuperheroesColors.text,
          ),
        ),
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.info,
  });

  final SuperheroInfo info;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info.name.toUpperCase(),
            style: const TextStyle(
              color: SuperheroesColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            info.realName,
            style: const TextStyle(
              color: SuperheroesColors.text,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.info,
  });

  final SuperheroInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      width: 70,
      height: 70,
      child: CachedNetworkImage(
        imageUrl: info.imageUrl,
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: SuperheroesColors.main,
              value: progress.progress,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Image.asset(
              SuperheroesImages.unknown,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
