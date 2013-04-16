describe "Todos Controller" do
  tests TodosController
  
  before do
    Todo.delete_all
    @todo = Todo.create :name => 'Buy Milk',
                        :description => 'Get some 1% to rid yourself of the muffin top',
                        :due_date => '2013-03-31'
    @table = controller.instance_variable_get("@table")
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
end