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
  end
 

  def tableView(tableView, numberOfRowsInSection: section)
    @todos.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.textLabel.text = @todos[indexPath.row].name
    cell
  end
  
end