#import "UISearchBar+PlaceholderColor.h"

@implementation UISearchBar (PlaceholderColor)
    
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    UILabel *labelView = [self searchBarTextFieldLabelFromView:self];
    [labelView setTextColor:placeholderColor];
}
    
- (UILabel *)searchBarTextFieldLabelFromView:(UIView *)view {
    for (UIView *v in [view subviews]) {
        if ([v isKindOfClass:[UILabel class]]) {
            return (UILabel *)v;
        }
        
        UIView *labelView = [self searchBarTextFieldLabelFromView:v];
        if (labelView) {
            return (UILabel *)labelView;
        }
    }
    
    return nil;
}
    
    @end
