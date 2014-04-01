class TodosController < UITableViewController

  def viewDidLoad
    super
    self.title = "Okonawa"

    load_todos

    add_todo_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_todo')
    log_out_button = UIBarButtonItem.alloc.initWithTitle("Logout", style: UIBarButtonItemStyleBordered, target:self, action:'logout')

    self.navigationItem.rightBarButtonItem = add_todo_button
    self.navigationItem.leftBarButtonItem = log_out_button

    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'todo_changed:',
                                                         name: 'MotionModelDataDidChangeNotification',
                                                         object: nil) unless RUBYMOTION_ENV == 'test'
  end

  def viewDidAppear(animated)
    display_login unless (PFUser.currentUser || RUBYMOTION_ENV == 'test')
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
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
    cell
  end

  def tableView(tableView, accessoryButtonTappedForRowWithIndexPath:indexPath)
    select_row(tableView, indexPath)
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    select_row(tableView, indexPath)
  end

  def tableView(tableView, editingStyleForRowAtIndexPath:indexPath)
    UITableViewCellEditingStyleDelete
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    if editingStyle == UITableViewCellEditingStyleDelete
      load_todos
      @todos[indexPath.row].destroy
    end
  end

  #
  #
  #

  def load_todos
    @todos = Todo.all
  end

  def todo_changed(notification)
    todo = notification.object

    if notification.userInfo[:action] != 'delete'
      row = @todos.index(todo) - 1
      path = NSIndexPath.indexPathForRow(row, inSection:0)
    end

    load_todos

    case notification.userInfo[:action]
      when 'add'
        add_todo_row(todo)
      when 'update'
        self.tableView.reloadRowsAtIndexPaths([path], withRowAnimation:UITableViewRowAnimationAutomatic)
      when 'delete'
        self.tableView.reloadData
    end
  end

  def add_todo
    todo = Todo.create :name => "New Todo",
                :description => "",
                :due_date => NSDate.new
    add_todo_row(todo) if RUBYMOTION_ENV == 'test'
  end

  def add_todo_row(todo)
    load_todos if RUBYMOTION_ENV == 'test'
    row = @todos.size - 1
    path = NSIndexPath.indexPathForRow(row, inSection:0)

    self.tableView.insertRowsAtIndexPaths([path], withRowAnimation:UITableViewRowAnimationRight)
    edit_todo(todo) unless RUBYMOTION_ENV == 'test'
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

  #
  #
  #

  def logInViewController(logIn, didLogInUser:user)
    @login.dismissModalViewControllerAnimated(true)
  end

  def display_login
    @login = PFLogInViewController.alloc.init
    @login.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton |
                    PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten |
                    PFLogInFieldsFacebook
    @login.delegate = self
    @login.signUpController.delegate = self
    self.presentModalViewController(@login, animated:true)
  end

  def logout
    PFUser.logOut
    display_login
  end

end
