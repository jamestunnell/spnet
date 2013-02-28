require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class LinkModelTestBlock < Block
  def initialize
    super(
      :in_ports => {
        "input" => SignalInPort.new,
      },
      :out_ports => {
        "output" => SignalOutPort.new,
      }
    )
  end
end

describe SPNet::LinkModel do
  describe '.new' do
    it 'should assign from and to port locaters' do
      output = PortLocater.new :block_name => "block_A", :port_name => "output"
      input = PortLocater.new :block_name => "block_B", :port_name => "input"
      link_model = LinkModel.new :from => output, :to => input
      link_model.from.should eq(output)
      link_model.to.should eq(input)
    end
  end
  
  describe '#make_link' do
    it 'should make a Link object, given good blocks' do
      blocks = {
        "block_A" => LinkModelTestBlock.new,
        "block_B" => LinkModelTestBlock.new,
      }
      output = PortLocater.new :block_name => "block_A", :port_name => "output"
      input = PortLocater.new :block_name => "block_B", :port_name => "input"
      link_model = LinkModel.new :from => output, :to => input
      link = link_model.make_link blocks
      link.from.should eq blocks["block_A"].out_ports["output"]
      link.to.should eq blocks["block_B"].in_ports["input"]
    end
  end
end
