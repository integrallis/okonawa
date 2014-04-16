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
    self.presentModalViewController(@login, animated:true)
  end

  def logout
    PFUser.logOut
    @todos = []
    refresh_display
    display_login
  end

end
