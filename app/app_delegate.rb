class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    Parse.setApplicationId(MY_ENV['parse_app_id'],
                           clientKey: MY_ENV['parse_client_key'])

    PFFacebookUtils.initializeFacebook

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @todos_controller = TodosController.alloc.initWithNibName(nil, bundle:nil)

    @window.rootViewController =
      UINavigationController.alloc.initWithRootViewController(@todos_controller)

    @window.makeKeyAndVisible

    true
  end
end
