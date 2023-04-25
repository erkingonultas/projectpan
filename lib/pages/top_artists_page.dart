import 'package:flutter/material.dart';
import 'package:projectpan/backend/constants.dart';
import 'package:projectpan/backend/models/tag_topartists_model.dart';

class TopArtistsPage extends StatelessWidget {
  const TopArtistsPage({Key? key, required this.genre, required this.artistList}) : super(key: key);

  final String genre;
  final List<Artist> artistList;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    botticelli,
                    // Colors.white,
                    ebonyclay,
                  ],
                  stops: [0.00, 1.00],
                ),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: size.height * .45,
                  leading: const BackButton(color: botticelli),
                  pinned: false,
                  floating: false,
                  centerTitle: true,
                  toolbarHeight: 110,
                  title: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Top Trending\n',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: botticelli),
                        ),
                        TextSpan(
                          text: genre.toUpperCase(),
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: botticelli),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  flexibleSpace: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.passthrough,
                      children: [
                        Image.network(artistList[0].image![3].text!, fit: BoxFit.cover),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                woodsmoke.withOpacity(.4),
                                // Colors.white,
                                woodsmoke.withOpacity(.55),
                              ],
                              stops: const [0.0, 1.0],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * .6,
                                  child: Text(
                                    '#1 ${artistList[0].name!}',
                                    style: const TextStyle(fontSize: 24, color: botticelli, fontWeight: FontWeight.w500, letterSpacing: 3),
                                  ),
                                ),
                                Image.asset(
                                  'assets/img/Lastfm_logo.svg.png',
                                  height: 25,
                                  width: 75,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 45,
                  ).copyWith(top: 25),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(artistList[1].image![1].text!, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: size.width * .35,
                              child: Text(
                                artistList[1].name!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: botticelli,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '#2',
                              style: TextStyle(
                                fontSize: 14,
                                color: botticelli,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(artistList[2].image![1].text!, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: size.width * .35,
                              child: Text(
                                artistList[2].name!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: botticelli,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '#3',
                              style: TextStyle(
                                fontSize: 14,
                                color: botticelli,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(artistList[3].image![1].text!, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: size.width * .35,
                              child: Text(
                                artistList[3].name!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: botticelli,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '#4',
                              style: TextStyle(
                                fontSize: 14,
                                color: botticelli,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 35),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(artistList[4].image![1].text!, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: size.width * .35,
                              child: Text(
                                artistList[4].name!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: botticelli,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              '#5',
                              style: TextStyle(
                                fontSize: 14,
                                color: botticelli,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 75,
                  ).copyWith(top: 0),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: woodsmoke,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('LOAD MORE', style: TextStyle(color: botticelli, fontWeight: FontWeight.w100), textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
