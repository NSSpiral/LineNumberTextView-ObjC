
#import "LineNumberGutter.h"

#define GUTTER_WIDTH 40.0

@implementation LineNumberGutter

- (instancetype)initWithTextView:(NSTextView *)textView foregroundColor:(NSColor *)foregroundColor backgroundColor:(NSColor *)backgroundColor {
    self = [super initWithScrollView:textView.enclosingScrollView orientation:NSVerticalRuler];

    if (self) {
        // Set the color preferences.
        [self setBackgroundColor:backgroundColor];
        [self setForegroundColor:foregroundColor];

        // Set the rulers clientView to the supplied textview.
        self.clientView = textView;
        // Define the ruler's width.
        self.ruleThickness = GUTTER_WIDTH;
    }

    return self;
}

- (instancetype)initWithTextView:(NSTextView *)textView {
    NSColor *foregroundColor = [NSColor labelColor];
    NSColor *backgroundColor = [NSColor clearColor];

    return [self initWithTextView:textView foregroundColor:foregroundColor backgroundColor:backgroundColor];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void) setBackgroundColor:(NSColor *) color {
    _backgroundColor = color;
    self.needsDisplay = YES;
}

- (void) setForegroundColor:(NSColor *) color {
    _foregroundColor = color;
    self.needsDisplay = YES;
}

- (void)drawHashMarksAndLabelsInRect:(NSRect)rect {
    // Set the current background color...
    [NSColor.clearColor set];
    // ...and fill the given rect.
    [NSBezierPath fillRect:rect];

    // Unwrap the clientView, the layoutManager and the textContainer, since we'll
    // use them sooner or later.
    NSTextView *textView = (NSTextView *)self.clientView;
    NSLayoutManager *layoutManager = textView.layoutManager;
    NSTextContainer *textContainer = textView.textContainer;

    if (!textView || !layoutManager || !textContainer) {
        return;
    }

    NSString *content = textView.string;

    // Get the range of the currently visible glyphs.
    NSRange visibleGlyphsRange = [layoutManager glyphRangeForBoundingRect:textView.visibleRect inTextContainer:textContainer];

    // Check how many lines are out of the current bounding rect.
    NSUInteger lineNumber = 1;

    @try {
        // Define a regular expression to find line breaks.
        NSRegularExpression *newlineRegex = [NSRegularExpression regularExpressionWithPattern:@"\n" options:0 error:nil];
        // Check how many lines are out of view; From the glyph at index 0
        // to the first glyph in the visible rect.
        lineNumber += [newlineRegex numberOfMatchesInString:content options:0 range:NSMakeRange(0, visibleGlyphsRange.location)];
    } @catch (NSException *exception) {
        return;
    }

    // Get the index of the first glyph in the visible rect, as a starting point...
    NSUInteger firstGlyphOfLineIndex = visibleGlyphsRange.location;

    // ...then loop through all visible glyphs, line by line.
    while (firstGlyphOfLineIndex < NSMaxRange(visibleGlyphsRange)) {
        // Get the character range of the line we're currently in.
        NSRange charRangeOfLine = [content lineRangeForRange:NSMakeRange([layoutManager characterIndexForGlyphAtIndex:firstGlyphOfLineIndex], 0)];
        // Get the glyph range of the line we're currently in.
        NSRange glyphRangeOfLine = [layoutManager glyphRangeForCharacterRange:charRangeOfLine actualCharacterRange:nil];

        NSUInteger firstGlyphOfRowIndex = firstGlyphOfLineIndex;
        NSUInteger lineWrapCount = 0;

        // Loop through all rows (soft wraps) of the current line.
        while (firstGlyphOfRowIndex < NSMaxRange(glyphRangeOfLine)) {
            // The effective range of glyphs within the current line.
            NSRange effectiveRange = NSMakeRange(0, 0);
            // Get the rect for the current line fragment.
            NSRect lineRect = [layoutManager lineFragmentRectForGlyphAtIndex:firstGlyphOfRowIndex effectiveRange:&effectiveRange withoutAdditionalLayout:YES];

            // Draw the current line number;
            // When lineWrapCount > 0 the current line spans multiple rows.
            if (lineWrapCount == 0) {
                [self drawLineNumberWithNumber:lineNumber atYPosition:NSMinY(lineRect)];
            } else {
                break;
            }

            // Move to the next row.
            firstGlyphOfRowIndex = NSMaxRange(effectiveRange);
            lineWrapCount += 1;
        }

        // Move to the next line.
        firstGlyphOfLineIndex = NSMaxRange(glyphRangeOfLine);
        lineNumber += 1;
    }

    // Draw another line number for the extra line fragment.
    if (layoutManager.extraLineFragmentTextContainer) {
        [self drawLineNumberWithNumber:lineNumber atYPosition:NSMinY(layoutManager.extraLineFragmentRect)];
    }
}

- (void) drawLineNumberWithNumber:(NSInteger)num atYPosition:(CGFloat)yPos {
    // Unwrap the text view.
    NSTextView *textView = (NSTextView *)self.clientView;
    NSFont *font = textView.font;

    if (!textView || !font) {
        return;
    }

    // Define attributes for the attributed string.
    NSDictionary *attrs = @{NSFontAttributeName: font, NSForegroundColorAttributeName: self.foregroundColor};
    // Define the attributed string.
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)num] attributes:attrs];
    // Get the NSZeroPoint from the text view.
    NSPoint relativePoint = [self convertPoint:NSZeroPoint fromView:textView];
    // Calculate the x position, within the gutter.
    CGFloat xPosition = GUTTER_WIDTH - ([attributedString size].width + 5);
    // Draw the attributed string to the calculated point.
    [attributedString drawAtPoint:NSMakePoint(xPosition, relativePoint.y + yPos + 1)];
}

@end
