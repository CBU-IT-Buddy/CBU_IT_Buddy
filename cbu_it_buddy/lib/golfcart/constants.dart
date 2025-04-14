const gameWidth = 1500.0;
const gameHeight = 1920.0;
const leftBound = -(gameWidth / 2);
const rightBound = gameWidth / 2;
const topBound = -(gameHeight / 2);
const bottomBound = gameHeight / 2;

const playerDelta = 2000.0;
const maxPlayerMoveSpeed = 2500.0; // Maximum speed limit for player movement
const speed1 = 22.0;
const speed2 = 30.0;
const speed3 = 37.0;
const obstacleSpeed1 = speed1 * 29.8; // scuffed same as background
const obstacleSpeed2 = speed2 * 29.8;
const obstacleSpeed3 = speed3 * 29.8;

const lane1 = -290.0;
const lane2 = 21.0;
const lane3 = 333.0;

const List<double> lanes = [lane1, lane2, lane3];