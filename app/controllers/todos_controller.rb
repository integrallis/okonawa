class TodosController < UIViewController
  attr_writer :data
  
  def viewDidLoad
    super

    self.title = "My ToDos"

    @table = UITableView.alloc.initWithFrame(self.view.bounds)
    self.view.addSubview(@table)

    @table.dataSource = self

    @data = %w(Milk Orange\ Juice Apples Bananas Brocolli Carrots Beef Chicken Enchiladas Hot\ Dogs Butter Bread Pasta Rice).map { |thing| "Buy #{thing}" }
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @data.size
  end

  def tableView(tableView, cellForRowAtIndexPath: indexPath)
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil)
    cell.textLabel.text = @data[indexPath.row]
    cell
  end
  
end