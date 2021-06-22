import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectpfe/controllers/Services.dart';
import 'package:projectpfe/models/MyFiles.dart';
import 'package:projectpfe/models/Projet.dart';

import '../../../constants.dart';

class FileInfoCard extends StatefulWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  _FileInfoCardState createState() => _FileInfoCardState();
}

class _FileInfoCardState extends State<FileInfoCard> {
  List<Projet>? _Projets;

  @override
  void initState() {
    // TODO: implement initState
    _Projets = [];
    _getPatients();
    print(_Projets);
  }

  _getPatients() {
    Services.getProjets().then((projets) {
      setState(() {
        _Projets = projets;
      }); // Reset the title...
      print("Length ${projets.length}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: widget.info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  widget.info.svgSrc!,
                  color: widget.info.color,
                ),
              ),
              Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          Text(
            widget.info.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: widget.info.color,
            percentage: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "18 Files",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white70),
              ),
              Text(
                widget.info.totalStorage!,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
