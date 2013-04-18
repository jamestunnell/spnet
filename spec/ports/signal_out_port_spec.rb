require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::SignalOutPort do
  before :each do
    @out_port = SPNet::SignalOutPort.new
    @in_port = SPNet::SignalInPort.new
  end
  
  describe '#enqueue_values' do
    context 'not linked to a SignalInPort' do
      before :each do
        @port = SPNet::SignalOutPort.new
        @values = [2.4, 2.6, 4.9, 5.1]
      end
      
      context 'autosend flag set false' do
        it 'should add values to queue' do
          @port.enqueue_values @values.clone, false
          @values.should eq(@port.queue)
        end
      end
      
      context 'autosend flag set true' do
        it 'should add values to queue' do
          @port.enqueue_values(@values.clone)
          @values.should eq(@port.queue)
        end        
      end
    end
    
    context 'linked to a SignalInPort' do
      before :each do
        @port = SPNet::SignalOutPort.new
        @in_port = SignalInPort.new
        Link.new(:from => @port, :to => @in_port).activate
        @values = [2.4, 2.6, 4.9, 5.1]
      end
      
      context 'autosend flag set false' do
        it 'should add values to the queue' do
          @port.enqueue_values @values.clone, false
          @values.should eq(@port.queue)
          @in_port.queue.should be_empty
        end
      end
      
      context 'autosend flag set true' do
        it 'should not add values to the queue, but instead add values to the linked port queue' do
          @port.enqueue_values @values.clone
          @values.should eq(@in_port.queue)
          @port.queue.should be_empty
        end
      end      
    end
  end

  describe '#dequeue_values' do
    before :each do
      @port = SPNet::SignalOutPort.new
      @values = [2.4, 2.6, 4.9, 5.1]
      @port.enqueue_values(@values.clone)
    end
    
    it 'should remove N values from queue' do
      values2 = @port.dequeue_values 2
      @port.queue.count.should be 2
      values2.count.should be 2
      values2.first.should eq(@values.first)
    end    
    
    it 'should remove all values from queue if no count is given' do
      values2 = @port.dequeue_values
      @port.queue.should be_empty
      values2.should eq(@values)
    end
  end
  
  #describe '#send_values' do
  #  it 'should enqueue the values on the linked input port' do
  #    @out_port.set_link Link.new(:to => @in_port, :from => @out_port)
  #    
  #    @in_port.queue.should be_empty
  #    @out_port.evalues [1,2,3,4]
  #    @in_port.queue.should eq([1,2,3,4])
  #  end
  #end

end
