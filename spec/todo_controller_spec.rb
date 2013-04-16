describe "Todo Controller" do
  tests TodoController
  
  def controller
    unless @controller
      @now = NSDate.new
      @todo = Todo.create :name => "Buy Milk",
                          :details => "We need some Milk",
                          :due_date => @now
      @controller = TodoController.new(@todo)
    end
    @controller
  end
  
  it "exists" do
    Object.const_defined?('TodoController').should.be.true 
  end
  
end