part of '../pages.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor().white),
        title: Text(
          "Boards",
          style: TextStyle(color: AppColor().white),
        ),
        backgroundColor: AppColor().primary,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColor().white,
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      floatingActionButton: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.add,
          color: AppColor().white,
        ),
        style: IconButton.styleFrom(
          backgroundColor: AppColor().primary,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.only(top: 50),
            child: Column(
              children: [
                Image.asset(
                  AppImages().noBoards,
                  width: 120,
                  height: 120,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Sorry\nYou Don't have any boards",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor().primary,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
