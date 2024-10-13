import 'package:dynamic_theme_flutter/dynamic_theme_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';


import '../commoms/default_row.dart';
import '../controllers/controller.dart';
import 'package:example/src/module/charters_models/characters_model.dart';


class CastPage extends StatefulWidget {
  final DynamicThemeManager themeManager;

  const CastPage({super.key, required this.themeManager});

  @override
  State<CastPage> createState() => _CastPageState();
}

class _CastPageState extends State<CastPage> {
  final TextEditingController _searchController = TextEditingController();
  List<CharactersModel> displayedItems = [];

  final _controller = FinalSpaceController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      displayedItems = _controller.characters
          .where((item) =>
          item.name!.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characters'),
        centerTitle: true,
        backgroundColor: widget.themeManager.currentTheme!.primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Observer(
            builder: (context) {
              return AnimatedBuilder(
                builder: (context,_) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _searchController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      FutureBuilder<List<CharactersModel>>(
                        future: _controller.getCharacters(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _controller.characters = snapshot.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _searchController.text.isEmpty ? _controller.characters.length :displayedItems.length,
                              itemBuilder: (context, index) {
                                final character = _searchController.text.isEmpty ?_controller.characters[index]: displayedItems[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _controller.selectedIndex = index;
                                    });
                                    dialog();
                                  },
                                  child: Container(
                                    height: 150,
                                    margin: EdgeInsets.symmetric(horizontal: 8, vertical:8),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.secondaryContainer,
                                      border: Border.all(width: 1, color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 130,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(18),
                                            image: DecorationImage(
                                              image: NetworkImage(character.img_url ??
                                                  "https://finalspaceapi.com/api/character/avatar/time_swap_sammy.jpg"),
                                              fit: BoxFit.cover,
                                            ),
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Container(
                                            width: 180,
                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                DefaultRow(name: character.name ??"NULL", label: 'Name : ', fontSize: 13, fontSize2: 13,),
                                                SizedBox(height: 6),
                                                DefaultRow(name: character.status??"NULL", label: 'Status : ', fontSize: 13, fontSize2: 13,),
                                                SizedBox(height: 6),
                                                DefaultRow(name: character.gender??"NULL", label: 'Gender : ', fontSize: 13, fontSize2: 13),
                                                SizedBox(height: 6),
                                                DefaultRow(name: character.species ?? "NULL", label: 'Species : ', fontSize: 13, fontSize2: 13,),
                                                SizedBox(height: 6),
                                                DefaultRow(name: character.hair ?? "Null", label: 'Hair : ', fontSize: 13, fontSize2: 13,),
                                                SizedBox(height: 6),
                                                DefaultRow(name: character.origin ?? "Null", label: 'Origin : ', fontSize: 13, fontSize2: 13),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
                    ],
                  );
                }, animation: widget.themeManager,
              );
            }
        ),
      ),
    );
  }
  Future dialog(){
    return  showDialog(
        context: context,
        builder: (BuildContext context)
        {
          var name = _searchController.text.isEmpty ?_controller.characters[_controller.selectedIndex]:displayedItems[_controller.selectedIndex];
          return AlertDialog(
            title: Center(
              child: Text(name.name!,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    width: 600,
                    decoration:BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(width: 1,color: Colors.grey.shade300),
                        image: DecorationImage(image: NetworkImage(name.img_url??""),
                            fit:BoxFit.cover )
                    ) ,
                  ),
                  SizedBox(height: 30,),
                  // DefaultRow(name: _controller.characters[_controller.selectedIndex].name ??"NULL", label: 'Name : ', fontSize: 14.sp, fontSize2: 16.sp,),
                  // SizedBox(height: 6.h),
                  DefaultRow(name: name.status??"NULL", label: 'Status : ', fontSize: 14, fontSize2: 14,),
                  SizedBox(height: 6),
                  DefaultRow(name: name.gender??"NULL", label: 'Gender : ', fontSize: 14, fontSize2: 14,),
                  SizedBox(height: 6),
                  DefaultRow(name: name.species ?? "NULL", label: 'Species : ', fontSize: 14, fontSize2: 14,),
                  SizedBox(height: 6),
                  DefaultRow(name: name.hair ?? "Null", label: 'Hair : ', fontSize: 14, fontSize2: 14,),
                  SizedBox(height: 6),
                  DefaultRow(name: name.origin ?? "Null", label: 'Origin : ', fontSize: 14, fontSize2: 14,),
                  SizedBox(height: 12),
                  Text("Abilities : ",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900]),),
                  SizedBox(height: 2),
                  list(name.abilities!,),
                  SizedBox(height: 12),
                  Text("Alias : ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[900]),),
                  SizedBox(height: 2),
                  list(name.alias!,),

                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget list(List listname){
    return  Container(
      // color: Colors.red,
      height: 130,
      width: 400,
      child: ListView.builder(
          padding:EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: listname.length,
          itemBuilder: (context,index){
            var names = listname[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700]),),
                SizedBox(height: 2),
              ],
            );

          }),);
  }
}