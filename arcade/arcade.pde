PFont font, listFont, titleFont;

// NEW NAMING -- ONLY USING STRING FOR FILES
File path;
String[] gameFolders;
String[] gameFiles;
String[] gameTitles;
String[] gameDescriptions;
PImage[] gameImages;

PImage defaultImage;
String defaultDescription = "Press Button 1 to play";


String enterKeys = " 12456789ZzXxCcVvBb";
String prevKeys = "SsDd";
String nextKeys = "WwAa";

int cooldown = 0;

int selectedGame = 0;
int gamesCount = 0;
String title = "Game Design at Fitchburg State";
String error = "No Games Installed";
String description = "";
String suffix = ".app";
String connector = "/";
String dbFile;
boolean launching = false;

// OLD NOMENCLATURE USING FILE & STRING TOGETHER?????
//File gamesPath;
//File[] gameFolders;
//String gamePath;
//String[] gamesRaw;
//String[] games;
//File[] gameFiles;
////String[] gameCredits;
//PImage[] gameScreenshots;


void setup() {
  //fullScreen();
  size(1920, 1080);
  noCursor();
  
  // Set Platform
  //String os = System.getProperty("os.name");
  //if (os.indexOf("Mac") >= 0) suffix = ".app";
  if (platform == WINDOWS) {
    suffix = ".app";
    connector = "\";
  }

  // FONTS SETUP
  font = createFont("fonts/pixelmix.ttf", 20);
  titleFont = createFont("fonts/ka1.ttf", 64);
  listFont = createFont("fonts/8-BIT WONDER.TTF", 32);

  // GAMES PATH
  path = new File (sketchPath("games"));

  defaultImage = loadImage(sketchPath() + "screenshot.png");

  String[] gamesRaw = path.list();
  gameFolders = new String[0];
  println("game folders raw: " + gamesRaw.length);

  // Count number of game folders in the directory; ignore ".DS_Store" and "thumbs_db"
  for (int i = 0; i < gamesRaw.length; i++) {
    if (gamesRaw[i].indexOf(".DS_Store") == -1 && 
    gamesRaw[i].indexOf("thumbs") == -1 && 
    gamesRaw[i].indexOf("._") == -1) {
      gamesCount ++;
      gameFolders = append(gameFolders, gamesRaw[i]); // copy into gameFolders array
    }
  }


  //gameFolders = path.list();
  gamesCount = gameFolders.length;
  println("game folders: " + gameFolders.length);
  println("gamesCount: " + gamesCount);

  gameFiles = new String[gamesCount];
  gameTitles = new String[gamesCount];
  gameDescriptions = new String[gamesCount];
  gameImages = new PImage[gamesCount];

  // LOAD GAMES DATA
  for (int i = 0; i < gamesCount; i++) {
    String folderName = gameFolders[i];
    //gameTitles[i] = gameFolders[i];
    //gameDescriptions[i] = defaultDescription;
    //gameImages[i] = defaultImage;
    
    File folder = new File (path + connector + folderName);
    String[] files = folder.list();

    println(i + ". " + folderName);
    //println("# files in " + folderName);
    //printArray(files);

    for (int f = 0; f < files.length; f++) {
      //println(files[f]);

      // IF GAME APP
      if (files[f].endsWith(suffix)) {
        gameFiles[i] = files[f];
      }

      // IF TEXT FILE
      if (files[f].endsWith(".txt")) {
        //println ("loading Title & Description");
        String stringPath = path + "/" + folderName + "/" + files[f];
        //println(files[f] + " string path is " + stringPath);
        File stringFile = new File(stringPath);
        String[] loadedInfo = loadStrings(stringFile);
        //printArray(loadedInfo);
        //println("Title: " + loadedInfo[0]);
        gameTitles[i] = loadedInfo[0];
        gameDescriptions[i] = "";
        for (int d = 1; d < loadedInfo.length; d++) {
          gameDescriptions[i] += "\n" + loadedInfo[d];
        }
      }

      // IF SCREENSHOT
      if (files[f].endsWith(".png") || 
        files[f].endsWith(".PNG") || 
        files[f].endsWith(".jpg") || 
        files[f].endsWith(".JPG")) {
        PImage img = loadImage(path + "/" + folderName + "/" + files[f]);
        gameImages[i] = img;
      }
    }
  }

  println("Game Titles");
  printArray(gameTitles);
}

