//
//  DesignValues.m
//  AR_SpaceShip
//
//  Created by Zelin Ou on 8/26/11.
//  Copyright (c) 2011 iTeam. All rights reserved.
//

#import "DesignValues.h"
#import "DesignerValuesTableView.h"
#import "NSString+SBJSON.h"
#import "NSObject+SBJSON.h"

static DesignValues *sharedDesignValues = nil;

@implementation DesignValues
@synthesize temp;
@synthesize orderedKeys;
@synthesize orderedValues;
@synthesize catchableSprites;
@synthesize FloaterCombined;
@synthesize MaximumYaw;
@synthesize MinimumYaw;

@synthesize temp;

+(DesignValues *)sharedDesignValues
{
	@synchronized (self) {
		if (sharedDesignValues == nil) {
			[[self alloc] init]; // assignment not done here, see allocWithZone
		}
	}
	
	return sharedDesignValues;

}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (sharedDesignValues == nil) {
            sharedDesignValues = [super allocWithZone:zone];
            return sharedDesignValues;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  // This is sooo not zero
}

- (id)init
{
	@synchronized(self) {
		[super init];	
        
        NSString *responseString = [NSString stringWithContentsOfFile:[DesignerValuesTableView designerPath] encoding:NSUTF8StringEncoding error:nil];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        responseString = [responseString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        
        NSDictionary *jsonData = [responseString JSONValue];
        
        NSArray *designerValues = [jsonData valueForKey:@"designerValues"];
        NSMutableArray *orderedKeys = [[NSMutableArray alloc] initWithCapacity:[designerValues count]];
        NSMutableArray *orderedValues = [[NSMutableArray alloc] initWithCapacity:[designerValues count]];
        
        
        for (NSDictionary *dict in designerValues){
            [orderedKeys addObject:[dict objectForKey:@"key"]];
            [orderedValues addObject:[dict objectForKey:@"value"]];
        }
        
<<<<<<< .mine
        self.temp  = [[NSDictionary alloc] initWithObjects:orderedValues forKeys:orderedKeys];        
=======
        self.temp  = [[NSDictionary alloc] initWithObjects:orderedValues forKeys:orderedKeys];
        self.FloaterCombined = [[temp objectForKey:@"FloaterCombinedTotal"] intValue];
        self.MaximumYaw = [[temp objectForKey:@"MaximumYaw"] floatValue];
        self.MinimumYaw = [[temp objectForKey:@"MinimumYaw"] floatValue];
        
>>>>>>> .r249
        catchableSprites = [[NSMutableArray alloc] init];
        
		return self;
	}
}

- (int)getFloaterCombined
{
	@synchronized(self) {

<<<<<<< .mine
		return [[self.temp objectForKey:@"FloaterCombinedTotal"] intValue];
=======
		return self.FloaterCombined;
>>>>>>> .r249
	}	
}

- (float)getMaximumYaw
{
	@synchronized(self) {

<<<<<<< .mine
		return [[self.temp objectForKey:@"MaximumYaw"] floatValue];
=======
		return self.MaximumYaw;
>>>>>>> .r249
	}	

}

- (float)getMinimumYaw
{
	@synchronized(self) {
<<<<<<< .mine
		return [[self.temp objectForKey:@"MinimumYaw"] floatValue];
=======
		return  self.MinimumYaw;
>>>>>>> .r249
	}	

}

@end
