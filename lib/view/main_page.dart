import 'package:flutter/material.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
class main_page extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<main_page> with SingleTickerProviderStateMixin {
double size  =10;
  bool _isSearchActive = false;
  int _currentIndex = 0;
  int _currentIndex2 = 0;
  bool _isPlaying = false;
  double _sliderValue= 0;
  List<String> _songNames = List.generate(50, (index) => 'Song $index');
  List<String> _artistNames = List.generate(50, (index) => 'Artist $index');
  String _selectedSongName = 'Song 0';
  String _selectedArtistName = 'Artist 0';
  late AnimationController _controller;
  late Animation<double> _animation;

bool like = false;

  @override
  void initState() {
    super.initState();
   // _requestPermissions(context);
    _scanFiles();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

  }

/*
void _requestPermissions(BuildContext context) async {
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Permission is granted, navigate to the main screen
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => main_page(),
    ));
  } else if (status.isDenied) {
    // Permission is denied
    // You may want to show a dialog or message to the user informing them of the requirement for the permission
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('This app requires storage permission to function properly.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Open app settings so the user can manually grant the permission
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  } else if (status.isPermanentlyDenied) {
    // Permission is permanently denied
    // You may want to inform the user that the app won't function without the permission and direct them to settings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('This app requires storage permission to function properly. Please grant the permission in the app settings.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Open app settings so the user can manually grant the permission
              openAppSettings();
            },
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

*/

@override
  void dispose() {
    _controller.dispose();
    super.dispose();

  }


void _scanFiles() async {
  // Function to scan audio files with .mp3 extension
  List<FileSystemEntity> files = [];
  try {
    files = await _listFiles(); // Get list of files
    for (FileSystemEntity file in files) {
      if (file.path.endsWith('.mp3')) {
        // If file is mp3, add it to the list
        _songNames.add(file.path.split('/').last); // File name
        _artistNames.add("Unknown"); // Default artist name
      }
    }
  } catch (e) {
    print("Error scanning files: $e");
  }
  setState(() {}); // Update UI
}


Future<List<FileSystemEntity>> _listFiles() async {
  // Function to list all files in the device
  List<FileSystemEntity> files = [];
  try {
    files = await _listFilesInDirectory(Directory('/')); // Scan root directory
  } catch (e) {
    print("Error listing files: $e");
  }
  return files;
}


Future<List<FileSystemEntity>> _listFilesInDirectory(
    Directory dir) async {
  // Recursive function to list all files in a directory and its subdirectories
  List<FileSystemEntity> files = [];
  try {
    List<FileSystemEntity> entities = dir.listSync();
    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        files.add(entity); // Add file to list
      } else if (entity is Directory) {
        files.addAll(await _listFilesInDirectory(entity)); // Recursive call for directories
      }
    }
  } catch (e) {
    print("Error listing files in directory ${dir.path}: $e");
  }

  print(files);
  return files;
}

Future<void> _requestExternalStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    // Permission is granted, you can now access external storage
    // Perform your file operations here
  } else {
    // Permission is not granted, handle it accordingly
  }
}




  @override
  Widget build(BuildContext context) {
    Widget _buildIcon(IconData icon, int index) {
      if (index == 2) {
        return Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.pink,
          ),
          child: Icon(icon, color: Colors.white),
        );
      } else {
        return AnimatedBuilder(
          animation: _animation,
         builder: (context, child) {
           return
                // Adjust Y position based on animation value
          Container(
             padding: EdgeInsets.only(bottom: 2),
             decoration: BoxDecoration(
               border: Border(
                 bottom: BorderSide(
                   color: _currentIndex == index ? Colors.pink : Colors
                       .transparent,

                   width: 2,
                 ),
               ),
             ),
             child: Icon(icon, color: Colors.white),
           );
         },

        );
      }
    }

    BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon,
        int index) {
      return BottomNavigationBarItem(
        backgroundColor: Colors.black,
        icon: _buildIcon(icon, index),
        label: '',
      );
    }

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'ALL SONGS',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Geometr231 Hv BT',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              _showNewDribblePage();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(

            children: [
              Expanded(

                child: ListView.builder(
                  itemCount: _songNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: InkWell(
                        onTap: () {
                          _togglePlayPause(index);
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.pink,
                          ),
                          child: Center(
                            child: Icon(
                              _currentIndex == index && _isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: _currentIndex == index
                                  ? Colors.pink
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        _songNames[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        _artistNames[index],
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        '00:00',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _isSearchActive = false;
                          _selectedSongName = _songNames[index];
                          _selectedArtistName = _artistNames[index];
                          _currentIndex = index;
                        });
                      },
                    );
                  },
                ),

              ),


