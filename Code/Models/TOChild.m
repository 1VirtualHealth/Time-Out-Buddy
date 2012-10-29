#import "TOChild.h"

@implementation TOChild


- (NSInteger)ageInYears
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:self.birthdate toDate:[NSDate date] options:0];
    return [dateComponents year];
}


@end
