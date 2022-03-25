import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
        body: CustomScrollView(
      slivers: [
        _CustomAppBar(
          fullBackdropPath: movie.fullBackdropPath,
          movieTitle: movie.title,
          movieAdult: movie.adult,
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _PosterAndTitle(movie),
            _OverView(overView: movie.overview),
            const SizedBox(
              height: 20,
            ),
            CastingCards(
              movieId: movie.id,
            )
          ]),
        ),
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final String movieTitle;
  final String fullBackdropPath;
  final bool movieAdult;
  const _CustomAppBar({Key? key, required this.movieTitle, required this.fullBackdropPath, required this.movieAdult}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.redAccent,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
            color: Colors.black12,
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(movieTitle,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.white))),
        background: Stack(
          children: [
            FadeInImage(
              placeholder: const AssetImage('assets/loading.gif'),
              image: NetworkImage(fullBackdropPath),
              fit: BoxFit.cover,
            ),
            if (movieAdult)
              Positioned(
                  bottom: 10,
                  right: 10,
                  child: Image.asset(
                    'age-limit/18.png',
                    width: 40,
                  )),
          ],
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                image: NetworkImage(movie.fullPosterImg!),
                placeholder: const AssetImage('assets/no-image.jpg'),
                width: 110,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text('${movie.originalTitle} (${movie.yearRelease})',
                    style: textTheme.subtitle1, overflow: TextOverflow.ellipsis, maxLines: 1),
                Row(
                  children: [
                    const Icon(
                      Icons.star_outline,
                      size: 25,
                      color: Color.fromARGB(255, 192, 175, 24),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      movie.voteAverage.toString(),
                      style: textTheme.caption,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.remove_red_eye,
                      size: 20,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      movie.popularity.toString(),
                      style: textTheme.caption,
                    ),
                    const SizedBox(width: 10,),
                    const Icon(
                      Icons.thumb_up,
                      color: Colors.blueGrey,
                      size: 20,
                    ),
                    const SizedBox(width: 5,),
                    Text(movie.voteCount.toString(),style: textTheme.caption,)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OverView extends StatelessWidget {
  final String overView;
  const _OverView({Key? key, required this.overView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        overView,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
