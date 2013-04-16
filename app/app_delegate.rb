class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    @todos_controller = TodosController.alloc.initWithNibName(nil, bundle:nil)

    @window.rootViewController =
      UINavigationController.alloc.initWithRootViewController(@todos_controller)
    
    @window.makeKeyAndVisible 
    
    true
  end
end