class TodosController < UIViewController
  
  def viewDidLoad
    super
    self.title = "My ToDos"
    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    @table.autoresizingMask = UIViewAutoresizingFlexibleHeight
    self.view.addSubview(@table)

    @table.dataSource = self
    @table.delegate = self
    
    @todos = Todo.all
    
    add_todo_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd, target:self, action:'add_todo')
    self.navigationItem.rightBarButtonItem = add_todo_button                                                                                  
    
    NSNotificationCenter.defaultCenter.addObserver(self, selector: 'todoChanged:',
                                                         name: 'MotionModelDataDidChangeNotification',
                                                         object: nil) unless RUBYMOTION_ENV == 'test'
  end
 

  def tableView(tableView, numberOfRowsInSection: section)
    @todos.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.textLabel.text = @todos[indexPath.row].name
    cell
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
    todo = @todos[indexPath.row]
    edit_todo(todo)
  end
  
  def todoChanged(notification)
    todo = notification.object
    row = todo.id - 1
    path = NSIndexPath.indexPathForRow(row, inSection:0)
    
    case notification.userInfo[:action]
      when 'add'
        add_todo_row(todo)
      when 'update'
        @table.reloadRowsAtIndexPaths([path], withRowAnimation:UITableViewRowAnimationAutomatic)
      when 'delete'  
    end
  end
  
  def add_todo
    todo = Todo.create :name => "New Todo",
                :description => "",
                :due_date => NSDate.new
    add_todo_row(todo) if RUBYMOTION_ENV == 'test' 
  end
  
  def add_todo_row(todo)
    row = todo.id - 1
    path = NSIndexPath.indexPathForRow(row, inSection:0)
    @todos = Todo.all
    @table.insertRowsAtIndexPaths([path], withRowAnimation:UITableViewRowAnimationRight)
    edit_todo(todo) unless RUBYMOTION_ENV == 'test' 
  end
  
  def edit_todo(todo)
    todo_controller = TodoController.new(todo)
    self.navigationController.pushViewController(todo_controller, animated: true)
  end
  
end