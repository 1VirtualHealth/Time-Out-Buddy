#import "TOChild.h"

@implementation TOChild


- (NSInteger)ageInYears
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:[NSDate date] toDate:self.birthdate options:0];
    return [dateComponents year];
}


@end
