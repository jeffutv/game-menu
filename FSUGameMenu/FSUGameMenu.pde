PFont font, listFont, titleFont;
File gamesPath;
String gamePath;
String[] gamesRaw;
String[] games;
String[] gameTitles;
String[] gameDescriptions;
String[] gameCredits;
PImage[] gameScreenshots;
String enterKeys = "12ZGzg";
//String enterKeys = "123456CZTIKGFQcztikgfq";

int selectedGame = 0;
int gamesCount = 0;
String title = "Game Design at Fitchburg State";
String error = "No Games Installed";
String suffix = ".exe";
String dbFile;
boolean launching = false;

void setup() {
  fullScreen();
  //size(960, 540);

  // Set Platform
  String os = System.getProperty("os.name");
  if (os.indexOf("Mac") >= 0) suffix = ".app";

  // FONTS SETUP
  font = createFont("fonts/pixelmix.ttf", 20);
  titleFont = createFont("fonts/ka1.ttf", 64);
  listFont = createFont("fonts/8-BIT WONDER.TTF", 32);

  // GAMES SETUP
  gamesPath = new File(sketchPath("Games"));
  gamesRaw = gamesPath.list();

  // Count number of games in the directory; ignore ".DS_Store" and "thumbs_db"
  if (gamesRaw != null) {
    for (int i=0; i<gamesRaw.length; i++) {
      if (gamesRaw[i].indexOf(".DS_Store") == -1 && gamesRaw[i].indexOf("thumbs") == -1) {
        gamesCount ++;
      }
    }
  println("gamesCount: " + gamesCount);

  // copy actual games into new String[]
  games = new String[gamesCount];
  int j = 0;
  for (int i=0; i<gamesRaw.length; i++) {
    if (gamesRaw[i].indexOf(".DS_Store") == -1 && gamesRaw[i].indexOf("thumbs") == -1) {
      games[j] = gamesRaw[i];
      j++;
    }
  }

  println(games);
  loadGamesData();
  }
}

void loadGamesData() {
  println("loadGamesData();");
  gameTitles = new String[gamesCount];
  gameDescriptions = new String[gamesCount];
  gameCredits = new String[gamesCount];
  gameScreenshots = new PImage[gamesCount];

  for (int i=0; i<gamesCount; i++) {
    println("games[" + i + "] " + games[i]);
    gamePath = "games/" + games[i] + "/";

    // Load Info
    String loadedInfo[] = loadStrings(gamePath + "info.txt");
    gameTitles[i] = loadedInfo[0];
    gameDescriptions[i] = loadedInfo[1];
    gameCredits[i] = "";
    for (int j=2; j<loadedInfo.length; j++) {
      gameCredits[i] += "\n" + loadedInfo[j];
      //if (j < loadedInfo.length - 1) gameCredits[i] += "\n";
    }
    gameDescriptions[i] += "\n" + gameCredits[i];

    // Load Screenshot
    PImage img = loadImage(gamePath + "screenshot.png");
    gameScreenshots[i] = img;


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
  }
}


void draw() {
  background(45, 195, 233);
  fill(255);

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
  image(gameScreenshots[selectedGame], 800, 180, 800, 450);
  textFont(font);
  text(gameDescriptions[selectedGame], 800, 640, 800, 450);
}

void keyPressed() {
  //launch(dataPath("ClickTest.app"));
  if (keyCode == DOWN || keyCode == RIGHT || key == 's' || key == 'S' || key == 'd' || key == 'D') {
    launching = false;
    selectedGame ++;
    if (selectedGame >= gamesCount) selectedGame = 0;
  }
  if (keyCode == UP || keyCode == LEFT || key == 'w' || key == 'W' || key == 'a' || key == 'A') {
    launching = false;
    selectedGame --;
    if (selectedGame < 0) selectedGame = gamesCount - 1;
  }
  if (keyCode == ENTER || keyCode == RETURN || enterKeys.indexOf(key) >= 0) {
    if (!launching) {
      launching = true;
      launch(dataPath("games/" + games[selectedGame] + "/" + games[selectedGame] + suffix));
    }
  }
}
