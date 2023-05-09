/**
Checks if current sdk instance has been initialised.
*/
public boolean isInitialised;


//Example usage
if (hyperServices.isInitialised()) {
    hyperServices.process(processPayload);
} else {
  //Intialise hyperInstance
}