//void loadGamesDataOld() {
//    // GAMES PATH
//  path = sketchPath("games");
//  gameFolders = listFiles(path);
//  //gamesPath = new File(sketchPath("games"));
//  //gameFolders = listFiles(gamesPath);
//  gamesCount = gameFolders.length;
//  println("gamesCount: " + gamesCount);
//  //gamesRaw = gamesPath.list();

//  //// Count number of game folders in the directory; ignore ".DS_Store" and "thumbs_db"
//  //if (gamesRaw != null) {
//  //  for (int i=0; i<gamesRaw.length; i++) {
//  //    if (gamesRaw[i].indexOf(".DS_Store") == -1 && gamesRaw[i].indexOf("thumbs") == -1 && gamesRaw[i].indexOf("._") == -1) {
//  //      gamesCount ++;
//  //    }
//  //  }
//  //println("gamesCount: " + gamesCount);

//  // copy actual games into new String[]
//  //games = new String[gamesCount];
//  //int j = 0;
//  //for (int i=0; i<gamesRaw.length; i++) {
//  //  if (gamesRaw[i].indexOf(".DS_Store") == -1 && gamesRaw[i].indexOf("thumbs") == -1) {
//  //    games[j] = gamesRaw[i];
//  //    j++;
//  //  }
//  //}

//  //println(games);
//  loadGamesData();
//  //}
//}

//void loadGamesData() {
//println("loadGamesData();");
//gameTitles = new String[gamesCount];
//gameDescriptions = new String[gamesCount];
////gameCredits = new String[gamesCount];
//gameImages = new PImage[gamesCount];

//for (int i = 0; i < gameFolders.length; i++) {
//  //println("games[" + i + "] " + games[i]);
//  //gamePath = gamesPath + games[i];

//  // Load Info
//  // loop through to find first .txt file

//  //String[] filesInPath = new File(gamePath).list();
//  String[] filesInPath = gameFolders[i].list();
//  for (int j=0; j<filesInPath.length; j++) {

//    // IF GAME EXE
//      if (filesInPath[j].indexOf(".app") != -1) {
//      gameFiles[i] = new File(gamePath + filesInPath[j]);
//    }

//    // IF TEXT FILE
//    if (filesInPath[j].indexOf(".txt") != -1) {
//          String loadedInfo[] = loadStrings(filesInPath[j]);
//          gameTitles[i] = loadedInfo[0];
//          gameDescriptions[i] = "";
//          for (int k=1; k<loadedInfo.length; k++) {
//            gameDescriptions[i] += "\n" + loadedInfo[k];
//          }
//       }

//    // IF SCREENSHOT
//      if (filesInPath[j].indexOf(".png") != -1) {
//      PImage img = loadImage(gamePath + filesInPath[j]);
//      gameScreenshots[i] = img;
//    }
//   }




// Ditch separation of Descriptions from Credits
//gameDescriptions[i] = loadedInfo[1];
//gameCredits[i] = "";
//for (int j=2; j<loadedInfo.length; j++) {
//  gameCredits[i] += "\n" + loadedInfo[j];
//  //if (j < loadedInfo.length - 1) gameCredits[i] += "\n";
//}
//gameDescriptions[i] += "\n" + gameCredits[i];

// Load Screenshot
//for (int j=0; j<filesInPath.length; j++) {
//  if (filesInPath[j].indexOf(".png") != -1 && gameScreenshots[i] != null) {
//    PImage img = loadImage(gamePath + filesInPath[j]);
//    gameScreenshots[i] = img;
//  }
//}


