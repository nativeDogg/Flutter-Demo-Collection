import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Movie_App/model/movie_model.dart';

class MovieAppHomePage extends StatefulWidget {
  const MovieAppHomePage({super.key});

  @override
  State<MovieAppHomePage> createState() => _MovieAppHomePageState();
}

class _MovieAppHomePageState extends State<MovieAppHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(0xFF1c1c27), body: _BuildMovieBody());
  }
}

class _BuildMovieBody extends StatefulWidget {
  const _BuildMovieBody({super.key});

  @override
  State<_BuildMovieBody> createState() => __BuildMovieBodyState();
}

class __BuildMovieBodyState extends State<_BuildMovieBody> {
  late PageController _pageController;
  double _pageOffset = 1;
  int currentIndex = 0;

  @override
  void initState() {
    PageController(initialPage: 0, viewportFraction: 0.6).addListener(() {
      setState(() {
        _pageOffset = _pageController.page!;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          // pageView主体
          PageView.builder(
            controller: _pageController,
            onPageChanged: (pageIndex) {
              setState(() {
                currentIndex = pageIndex;
              });
            },
            itemBuilder: (context, index) {
              double scale = max(
                0.6,
                (1 - (_pageOffset - index).abs() + 0.6),
              );
              double angle = (_pageController.position.haveDimensions
                      ? index.toDouble() - (_pageController.page ?? 0)
                      : index.toDouble() - 1) *
                  5;
              angle = angle.clamp(-5, 5);
              final movie = movies[index % movies.length];
              return Padding(
                padding: EdgeInsets.only(
                  top: 100 - (scale / 1.6 * 100),
                ),
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: angle * pi / 90,
                      child: Hero(
                        tag: movie.poster,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            movie.poster,
                            height: 300,
                            width: 205,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
          // 分页器
        ],
      ),
    );
  }
}
