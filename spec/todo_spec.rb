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

  it "is invalid without a name" do
    @todo.name = nil
    @todo.should.not.be.valid
  end
  
  it "is not done by default" do
    @todo.done.should.not.be.true
  end
  
  it "knows if its overdue" do
    @todo.should.be.overdue
  end
end