SizedBox(height: 80,),


              if (_isSearchActive)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        textInputAction: TextInputAction.search,
                        onSubmitted: (value) {
                          setState(() {
                            _isSearchActive = false;
                          });
                          _performSearch(value);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _isSearchActive = false;
                              });
                              _performSearch('');
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),


            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: _showDribblePage,
              onVerticalDragUpdate: (details) {
                if (details.delta.dy < -6) {
                  _showDribblePage();
                }
              },
              child: Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/music_logo.png',
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedSongName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _selectedArtistName,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex2,
        onTap: _onItemTapped,
        items: [
          _buildBottomNavigationBarItem(Icons.home, 0),
          _buildBottomNavigationBarItem(Icons.search, 1),
          _buildBottomNavigationBarItem(Icons.speaker, 2),
          _buildBottomNavigationBarItem(Icons.podcasts, 3),
          _buildBottomNavigationBarItem(Icons.settings, 4),
        ],
      ),
    );
  }

  void _togglePlayPause(int index) {
    setState(() {
      if (_currentIndex == index) {
        _isPlaying = !_isPlaying;
      } else {
        _currentIndex = index;
        _isPlaying = true;
        _selectedSongName = _songNames[index];
        _selectedArtistName = _artistNames[index];
      }
    });
  }

  void _performSearch(String query) {
    print('Performing search with query: $query');
    // Implement your search logic here
    // Update the UI with search results
  }


void _showDribblePage() {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      'Now Playing',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.white),
                      onPressed: () {
                        // Add your search functionality here
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Changed background color to white
                    ),
                    child: Center(
                      child: Icon(Icons.music_note, size: 80, color: Colors.black), // Changed icon color to black
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text(_selectedSongName, style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(_selectedArtistName, style: TextStyle(fontSize: 14, color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            like = !like;
                          });
                        },
                        icon: like ? Icon(Icons.favorite, color: Colors.red) : Icon(Icons.favorite_outline, color: Colors.white),
                      ),
                      Text('Follow', style: TextStyle(color: Colors.white)), // Added text behind the heart icon
                      IconButton(
                        icon: Icon(Icons.shuffle, color: Colors.pink),
                        onPressed: () {
                          // Add functionality for shuffle action
                        },
                      ),
                      Text('Shuffle', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      // Calculate the new value based on the drag movement
                      double newValue = _sliderValue + details.delta.dx / 200;
                      // Ensure the new value stays within the valid range
                      newValue = newValue.clamp(0.0, 1.0);
                      // Update the slider value
                      setState(() {
                        _sliderValue = newValue;
                        Navigator.pop(context);
                        _showDribblePage();

                      });

                    },
                    child: Slider(
                      value: _sliderValue,
                      onChanged: (newValue) {
                        // Update the slider value when it's changed through dragging
                        setState(() {
                          _sliderValue = newValue;

                          Navigator.pop(context);
                          _showDribblePage();
                        });
                      },
                      min: 0,
                      max: 1,
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('0:00', style: TextStyle(color: Colors.white)),
                      Text('3:30', style: TextStyle(color: Colors.white)), // Example duration, replace with actual duration
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: IconButton(
                          icon: Icon(Icons.skip_previous, color: Colors.white),
                          onPressed: () {
                            // Add functionality for previous song action
                          },
                        ),
                      ),
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: IconButton(
                          // The icon displayed depends on the value of _isPlaying
                          icon: _isPlaying ? Icon(Icons.play_arrow, color: Colors.black) : Icon(Icons.pause, color: Colors.black), // Play icon if _isPlaying is true
                          iconSize: 40, // Size of the icon
                          onPressed: () {
                            // onPressed callback, triggered when the button is pressed
                            setState(() {
                              // Toggle the value of _isPlaying when the button is pressed
                              _isPlaying = !_isPlaying;
                              Navigator.pop(context);
                              _showDribblePage();

                            });
                          },

                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        child: IconButton(
                          icon: Icon(Icons.skip_next, color: Colors.white),
                          onPressed: () {
                            // Add functionality for next song action
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(), // Spacer
            ],
          ),
        );
      },
    ),
  );
}




void _showNewDribblePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text('Search'),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search',

                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'No data',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        // If the "Home" item is tapped, do nothing as we are already on the same page
        return;
      } else if (_currentIndex == 1) {
        // If the "Search" item is tapped, show the search page
        _showNewDribblePage();
      } else if (_currentIndex == 2) {
        // If the "Listen" item is tapped, navigate to the Dribble page
      //  _requestPermissions(context);
        _navigateToDribblePage();

      } else {
        if (_currentIndex == 3) {
          // If the "Listen" item is tapped, navigate to the Dribble page
Navigator.push(context, MaterialPageRoute(builder: (context) {
return Scaffold(
backgroundColor: Colors.transparent,
  appBar: AppBar( backgroundColor: Colors.black,title: Text("Podcast",style: TextStyle(color: Colors.white),),leading: IconButton(onPressed: () {
Navigator.pop(context);
  },icon: Icon(Icons.arrow_back_rounded,color: Colors.white),)),



);
},));
        }
        else
          {
            if (_currentIndex == 4) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Scaffold(
                  backgroundColor: Colors.black,
                  appBar: AppBar( backgroundColor: Colors.black,title: Text("Settings",style: TextStyle(color: Colors.white),),leading: IconButton(onPressed: () {
                    Navigator.pop(context);
                  },icon: Icon(Icons.arrow_back_rounded,color: Colors.white),)),



                );
              },));

            }


          }
      }
    });
  }

  void _navigateToDribblePage() {
    // Navigate to the New Dribble Page
    _showDribblePage();
  }
}



