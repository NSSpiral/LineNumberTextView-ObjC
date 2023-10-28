//
//  LineNumberTextView.h
//  Blackb0x IDE
//
//  Created by spiral on 3/10/23.
//

#import <Cocoa/Cocoa.h>
#import "LineNumberGutter.h"

NS_ASSUME_NONNULL_BEGIN


/// Adds line numbers to an NSTextField.
@interface LineNumberTextView : NSTextView

@property (strong, nonatomic) LineNumberGutter *lineNumberGutter;
@property (strong, nonatomic) IBInspectable NSColor *gutterForegroundColor;
@property (strong, nonatomic) IBInspectable NSColor *gutterBackgroundColor;

- (void)drawGutter;

@end

NS_ASSUME_NONNULL_END
