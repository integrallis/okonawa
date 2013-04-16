describe "Todos Controller" do
  tests TodosController
  
  before do
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