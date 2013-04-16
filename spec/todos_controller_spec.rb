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
end