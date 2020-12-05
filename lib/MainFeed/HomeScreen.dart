import 'package:flutter/material.dart';
import 'package:unihub/MainFeed/CreatePost.dart';
import 'package:unihub/MainFeed/Home.dart';

import 'Account.dart';
import 'Explore.dart';
import 'Learn.dart';
import 'Notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  final Set<StatefulWidget> lists = {
    Notifications(),
    Learn(),
    Account(),
    Home()
  };
  Widget currentScreen = Home();
  final PageStorageBucket bucket = new PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
            child: Icon(currentTab == 4 ? Icons.explore : Icons.explore_outlined, color: currentTab == 4 ? Color.fromRGBO(34, 167, 240, 1) : Colors.black, size: 30),
            onTap: () {
              setState(() {
                currentTab = 4;
                currentScreen = Explore();
              });
            },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          RotatedBox(
            quarterTurns: -1,
            child: Icon(Icons.toll, color: Colors.black, size: 30),
          )
        ],
        title: currentTab == 5 ? Text("") : Text(
          "UNIHUB",
          style: TextStyle(
              fontSize: 25,
              fontFamily: "Sen",
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: PageStorage(
          child: currentScreen,
          bucket: bucket,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "create",
        backgroundColor: Colors.white,
        onPressed: () {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreatePost()));
          });
        },
        child: Icon(
          Icons.blur_on,
          color:
              currentTab == 5 ? Color.fromRGBO(34, 167, 240, 1) : Colors.black,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = Home();
                    currentTab = 0;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currentTab == 0 ? Icons.home : Icons.home_outlined,
                      color: currentTab == 0
                          ? Color.fromRGBO(34, 167, 240, 1)
                          : Colors.black,
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                          color: currentTab == 0
                              ? Color.fromRGBO(34, 167, 240, 1)
                              : Colors.black,
                          fontFamily: "Sen",
                          fontSize: 10),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = Notifications();
                    currentTab = 1;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currentTab == 1
                          ? Icons.disc_full
                          : Icons.disc_full_outlined,
                      color: currentTab == 1
                          ? Color.fromRGBO(34, 167, 240, 1)
                          : Colors.black,
                    ),
                    Text(
                      "Notifications",
                      style: TextStyle(
                          color: currentTab == 1
                              ? Color.fromRGBO(34, 167, 240, 1)
                              : Colors.black,
                          fontFamily: "Sen",
                          fontSize: 10),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = Learn();
                    currentTab = 2;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currentTab == 2 ? Icons.school : Icons.school_outlined,
                      color: currentTab == 2
                          ? Color.fromRGBO(34, 167, 240, 1)
                          : Colors.black,
                    ),
                    Text(
                      "Learn",
                      style: TextStyle(
                          color: currentTab == 2
                              ? Color.fromRGBO(34, 167, 240, 1)
                              : Colors.black,
                          fontFamily: "Sen",
                          fontSize: 10),
                    )
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    currentScreen = Account();
                    currentTab = 3;
                  });
                },
                minWidth: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      currentTab == 3 ? Icons.person : Icons.person_outlined,
                      color: currentTab == 3
                          ? Color.fromRGBO(34, 167, 240, 1)
                          : Colors.black,
                    ),
                    Text(
                      "Account",
                      style: TextStyle(
                          color: currentTab == 3
                              ? Color.fromRGBO(34, 167, 240, 1)
                              : Colors.black,
                          fontFamily: "Sen",
                          fontSize: 10),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
