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
@synthesize UpdateFrequency;
@synthesize EnableCatchTimer;


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
        orderedKeys = [[NSMutableArray alloc] initWithCapacity:[designerValues count]];
        orderedValues = [[NSMutableArray alloc] initWithCapacity:[designerValues count]];
        
        
        for (NSDictionary *dict in designerValues){
            [orderedKeys addObject:[dict objectForKey:@"key"]];
            [orderedValues addObject:[dict objectForKey:@"value"]];
        }
        
        self.temp  = [[NSDictionary alloc] initWithObjects:orderedValues forKeys:orderedKeys];
        self.FloaterCombined = [[temp objectForKey:@"FloaterCombinedTotal"] intValue];
        self.MaximumYaw = [[temp objectForKey:@"MaximumYaw"] floatValue];
        self.MinimumYaw = [[temp objectForKey:@"MinimumYaw"] floatValue];
        self.UpdateFrequency = [[temp objectForKey:@"UpdateFrequency"] floatValue];
        self.EnableCatchTimer =  [[temp objectForKey:@"EnableCatchTimer"] floatValue];
        
        catchableSprites = [[NSMutableArray alloc] init];
        
		return self;
	}
}

- (int)getFloaterCombined
{
	@synchronized(self) {
        
		return self.FloaterCombined;
	}	
}

- (float)getMaximumYaw
{
	@synchronized(self) {
        
		return self.MaximumYaw;
	}	
    
}

- (float)getMinimumYaw
{
	@synchronized(self) {
		return  self.MinimumYaw;
	}	
    
}

- (float)getUpdateFrequency
{
    @synchronized(self) {
		return  self.UpdateFrequency;
	}	
    
}
- (float)getEnableCatchTimer
{
    @synchronized(self) {
		return  self.EnableCatchTimer;
	}	

}


@end
