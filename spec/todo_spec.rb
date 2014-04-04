describe "Todo Model" do

  before do
    @now = NSDate.new.to_f

    @todo = Todo.new
    @todo.name = 'Buy Milk'
    @todo.details = 'We need some Milk'
    @todo.due_date = @now
    @todo.done = false
  end

  it "exists" do
    Object.const_defined?('Todo').should.be.true
  end

  it "has a name, details, a due date and whether is done or not" do
    @todo.name.should.should == 'Buy Milk'
    @todo.details.should == 'We need some Milk'
    @todo.due_date.should == @now
    @todo.done.should == false
  end

  it "is invalid without a name" do
    @todo = Todo.new
    @todo.should.not.be.valid
  end

  it "is not done by default" do
    @todo = Todo.new
    @todo.done.should.not.be.true
  end

  it "knows if its overdue" do
    @todo.should.be.overdue
  end
end
