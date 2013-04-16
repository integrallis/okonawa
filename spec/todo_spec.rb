describe "Todo Model" do
  
  before do
    @todo = Todo.new 
  end

  it "exists" do
    Object.const_defined?('Todo').should.be.true 
  end

  it "has a name, description, a due date and whether is done or not" do
    @todo.should.respond_to :name
    @todo.should.respond_to :description
    @todo.should.respond_to :due_date
    @todo.should.respond_to :done
  end

end