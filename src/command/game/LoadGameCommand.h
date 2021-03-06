// -----------------------------------------------------------------------------
// Copyright 2011-2012 Patrick Näf (herzbube@herzbube.ch)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -----------------------------------------------------------------------------


// Project includes
#import "../CommandBase.h"
#import "../../ui/MBProgressHUD.h"

// Forward declarations
@class GtpCommand;
@class Player;


// -----------------------------------------------------------------------------
/// @brief The LoadGameCommand class is responsible for loading a game from an
/// .sgf file and starting a new game using the information in that file.
///
/// The sequence of operations performed by LoadGameCommand is this:
/// - Submit the "loadsgf" GTP command to the GTP engine
/// - Query the GTP engine for the information that was stored in the .sgf file
///   and that is needed to start a new game
/// - Store the information in NewGameModel
/// - Start a new game by executing a NewGameCommand instance
/// - Query the GTP engine for other information that was stored in the .sgf
///   file (handicap, komi, moves)
/// - Setup the game with the information gathered via GTP
/// - Make a backup
/// - Notify observers that a game has been loaded
/// - Trigger the computer player, if it is his turn to move, by executing a
///   ComputerPlayMoveCommand instance
///
/// If the @e waitUntilDone property is set to true (by default it's false), all
/// operations up to, but excluding, "setup the game" will be executed
/// synchronously. Control is returned to the caller as soon as "setup the game"
/// reaches the point where it displays the progress HUD.
///
/// @attention The calling thread therefore must survive long enough for
/// ComputerPlayMoveCommand to complete, otherwise the GTP client will be unable
/// to deliver the GTP response and the application will hang forever.
///
///
/// @par Files with illegal content
///
/// LoadGameCommand performs two kinds of sanitary checks for every move it
/// finds in the .sgf file:
/// - Is the move played by the expected player color?
/// - Is the move legal?
///
/// If any one of these checks fails, the entire load operation fails. A new
/// game is started nonetheless, to bring the app back into a defined state.
///
/// An exception that is raised while the moves in the .sgf file are replayed
/// is caught and handled. The result is the same as if one of the sanitary
/// checks had failed.
// -----------------------------------------------------------------------------
@interface LoadGameCommand : CommandBase <MBProgressHUDDelegate>
{
@private
  enum GoBoardSize m_boardSize;
  NSString* m_handicap;
  NSString* m_komi;
  NSString* m_moves;
  NSString* m_oldCurrentDirectory;
  MBProgressHUD* m_progressHUD;
}

- (id) initWithFilePath:(NSString*)aFilePath gameName:(NSString*)aGameName;

/// @brief Full path to the .sgf file to be loaded.
@property(nonatomic, retain) NSString* filePath;
@property(nonatomic, retain) Player* blackPlayer;
@property(nonatomic, retain) Player* whitePlayer;
@property(nonatomic, retain) NSString* gameName;
/// @brief True if command execution should be synchronous. The default is
/// false.
@property(nonatomic, assign) bool waitUntilDone;
/// @brief True if the command is executed to restore a backup game. False
/// (the default) if the command is executed to load a game from the archive.
@property(nonatomic, assign) bool restoreMode;

@end
