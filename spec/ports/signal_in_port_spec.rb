require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SPNet::SignalInPort do
  describe '.new' do
    it 'should have an empty queue' do
      port = SPNet::SignalInPort.new
      port.queue.should be_empty
    end
  end

  describe '#enqueue_values' do
    it 'should add values to queue' do
      port = SPNet::SignalInPort.new
      values = [2.4, 2.6, 4.9, 5.1]
      
      port.enqueue_values(values.clone)
      values.should eq(port.queue)
    end
  
    it 'should limit all values before queuing them' do
      limiter = RangeLimiter.new(2.5, true, 5.0, true)
      port = SPNet::SignalInPort.new(:limiter => limiter)
      port.enqueue_values([2.4, 2.6, 4.9, 5.1])
      port.queue.each do |value|
        value.should be_between(2.5, 5.0)
      end
    end
  end

  describe '#dequeue_values' do
    it 'should remove N values from queue' do
      port = SPNet::SignalInPort.new
      values = [2.4, 2.6, 4.9, 5.1]
      port.enqueue_values(values.clone)
      values2 = port.dequeue_values 2
      port.queue.count.should be 2
      values2.count.should be 2
      values2.first.should eq(values.first)
    end    
    
    it 'should remove all values from queue if no count is given' do
      port = SPNet::SignalInPort.new
      values = [2.4, 2.6, 4.9, 5.1]
      port.enqueue_values(values.clone)
      values2 = port.dequeue_values
      port.queue.should be_empty
      values2.should eq(values)
    end
  end

end
