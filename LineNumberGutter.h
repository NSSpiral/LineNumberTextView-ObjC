#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

/// Defines the width of the gutter view.
static const CGFloat GUTTER_WIDTH = 40.0;

/// Adds line numbers to an NSTextField.
@interface LineNumberGutter : NSRulerView

/// Holds the background color.
@property (nonatomic, strong) NSColor *backgroundColor;

/// Holds the text color.
@property (nonatomic, strong) NSColor *foregroundColor;

/// Initializes a LineNumberGutter with the given attributes.
/// @param textView NSTextView to attach the LineNumberGutter to.
/// @param foregroundColor Defines the foreground color.
/// @param backgroundColor Defines the background color.
/// @return An initialized LineNumberGutter object.
- (instancetype)initWithTextView:(NSTextView *)textView foregroundColor:(NSColor *)foregroundColor backgroundColor:(NSColor *)backgroundColor;

/// Initializes a default LineNumberGutter, attached to the given textView.
/// Default foreground color: hsla(0, 0, 0, 0.55);
/// Default background color: hsla(0, 0, 0.95, 1);
/// @param textView NSTextView to attach the LineNumberGutter to.
/// @return An initialized LineNumberGutter object.
- (instancetype)initWithTextView:(NSTextView *)textView;

@end

NS_ASSUME_NONNULL_END
