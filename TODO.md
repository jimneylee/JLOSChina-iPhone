

AFXMLRequestOperation add
- (NSXMLParser *)responseXMLParser {
    if (!_responseXMLParser && [self.responseData length] > 0 && [self isFinished]) {
        NSString* responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
        self.responseXMLParser = [[NSXMLParser alloc] initWithData:self.responseData];
    }
    
    return _responseXMLParser;
}

//<oschina>
//  <result>
//      <errorCode>1</errorCode>
//      <errorMessage><![CDATA[登录成功]]></errorMessage>
//  </result>
//  <user>
//      <uid>121801</uid>
//      <location><![CDATA[江苏 常州]]></location>
//      <name><![CDATA[jimney]]></name>
//      <followers>0</followers>
//      <fans>0</fans>
//      <score>1</score>
//      <portrait>http://static.oschina.net/uploads/user/60/121801_100.jpg?t=1355965412000</portrait>
//  </user>
//  <notice>
//      <atmeCount>0</atmeCount>
//      <msgCount>0</msgCount>
//      <reviewCount>0</reviewCount>
//      <newFansCount>0</newFansCount>
//  </notice>
//</oschina>