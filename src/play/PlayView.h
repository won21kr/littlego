// -----------------------------------------------------------------------------
// Copyright 2011 Patrick Näf (herzbube@herzbube.ch)
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


// System includes
#import <UIKit/UIKit.h>

// Forward declarations
@class PlayViewModel;
@class GoPoint;


// -----------------------------------------------------------------------------
/// @brief The PlayView class is a custom view that is responsible for drawing
/// a Go board.
///
/// The view content is drawn in layers:
/// - View background
/// - Board background
/// - Grid lines
/// - Star points
/// - Played stones (if any)
/// - Symbols (if any)
/// - Coordinate labels (if any)
///
/// In addition, PlayView writes text into a status line and animates an
/// activity indicator, to provide the user with feedback about operations
/// that are currently going on.
///
/// All coordinate calculations are made with integer types. The actual drawing
/// then uses a half pixel "translation" to prevent anti-aliasing when straight
/// lines are drawn. See http://stackoverflow.com/questions/2488115/how-to-set-up-a-user-quartz2d-coordinate-system-with-scaling-that-avoids-fuzzy-dr
/// for details.
///
/// @note It's not possible to turn off anti-aliasing, instead of doing
/// half-pixel translation. The reason is that 1) round shapes (e.g. star
/// points, stones) do need anti-aliasing; and 2) if not all parts of the view
/// are drawn with anti-aliasing, things become mis-aligned (e.g. stones are
/// not exactly centered on line intersections).
///
/// @note All calculations rely on the coordinate system origin being in the
/// top-left corner.
///
/// @note All methods that require a view update should invoke delayedUpdate()
/// instead of setNeedsDisplay() so that multiple updates can be coalesced into
/// a single update, after one or more long-running actions have finished.
// -----------------------------------------------------------------------------
@interface PlayView : UIView
{
}

+ (PlayView*) sharedView;
- (GoPoint*) crossHairPointAt:(CGPoint)coordinates;
- (void) moveCrossHairTo:(GoPoint*)point isLegalMove:(bool)isLegalMove;
- (GoPoint*) pointAt:(CGPoint)coordinates;
- (void) actionStarts;
- (void) actionEnds;

/// @brief The status line GUI control.
@property(nonatomic, retain) IBOutlet UILabel* statusLine;
/// @brief The activity indicator.
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;

/// @name Cross-hair point properties
//@{
@property(retain) GoPoint* crossHairPoint;
@property bool crossHairPointIsLegalMove;
//@}

/// @name Update optimizing
//@{
/// @brief Number of "expensive" actions that are currently in progress. View
/// updates are delayed while this number is >0.
@property int actionsInProgress;
/// @brief Is true if updates were delayed because @e actionsInProgress was >0.
@property bool updatesWereDelayed;
//@}

@end
