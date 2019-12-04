//
//  RollbarRequest.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import "HttpMethod.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarRequest : DataTransferObject
// Can contain any arbitrary keys. Rollbar understands the following:

// url: full URL where this event occurred
@property (nonatomic, copy) NSString *url;

// method: the request method
@property (nonatomic) HttpMethod method;

// headers: object containing the request headers.
// Header names should be formatted like they are in HTTP.
@property (nonatomic, strong) NSDictionary *headers;

// params: any routing parameters (i.e. for use with Rails Routes)
@property (nonatomic, strong) NSDictionary *params;

// GET: query string params
@property (nonatomic, strong) NSDictionary *getParams;

// query_string: the raw query string
@property (nonatomic, copy) NSString *queryString;

// POST: POST params
@property (nonatomic, strong) NSDictionary *postParams;

// body: the raw POST body
@property (nonatomic, copy) NSString *postBody;

// user_ip: the user's IP address as a string.
// Can also be the special value "$remote_ip", which will be replaced with the source IP of the API request.
// Will be indexed, as long as it is a valid IPv4 address.
@property (nonatomic, copy) NSString *userIP;

@end

NS_ASSUME_NONNULL_END
