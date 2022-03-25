import 'package:flutter/material.dart';

import '../models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> populars;
  final String? title;
  final Function onNextPage;

  const MovieSlider({Key? key, required this.populars, this.title, required this.onNextPage}) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 900) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.populars.isEmpty) {
      return const SizedBox(
        width: double.infinity,
        height: 340,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.title != null)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.title!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.populars.length,
            itemBuilder: (_, int index) => _MoviePoster(
              widget.populars[index], 
              '${widget.title} - {$index} - ${widget.populars[index].id}'),
          ),
        )
      ]),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie popularMovie;
  final String heroId;

  const _MoviePoster(this.popularMovie, this.heroId);

  @override
  Widget build(BuildContext context) {
    popularMovie.heroId = heroId;

    return Container(
        width: 130,
        height: 190,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'details', arguments: popularMovie),
              child: Hero(
                tag: popularMovie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/no-image.jpg'),
                    image: NetworkImage(popularMovie.fullPosterImg),
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              popularMovie.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}
