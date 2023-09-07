import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant/commons/snackbar.dart';

import '../../controllers/news_controller.dart';
import '../home/news_model.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String query;
  const SearchScreen({super.key, required this.query});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // ref.read(newsControllerProvider.notifier).getSearchData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Perform your task here
      ref
          .read(newsControllerProvider.notifier)
          .getSearchData(query: widget.query);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void gotoSearchPage() {}

  @override
  Widget build(BuildContext context) {
    final newss = ref.watch(newsControllerProvider);
    print(widget.query);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'SearchX',
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
                      // gotoSearchPage();
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
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }
}
