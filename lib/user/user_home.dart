import 'package:flutter/material.dart';

import 'package:labor_managment/constants/colors.dart';
import 'package:labor_managment/model/worker_model.dart';
import 'package:labor_managment/user/workers_list_page.dart';
import 'package:labor_managment/worker/worker_details_page.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<UserHome> {
  bool _isSearching = false;
  List<String> _searchList = [];

  final List<IconData> _jobTypeIcons = [
    Icons.format_paint,
    Icons.child_care,
    Icons.plumbing,
    Icons.cleaning_services,
    Icons.restaurant,
    Icons.electrical_services,
    Icons.fitness_center,
    Icons.security
  ];

  @override
  Widget build(BuildContext context) {
    void _handleCategoryTap(String selectedCategory) {
      Navigator.pushNamed(context, '/workersList',
          arguments: {'jobCategory': selectedCategory});
    }

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search...',
                ),
                autofocus: true,
                style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                    color: black,
                    fontWeight: FontWeight.bold),
                onChanged: (val) {
                  _searchList = WorkerModel.jobTypes
                      .where((job) =>
                          job.toLowerCase().contains(val.toLowerCase()))
                      .toList();
                  setState(() {});
                },
              )
            : const Text(
                'Search',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: black,
                ),
              ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.cancel : Icons.search,
              color: black,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchList.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                ),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: _isSearching
                    ? _searchList.length
                    : WorkerModel.jobTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  final jobType = _isSearching
                      ? _searchList[index]
                      : WorkerModel.jobTypes[index];
                  final icon = _jobTypeIcons[index % _jobTypeIcons.length];
                  return Card(
                    color: Color(0xFF066A75),
                    elevation: 4.0,
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          subtitle: Column(
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Icon(
                                icon,
                                size: 70,
                                color: primaryColor,
                              ),
                            ],
                          ),
                          title: Text(jobType,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold)),
                          onTap: () {
                            _handleCategoryTap(jobType);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
