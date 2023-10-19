componentDidMount() {
    ...
    const eventEmitter = new NativeEventEmitter(NativeModules.HyperSdkReact);
    this.eventListener = eventEmitter.addListener('HyperEvent', (resp) => {
      var data = JSON.parse(resp);
      var event: string = data.event || '';
      switch (event) {
        case 'show_loader':
          // show some loader here
          break;
        case 'hide_loader':
          // hide the loader
          break;
        case 'initiate_result':
          var payload = data.payload || {};
          console.log('initiate_result: ', payload);
          // merchant code
          ...
          break;
        case 'process_result':
          var payload = data.payload || {};
          console.log('process_result: ', payload);
          // merchant code
          ...
          break;
        default:
          console.log('Unknown Event', data);
      }
      ...
    });
    ...
  }
  componentWillUnmount() {
    ...
    this.eventListener.remove();
    ...
  }