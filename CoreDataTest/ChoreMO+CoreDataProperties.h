//
//  ChoreMO+CoreDataProperties.h
//  CoreDataTest
//
//  Created by Yang Liu on 2016-03-23.
//  Copyright © 2016 Macula Soft. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChoreMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChoreMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *choreName;
@property (nullable, nonatomic, retain) NSSet<ChoreLogMO *> *choreLog;

@end

@interface ChoreMO (CoreDataGeneratedAccessors)

- (void)addChoreLogObject:(ChoreLogMO *)value;
- (void)removeChoreLogObject:(ChoreLogMO *)value;
- (void)addChoreLog:(NSSet<ChoreLogMO *> *)values;
- (void)removeChoreLog:(NSSet<ChoreLogMO *> *)values;

@end

NS_ASSUME_NONNULL_END
