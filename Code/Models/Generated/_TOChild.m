// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TOChild.m instead.

#import "_TOChild.h"

const struct TOChildAttributes TOChildAttributes = {
	.birthdate = @"birthdate",
	.name = @"name",
};

const struct TOChildRelationships TOChildRelationships = {
};

const struct TOChildFetchedProperties TOChildFetchedProperties = {
};

@implementation TOChildID
@end

@implementation _TOChild

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TOChild" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TOChild";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TOChild" inManagedObjectContext:moc_];
}

- (TOChildID*)objectID {
	return (TOChildID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic birthdate;






@dynamic name;











@end