// Load Info
//File f = new File(dataPath(gamePath + "info.txt"));
//println(f);
//gameTitles[i] = "";
//gameDescriptions[i] = "";
//gameCredits[i] = "";
//if (f.exists()) {
//  println(f + " exists");
//  String loadedInfo[] = loadStrings(gamePath + "info.txt");
//  if (loadedInfo[0] != null) gameTitles[i] = loadedInfo[0];
//  if (loadedInfo[1] != null) gameDescriptions[i] = loadedInfo[1];
//  for (int j=2; j<loadedInfo.length; j++) {
//    if (loadedInfo[2] != null) gameCredits[i] += "\n" + loadedInfo[j];
//  }
//  //if (j < loadedInfo.length - 1) gameCredits[i] += "\n";
//  gameDescriptions[i] += "\n" + gameCredits[i];
//} else {
//  println(f + " does not exist");
//  gameTitles[i] = games[i];
//}

//// Load Screenshot
//File s = new File(gamePath + "screenshot.png");
//PImage img;
//if (s.exists()) img = loadImage(gamePath + "screenshot.png");
//else img = loadImage("screenshot.png");
//gameScreenshots[i] = img;
//}
//}


void draw() {
  noCursor();
  background(255, 0, 0);
  fill(255);
  
  // if lockedout
  if (launching && millis() > cooldown) {
    launching = false;
  }

  // DRAW BIG TITLE
  textAlign(CENTER, TOP);
  textFont(titleFont);
  text(title, width/2, 20);
  textAlign(LEFT, TOP);
  textFont(listFont);

  // ERROR IF NO GAMES IN FOLDER
  if (gamesCount < 1) {
    text(error, 100, 120, 800, 800);
    return;
  }

  // DRAW LIST OF GAME TITLES
  textFont(font);
  text("Select a Game", 10, 120);
  textFont(listFont);
  for (int i=0; i<gamesCount; i++) {
    String token = "";
    if (i == selectedGame) {
      fill(0);
      token = " ";
    } else fill(255);
    text(token + gameTitles[i], 10, 180 + i*textAscent()*1.5);
  }

  // DRAW TITLE, SCREENSHOT, DESCRIPTION
  fill (0);
  text(gameTitles[selectedGame], 800, 120);
  image(gameImages[selectedGame], 800, 180, 800, 450);
  textFont(font);
  text(gameDescriptions[selectedGame], 800, 640, 800, 450);
}

void updateGameInfo() {
  noCursor();
  launching = false;
  //title = ;
  ////image = gameImages[selectedGame];
  //description = ;
}

void keyPressed() {
  //launch(dataPath("ClickTest.app"));
  
  // Prevent ESC key from quitting
  if (key == ESC) {
    key = 0;
  }
  
  // Next selected game
  if (keyCode == UP || keyCode == LEFT || prevKeys.indexOf(key) >= 0) {
    selectedGame --;
    if (selectedGame < 0) selectedGame = gamesCount - 1;
    updateGameInfo();
  }
  
  // Previous selected game
  if (keyCode == DOWN || keyCode == RIGHT || nextKeys.indexOf(key) >= 0) {
    selectedGame ++;
    if (selectedGame >= gamesCount) selectedGame = 0;
    updateGameInfo();
  }
  
  // Launch this game
  if (key == ENTER || key == RETURN || enterKeys.indexOf(key) >= 0) {
    if (!launching) {
      launching = true;
      cooldown = millis() + 1000;
      String fileToLaunch = path + "/" + gameFolders[selectedGame] + "/" + gameFiles[selectedGame];
      //File launchFile = new File (path + "/" + gameFolders[selectedGame] + "/" + gameFiles[selectedGame] + suffix);
      println("Attempting to launch " + fileToLaunch);
      launch(fileToLaunch);
      //launch(sketchPath("games/" + gameFolders[selectedGame] + "/" + gameFiles[selectedGame] + suffix));
    }
  }
}
