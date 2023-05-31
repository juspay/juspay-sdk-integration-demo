// Should be called in onDestroy.
// Activity being destroyed must be passed as argument
// SDK will use this to determine, whether the current held activity is the one being destroyed
hyper.resetActivity(activity)