import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_collect/Movie_App/model/movie_model.dart';
import 'package:flutter_demo_collect/Movie_App/model/seats_model.dart';

class MovieAppHomePage extends StatefulWidget {
  const MovieAppHomePage({super.key});

  @override
  State<MovieAppHomePage> createState() => _MovieAppHomePageState();
}

class _MovieAppHomePageState extends State<MovieAppHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1c1c27),
      body: _BuildMovieBody(),
    );
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
    _pageController = PageController(initialPage: 0, viewportFraction: 0.6)
      ..addListener(() {
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
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // pageView主体
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (pageIndex) {
                setState(() {
                  currentIndex = pageIndex;
                });
              },
              itemBuilder: (context, index) {
                double scale =
                    max(0.6, (1 - (_pageOffset - index).abs() + 0.6));
                double angle = (_pageController.position.haveDimensions
                        ? index.toDouble() - (_pageController.page ?? 0)
                        : index.toDouble() - 1) *
                    5;
                angle = angle.clamp(-5, 5);
                final movie = movies[index % movies.length];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _BuildMovieDetailBody(movie: movie),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 100 - (scale / 1.6 * 100)),
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
                  ),
                );
              },
            ),
          ),
          // 分页器
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  movies.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 15),
                    width: currentIndex == index ? 30 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? const Color(0xFFffb43b)
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class _BuildMovieDetailBody extends StatelessWidget {
//   final Movie movie;
//   const _BuildMovieDetailBody({super.key, required this.movie});

// }

class _BuildMovieDetailBody extends StatefulWidget {
  final Movie movie;
  const _BuildMovieDetailBody({super.key, required this.movie});

  @override
  State<_BuildMovieDetailBody> createState() => __BuildMovieDetailBodyState();
}

class __BuildMovieDetailBodyState extends State<_BuildMovieDetailBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1c1c27),
      appBar: AppBar(
        forceMaterialTransparency: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Movie Detail",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 290,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Hero(
                      tag: widget.movie.poster,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.network(
                          widget.movie.poster,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MovieInfo(
                          icon: Icons.videocam_rounded,
                          name: "Genera",
                          value: widget.movie.genre,
                        ),
                        const MovieInfo(
                          icon: Icons.timer,
                          name: "Duration",
                          value: '2002-02-20',
                        ),
                        MovieInfo(
                          icon: Icons.star,
                          name: "Rating",
                          value: "${widget.movie.rating}/10",
                        )
                      ],
                    )
                  ],
                ),
              ),
              _buildBorder(context),
              Column(
                children: [
                  ...List.generate(
                    numRow.length,
                    (colIndex) {
                      int numCol =
                          colIndex == 0 || colIndex == numRow.length - 1
                              ? 6
                              : 8;
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: colIndex == numRow.length - 1 ? 0 : 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(numCol, (rowIndex) {
                              // 设置作为编号
                              String seatNum =
                                  '${numRow[colIndex]}${rowIndex + 1}';
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedSeats.contains(seatNum)) {
                                      selectedSeats.remove(seatNum);
                                    } else if (!reservedSeats
                                        .contains(seatNum)) {
                                      selectedSeats.add(seatNum);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  // 如果rowIndex等于一般的numCol那么就设置右边距为30
                                  margin: EdgeInsets.only(
                                      right: rowIndex == (numCol / 2) - 1
                                          ? 30
                                          : 10),
                                  decoration: BoxDecoration(
                                    color: reservedSeats.contains(seatNum)
                                        ? Colors.white
                                        : selectedSeats.contains(seatNum)
                                            ? const Color(0xFFffb43b)
                                            : const Color(0xFF373741),
                                    borderRadius: BorderRadius.circular(7.5),
                                  ),
                                ),
                              );
                            })
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.white.withOpacity(0.1),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Synopsis",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.movie.synopsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                        height: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xff1c1c27),
              blurRadius: 60,
              spreadRadius: 80,
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          onPressed: () {},
          label: MaterialButton(
            onPressed: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            color: const Color(0xFFffb43b),
            height: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: const Center(
                child: Text(
                  "Get Reservation",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBorder(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            width: MediaQuery.of(context).size.width - 50,
            height: 50,
            child: ClipPath(
              clipper: ClipBorder(),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFffb43b).withOpacity(0.3),
                      Colors.transparent,
                    ],
                    stops: const [
                      0.35,
                      1,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 35,
            width: MediaQuery.of(context).size.width - 50,
            // height: 50,
            child: ClipPath(
              clipper: ClipShadow(),
              child: Container(
                height: 50,
                width: double.infinity,
                color: const Color(0xFFffb43b),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ClipBorder extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // 将裁剪的点移动到 0, size.height - 30的点上面
    // path.moveTo(0, size.height);
    // 将当前的点（0, size.height - 30）移动到 0, size.height 的点上面 用一条直线连接
    path.lineTo(0, size.height);
    // 将当前的点（0, size.height）移动到 size.width, size.height 的点上面 用一条直线连接
    path.lineTo(size.width, size.height);
    // 将当前的点（size.width, size.height）移动到 size.width, size.height - 30 的点上面 用一条直线连接
    path.lineTo(size.width, size.height - 10);
    // 圆滑过度 将开始点（size.width / 2, -20）和结束点（0, size.height - 30）连接起来 进行圆滑过度
    path.quadraticBezierTo(size.width / 2, -40, 0, size.height - 10);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ClipShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 2, -20, size.width, size.height);
    path.lineTo(size.width, size.height - 6);
    path.quadraticBezierTo(size.width / 2, -25, 0, size.height - 5);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MovieInfo extends StatelessWidget {
  final IconData icon;
  final String name, value;
  const MovieInfo({
    super.key,
    required this.icon,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      width: 102,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1.5,
          color: Colors.white12,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            name,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
