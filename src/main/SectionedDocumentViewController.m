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
#import "SectionedDocumentViewController.h"
#import "DocumentViewController.h"
#import "ApplicationDelegate.h"
#import "../utility/DocumentGenerator.h"
#import "../ui/TableViewCellFactory.h"
#import "../ui/UiUtilities.h"


// -----------------------------------------------------------------------------
/// @brief Class extension with private methods for
/// SectionedDocumentViewController.
// -----------------------------------------------------------------------------
@interface SectionedDocumentViewController()
/// @name Initialization and deallocation
//@{
- (void) dealloc;
//@}
/// @name UIViewController methods
//@{
- (void) viewDidLoad;
- (void) viewDidUnload;
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
//@}
/// @name UITableViewDataSource protocol
//@{
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView;
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section;
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section;
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath;
//@}
/// @name UITableViewDelegate protocol
//@{
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
//@}
/// @name Private helpers
//@{
- (void) viewSectionAtIndexPath:(NSIndexPath*)indexPath;
//@}
/// @name Privately declared properties
//@{
@property(nonatomic, retain) DocumentGenerator* documentGenerator;
//@}
@end


@implementation SectionedDocumentViewController

@synthesize contextTabBarItem;
@synthesize documentGenerator;


// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this SectionedDocumentViewController
/// object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  self.documentGenerator = nil;
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// @brief Called after the controller’s view is loaded into memory, usually
/// to perform additional initialization steps.
// -----------------------------------------------------------------------------
- (void) viewDidLoad
{
  [super viewDidLoad];

  ApplicationDelegate* appDelegate = [ApplicationDelegate sharedDelegate];
  NSInteger tabType = self.contextTabBarItem.tag;
  NSString* resourceName = [appDelegate resourceNameForTabType:tabType];
  NSString* resourceContent = [appDelegate contentOfTextResource:resourceName];
  switch (tabType)
  {
    case TabTypeManual:
      self.documentGenerator = [[[DocumentGenerator alloc] initWithFileContent:resourceContent] autorelease];
      break;
    default:
      assert(0);
      self.documentGenerator = nil;
      return;
  }
}

// -----------------------------------------------------------------------------
/// @brief Called when the controller’s view is released from memory, e.g.
/// during low-memory conditions.
///
/// Releases additional objects (e.g. by resetting references to retained
/// objects) that can be easily recreated when viewDidLoad() is invoked again
/// later.
// -----------------------------------------------------------------------------
- (void) viewDidUnload
{
  [super viewDidUnload];
  self.documentGenerator = nil;
}

// -----------------------------------------------------------------------------
/// @brief Called by UIKit at various times to determine whether this controller
/// supports the given orientation @a interfaceOrientation.
// -----------------------------------------------------------------------------
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return [UiUtilities shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
  return [self.documentGenerator numberOfGroups];
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.documentGenerator numberOfSectionsInGroup:section];
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
  return [self.documentGenerator titleForGroup:section];
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  UITableViewCell* cell = [TableViewCellFactory cellWithType:DefaultCellType tableView:tableView];
  cell.textLabel.text = [self.documentGenerator titleForSection:indexPath.row inGroup:indexPath.section];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDelegate protocol method.
// -----------------------------------------------------------------------------
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  [self viewSectionAtIndexPath:indexPath];
}

// -----------------------------------------------------------------------------
/// @brief Displays DocumentViewController with the content of the section at
/// index position @a sectionIndex.
// -----------------------------------------------------------------------------
- (void) viewSectionAtIndexPath:(NSIndexPath*)indexPath
{
  NSString* sectionTitle = [self.documentGenerator titleForSection:indexPath.row inGroup:indexPath.section];
  NSString* sectionContent = [self.documentGenerator contentForSection:indexPath.row inGroup:indexPath.section];
  DocumentViewController* controller = [DocumentViewController controllerWithTitle:sectionTitle htmlString:sectionContent];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
