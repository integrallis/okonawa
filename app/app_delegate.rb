class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    
    @table = UITableView.alloc.initWithFrame(UIScreen.mainScreen.bounds) 
    
    todos = %w(Milk Orange\ Juice Apples Bananas Brocolli Carrots Beef Chicken Enchiladas Hot\ Dogs Butter Bread Pasta Rice)
    todos.map! { |thing| "Buy #{thing}"}
    
    @data_source = TodosDataSource.new
    
    @data_source.data = todos
    
    @table.dataSource = @data_source
    
    @window.addSubview(@table)
    
    true
  end
end

class TodosDataSource
  
  attr_writer :data
  
  def tableView(tableView, numberOfRowsInSection:section)
    @data.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.textLabel.text = @data[indexPath.row]
    cell
  end

end
