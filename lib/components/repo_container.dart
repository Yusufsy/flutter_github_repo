import 'package:flutter/material.dart';

class RepoContainer extends StatefulWidget {
  const RepoContainer(
      {Key? key,
      required this.avatarUrl,
      required this.userName,
      this.repoNum,
      required this.launchUrl})
      : super(key: key);
  final String avatarUrl;
  final String userName;
  final int? repoNum;
  final VoidCallback launchUrl;

  @override
  State<RepoContainer> createState() => _RepoContainerState();
}

class _RepoContainerState extends State<RepoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(50.0),
            child: Image.network(
              widget.avatarUrl,
              height: 80,
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
          Column(
            children: [
              Text(widget.userName),
              widget.repoNum != null
                  ? InkWell(
                      onTap: widget.launchUrl,
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue),
                          child: Center(
                            child: Text(
                              "${widget.repoNum} repositories",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          )))
                  : const Text("No repositories"),
            ],
          ),
        ],
      ),
    );
  }
}
