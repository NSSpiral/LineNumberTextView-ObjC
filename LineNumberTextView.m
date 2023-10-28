//
//  LineNumberTextView.m
//  Blackb0x IDE
//
//  Created by spiral on 3/10/23.
//

#import "LineNumberTextView.h"

@implementation LineNumberTextView

- (void)awakeFromNib {
    // Get the enclosing scroll view
    NSScrollView *scrollView = self.enclosingScrollView;
    if (!scrollView) {
        [NSException raise:NSInternalInconsistencyException format:@"Unwrapping the text view's scroll view failed!"];
    }

    NSColor *gutterBG = self.gutterBackgroundColor ?: [NSColor clearColor];
    NSColor *gutterFG = self.gutterForegroundColor ?: [NSColor labelColor];

    self.lineNumberGutter = [[LineNumberGutter alloc] initWithTextView:self foregroundColor:gutterFG backgroundColor:gutterBG];

    scrollView.verticalRulerView = self.lineNumberGutter;
    scrollView.hasHorizontalRuler = NO;
    scrollView.hasVerticalRuler = YES;
    scrollView.rulersVisible = YES;

    [self addObservers];
}

- (void)addObservers {
    self.postsFrameChangedNotifications = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawGutter)
                                                 name:NSViewFrameDidChangeNotification
                                               object:self];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(drawGutter)
                                                 name:NSTextDidChangeNotification
                                               object:self];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)drawGutter {
    if (self.lineNumberGutter) {
        self.lineNumberGutter.needsDisplay = YES;
    }
}

- (void) setGutterForegroundColor:(NSColor *) color {
    self.lineNumberGutter.foregroundColor = color;
}

- (void) setGutterBackgroundColor:(NSColor *) color {
    self.lineNumberGutter.backgroundColor = color;
}


@end
