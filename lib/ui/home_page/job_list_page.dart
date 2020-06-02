import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:codexp_inapporpriate_name/ui/home_page/skill_card.dart';
import 'package:codexp_inapporpriate_name/ui/job_detail_page/job_detail.dart';
import 'package:codexp_inapporpriate_name/ui/models/job.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'job_card.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({Key key}) : super(key: key);

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  List<Job> _job = List();
  List<Job> _jobListDisplay = List();

  void filterSearchResults(String query) {
    List<Job> dummySearchList = List<Job>();
    dummySearchList.addAll(_job);
    if (query.isNotEmpty) {
      List<Job> dummyListData = List<Job>();
      dummySearchList.forEach((item) {
        if (item.jobTitle.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _job.clear();
        _job.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _job.clear();
        _job.addAll(dummySearchList);
      });
    }
  }

  void initState() {
    _job.add(Job(
        jobTitle: "Flutter Engineer",
        companyName: "Flutter",
        location: "Central, Singapore",
        jobType: "Engineer",
        closingDate: DateTime.parse("2020-10-20")));
    _job.add(Job(
        jobTitle: "Website Engineer",
        companyName: "Flutter",
        location: "East, Singapore",
        jobType: "Engineer",
        closingDate: DateTime.parse("2020-10-20")));
    _job.add(Job(
        jobTitle: "Facebook Manager",
        companyName: "Flutter",
        location: "Singapore",
        jobType: "Engineer",
        closingDate: DateTime.parse("2020-10-20")));
    _job.add(Job(
        jobTitle: "Account Manager",
        companyName: "Flutter",
        location: "Singapore",
        jobType: "Engineer",
        closingDate: DateTime.parse("2020-10-20")));
    _job.add(Job(
        jobTitle: "Senior Consultant",
        companyName: "Flutter",
        location: "Singapore",
        jobType: "Engineer",
        closingDate: DateTime.parse("2020-10-20")));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    @override
    void updateSearchQuery(String newQuery) {
      setState(() {
        searchQuery = newQuery;
      });
    }

    Widget _buildSearchField() {
      return TextField(
        controller: _searchQueryController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Search Data...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.white30),
        ),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
        onChanged: (query) => filterSearchResults(query),
      );
    }

    void _clearSearchQuery() {
      setState(() {
        _searchQueryController.clear();
        updateSearchQuery("");
      });
    }

    List<Widget> _buildActions() {
      if (_isSearching) {
        return <Widget>[
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              if (_searchQueryController == null ||
                  _searchQueryController.text.isEmpty) {
                Navigator.pop(context);
                return;
              }
              _clearSearchQuery();
            },
          ),
        ];
      }

      void _stopSearching() {
        _clearSearchQuery();

        setState(() {
          _isSearching = false;
        });
      }

      void _startSearch() {
        ModalRoute.of(context)
            .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

        setState(() {
          _isSearching = true;
        });
      }

      return <Widget>[
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
      ];
    }

    void _onTap(Job job) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => JobDetailPage(job: job)));
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: _isSearching ? const BackButton() : Container(),
          title: _isSearching ? _buildSearchField() : Text("Job Listings"),
          actions: _buildActions(),
        ),
        body: AnimationLimiter(
          child: Container(
            child: ListView.builder(
              itemCount: _job.length,
              itemBuilder: (BuildContext context, int index) {
                return JobCard(
                    job: _job[index], callback: () => _onTap(_job[index]));
              },
            ),
          ),
        ));
  }
}
