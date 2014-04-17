class TodosController < UITableViewController

  def viewDidLoad
    super
    self.title = "Okonawa"

    @todos = []

    add_todo_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_todo')
    log_out_button = UIBarButtonItem.alloc.initWithTitle("Logout", style: UIBarButtonItemStyleBordered, target:self, action:'logout')

    self.navigationItem.rightBarButtonItem = add_todo_button
    self.navigationItem.leftBarButtonItem = log_out_button
    self.navigationController.navigationBar.translucent = false unless RUBYMOTION_ENV == 'test'

    self.tableView.addPullToRefreshWithActionHandler(
      Proc.new do
        load_todos(true)
      end
    )
  end

  def viewDidAppear(animated)
    display_login unless (User.current_user || RUBYMOTION_ENV == 'test')
    load_todos if User.current_user
  end

  #
  # tableView implementation
  #

  def tableView(tableView, numberOfRowsInSection: section)
    @todos.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.textLabel.text = @todos[indexPath.row].name
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell.styleClass = 'table-cell'
    cell
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    select_row(tableView, indexPath) unless RUBYMOTION_ENV == 'test'
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    select_row(tableView, indexPath) unless RUBYMOTION_ENV == 'test'
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      todo = @todos[indexPath.row]
      todo.deleteInBackground
      @todos.delete(todo)
      refresh_display
    end
  end

  def refresh_display
    self.tableView.reloadData
  end

  #
  # Todo's Management
  #

  def load_todos(stop_animation = false)
    Dispatch::Queue.concurrent.async do
      query = Todo.query
      query.whereKey('owner', equalTo: User.current_user.username)
      @todos = query.find

      Dispatch::Queue.main.sync do
        refresh_display
        tableView.pullToRefreshView.stopAnimating if stop_animation
      end
    end
  end

  def add_todo
    todo = Todo.new
    todo.name = 'New Todo'
    todo.details = ''
    todo.due_date = NSDate.new.to_f
    todo.done = false
    todo.owner = RUBYMOTION_ENV != 'test' ? User.current_user.username : 'testuser'

    edit_todo(todo) unless RUBYMOTION_ENV == 'test'

    todo
  end

  def add_todo_row(todo)
    @todos << todo
    row = @todos.size - 1
    path = NSIndexPath.indexPathForRow(row, inSection:0)

    self.tableView.insertRowsAtIndexPaths([path], withRowAnimation:UITableViewRowAnimationRight)
  end

  def select_row(tableView, indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    todo = @todos[indexPath.row]
    edit_todo(todo)
  end

  def edit_todo(todo)
    todo_controller = TodoController.new(todo)
    self.navigationController.pushViewController(todo_controller, animated: true)
  end

  def refresh_row_for(todo)
    row = @todos.index(todo)
    path = NSIndexPath.indexPathForRow(row, inSection:0)
    self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation:UITableViewRowAnimationAutomatic)
  end

  #
  # Authentication
  #

  def logInViewController(logIn, didLogInUser:user)
    @login.dismissModalViewControllerAnimated(true)
    load_todos
  end

  def display_login
    @login = PFLogInViewController.new
    @login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton |
                    PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten |
                    PFLogInFieldsFacebook
    @login.delegate = self
    @login.signUpController.delegate = self

    @signup = @login.signUpController

    styles_for_parse

    self.presentModalViewController(@login, animated:true)
  end

  def logout
    PFUser.logOut
    @todos = []
    refresh_display
    display_login
  end

  private

  def styles_for_parse
    @login.logInView.logo = UIImageView.alloc.initWithImage(UIImage.imageNamed('okonawa.png'))
    @login.logInView.styleId = 'login-view'
    @login.logInView.signUpButton.styleClass = 'button'
    @login.logInView.logInButton.styleClass = 'button'
    @login.logInView.facebookButton.styleClass = 'button'
    @login.logInView.signUpButton.styleId = 'login-signup'
    @login.logInView.logInButton.styleId = 'login-login'
    @login.logInView.facebookButton.styleId = 'login-facebook'

    @login.logInView.passwordForgottenButton.styleClass = 'button'
    @login.logInView.passwordForgottenButton.styleId = 'login-forgot'
    @login.logInView.passwordForgottenButton.setTitle('Forgot?', forState:UIControlStateNormal)
    @login.logInView.passwordForgottenButton.titleLabel.transform = CGAffineTransformMakeRotation( - Math::PI / 2 )
    @login.logInView.passwordForgottenButton.titleLabel.adjustsFontSizeToFitWidth = true
    # @login.logInView.passwordForgottenButton.titleLabel.minimumScaleFactor = 0.3

    @login.logInView.usernameField.styleClass = 'parse-field'
    @login.logInView.usernameField.layer.shadowColor = nil
    @login.logInView.usernameField.layer.shadowOpacity = 0.0
    @login.logInView.usernameField.layer.backgroundColor = UIColor.clearColor
    @login.logInView.usernameField.textColor = UIColor.blackColor

    @login.logInView.passwordField.styleClass = 'parse-field'
    @login.logInView.passwordField.layer.shadowColor = nil
    @login.logInView.passwordField.layer.shadowOpacity = 0.0
    @login.logInView.passwordField.layer.backgroundColor = UIColor.clearColor
    @login.logInView.passwordField.textColor = UIColor.blackColor

    @login.logInView.externalLogInLabel.styleClass = 'parse-label'
    @login.logInView.externalLogInLabel.shadowColor = nil
    @login.logInView.signUpLabel.styleClass = 'parse-label'
    @login.logInView.signUpLabel.shadowColor = nil

    @signup.signUpView.logo = UIImageView.alloc.initWithImage(UIImage.imageNamed('okonawa.png'))
    @signup.signUpView.styleId = 'signup-view'

    @signup.signUpView.usernameField.styleClass = 'parse-field'
    @signup.signUpView.usernameField.layer.shadowColor = nil
    @signup.signUpView.usernameField.layer.shadowOpacity = 0.0
    @signup.signUpView.usernameField.layer.backgroundColor = UIColor.clearColor
    @signup.signUpView.usernameField.textColor = UIColor.blackColor

    @signup.signUpView.passwordField.styleClass = 'parse-field'
    @signup.signUpView.passwordField.layer.shadowColor = nil
    @signup.signUpView.passwordField.layer.shadowOpacity = 0.0
    @signup.signUpView.passwordField.layer.backgroundColor = UIColor.clearColor
    @signup.signUpView.passwordField.textColor = UIColor.blackColor

    @signup.signUpView.emailField.styleClass = 'parse-field'
    @signup.signUpView.emailField.layer.shadowColor = nil
    @signup.signUpView.emailField.layer.shadowOpacity = 0.0
    @signup.signUpView.emailField.layer.backgroundColor = UIColor.clearColor
    @signup.signUpView.emailField.textColor = UIColor.blackColor

    @signup.signUpView.signUpButton.styleClass = 'button'
    @signup.signUpView.signUpButton.styleId = 'signup-signup'
  end

end
