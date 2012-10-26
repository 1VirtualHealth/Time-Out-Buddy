// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TOChild.h instead.

#import <CoreData/CoreData.h>


extern const struct TOChildAttributes {
	__unsafe_unretained NSString *birthdate;
	__unsafe_unretained NSString *name;
} TOChildAttributes;

extern const struct TOChildRelationships {
} TOChildRelationships;

extern const struct TOChildFetchedProperties {
} TOChildFetchedProperties;





@interface TOChildID : NSManagedObjectID {}
@end

@interface _TOChild : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (TOChildID*)objectID;




@property (nonatomic, strong) NSDate* birthdate;


//- (BOOL)validateBirthdate:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString* name;


//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;






@end

@interface _TOChild (CoreDataGeneratedAccessors)

@end

@interface _TOChild (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveBirthdate;
- (void)setPrimitiveBirthdate:(NSDate*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




@end
