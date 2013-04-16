describe "Todo Controller" do
  tests TodoController
  
  before do
    @form = @controller.instance_variable_get("@form")
    @name_row = @form.sections[0].rows[0]
    @details_row = @form.sections[0].rows[1]
    @due_date_row = @form.sections[0].rows[2]
    @done_row = @form.sections[0].rows[3]
  end
  
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
  
  it "displays a Todo's details" do
    @name_row.value.should.equal "Buy Milk"
    @details_row.value.should.equal "We need some Milk"
    @due_date_row.object.date_value.hour.should.equal @now.hour
    @due_date_row.object.date_value.min.should.equal @now.min
    @done_row.value.should.equal false
  end
  
end