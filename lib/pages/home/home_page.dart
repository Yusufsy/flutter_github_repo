import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_github_rest/components/repo_container.dart';
import 'package:flutter_github_rest/components/search_bar.dart';
import 'package:flutter_github_rest/usecases/launch_url.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map? users;
  String resultsText = "Begin search";
  bool _isLoading = false;
  List userRepo = [];
  late final LaunchUrl openRepo;
  final TextEditingController _searchCtrl = TextEditingController();

  void _userSearch(String q) async {
    var url = Uri.parse(
        'https://api.github.com/search/users?q=$q'); //Search api query does not return repo count
    var response = await http.get(url);
    var responseBody = json.decode(response.body);
    if (responseBody!['total_count'] == null ||
        responseBody!['total_count'] == 0) {
      setState(() {
        responseBody = null;
        resultsText = "No results";
        _isLoading = false;
      });
    } else {
      users = responseBody;
      List temp = [];
      for (var user in responseBody!['items']) {
        var repoUrl = Uri.parse(
            'https://api.github.com/users/${user["login"]}'); //Fetching repo number separately
        var repoUrlResponse = await http.get(repoUrl);
        Map repoUrlResponseBody = json.decode(repoUrlResponse.body);
        print(repoUrlResponseBody);
        temp.add(repoUrlResponseBody['public_repos']);
        setState(() {
          userRepo = temp;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SearchBar(
                  onChanged: (v) {
                    setState(() {
                      _isLoading = true;
                    });
                    _userSearch(v);
                  },
                  searchCtrl: _searchCtrl),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (users == null
                        ? Center(
                            child: Text(
                              resultsText,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Text(
                                '${users!['total_count']} users found',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.height * 0.9,
                                height:
                                    MediaQuery.of(context).size.height * 0.66,
                                child: ListView.builder(
                                  itemCount: userRepo.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Center(
                                      child: RepoContainer(
                                          avatarUrl: users!['items'][index]
                                              ['avatar_url'],
                                          userName: users!['items'][index]
                                              ['login'],
                                          repoNum: userRepo[index],
                                          launchUrl: () async {
                                            await openRepo.launchUrlRepo(
                                                users!['items'][index]
                                                    ['repos_url']);
                                          }),
                                    );
                                  },
                                ),
                              )
                            ],
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
