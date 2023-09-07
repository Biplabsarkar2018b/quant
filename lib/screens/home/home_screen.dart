import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/api/news_repo.dart';
import 'package:quant/commons/snackbar.dart';
import 'package:quant/controllers/news_controller.dart';
import 'package:quant/screens/home/news_model.dart';
import 'package:quant/screens/search/search_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ref.read(newsControllerProvider.notifier).getData();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        ref.read(newsControllerProvider.notifier).getData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void gotoSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchScreen(
          query: _searchController.text.toLowerCase(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final newss = ref.watch(newsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'SocialX',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                  hintText: 'Search in Feed',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.red,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      gotoSearchPage();
                    },
                    child: Icon(
                      Icons.done,
                      color: Colors.red,
                    ),
                  )),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: newss.length,
              itemBuilder: (context, index) {
                if (index < newss.length) {
                  return newsCard(newss[index]);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget newsCard(NewsArticle article) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Set to MainAxisSize.min
              children: [
                Row(
                  children: [
                    Flexible(
                        child: Text(
                      article.publishedAt.length > 9
                          ? article.publishedAt
                              .substring(11, article.publishedAt.length - 1)
                          : '', // Show the rest of the text after skipping the first 9 characters
                      overflow: TextOverflow.ellipsis,
                    )),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                        child: Text(
                      article.author,
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
                Wrap(
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 21,
                          // height: 1,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Wrap(children: [
                  Text(
                    article.description,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ],
            ),
          ),
          SizedBox(
            width: 80,
            child: FadeInImage(
              placeholder:
                  AssetImage('assets/picture.png'), // Placeholder image
              image: NetworkImage(article.urlToImage),
              imageErrorBuilder: (context, error, stackTrace) {
                // This callback is called when an error occurs while loading the image
                // You can return a widget to display instead of the image, for example, an error icon
                return Icon(
                    Icons.error); // Replace with your error handling widget
              },
            ),
          ),
        ],
      ),
    );
  }
}
