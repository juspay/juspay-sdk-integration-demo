/**
Checks if current sdk instance has been initialised..
*/
- (Boolean)isInitialised;

//Example usage
if ([hyperInstance isInitialised]) {
    [hyperInstance process:processPayload];
} else {
  //Intialize hyperInstance
}