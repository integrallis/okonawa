describe "Todos Controller" do
  tests TodosController
  
  before do
    Todo.delete_all
    @todo = Todo.create :name => 'Buy Milk',
                        :description => 'Get some 1% to rid yourself of the muffin top',
                        :due_date => '2013-03-31'
    @table = controller.tableView #instance_variable_get("@table")
  end
  
  it 'should exist' do
    @table.should.not == nil
  end
  
  it 'displays the given ToDos' do
    @table.visibleCells.should.not.be.empty
  end
  
  it 'displays the correct label for a give ToDo' do
    first_cell = @table.visibleCells.first
    first_cell.textLabel.text.should == 'Buy Milk'
  end
  
  it 'creates a new row for a new todo' do
    controller.add_todo
    last_cell = @table.visibleCells.last
    last_cell.textLabel.text.should == 'New Todo'
  end
end