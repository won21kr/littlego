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
#import "BackupGameCommand.h"
#import "../../gtp/GtpCommand.h"


// -----------------------------------------------------------------------------
/// @brief Class extension with private methods for BackupGameCommand.
// -----------------------------------------------------------------------------
@interface BackupGameCommand()
- (void) dealloc;
@end


@implementation BackupGameCommand


// -----------------------------------------------------------------------------
/// @brief Initializes a BackupGameCommand object.
///
/// @note This is the designated initializer of BackupGameCommand.
// -----------------------------------------------------------------------------
- (id) init
{
  // Call designated initializer of superclass (CommandBase)
  self = [super init];
  if (! self)
    return nil;

  return self;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this BackupGameCommand object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// @brief Executes this command. See the class documentation for details.
// -----------------------------------------------------------------------------
- (bool) doIt
{
  // Secretly and heinously change the working directory so that the .sgf
  // file goes to a directory that the user cannot look into
  BOOL expandTilde = YES;
  NSArray* paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, expandTilde);
  NSString* appSupportDirectory = [paths objectAtIndex:0];
  NSFileManager* fileManager = [NSFileManager defaultManager];
  NSString* oldCurrentDirectory = [fileManager currentDirectoryPath];
  [fileManager changeCurrentDirectoryPath:appSupportDirectory];

  NSString* commandString = [NSString stringWithFormat:@"savesgf %@", sgfBackupFileName];
  GtpCommand* command = [GtpCommand command:commandString];
  command.waitUntilDone = true;
  [command submit];

  // Switch back to the original directory
  [fileManager changeCurrentDirectoryPath:oldCurrentDirectory];

  return true;
}

@end
