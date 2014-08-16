require File.expand_path '../../spec_helper', __FILE__
require 'ostruct'

describe Rdb::Engine do
  let(:board) { double 'board' }
  let(:klass) { Class.new(described_class) }
  let(:engine) { described_class.new board }

  describe 'class' do
    describe '^engines' do
      describe '#lookup' do
        let(:engines) do
          [
            OpenStruct.new(name: 'abc'),
            OpenStruct.new(name: 'cde'),
            OpenStruct.new(name: 'efg')
          ]
        end
        before { engines.each {|e| klass.engines << e } }
        subject { klass.lookup name }

        context 'with valid name' do
          let(:name) { 'cde' }
          it { should eq engines[1] }
        end

        context 'with invalid name' do
          let(:name) { 'bdf' }
          it { should eq nil }
        end
      end

      describe '#lookup!' do
        subject { proc { klass.lookup! 'abc' } }

        it 'should delegate to #lookup' do
          expect(klass).to receive(:lookup).with('abc').and_return(Object.new)
          subject.call
        end

        it 'should raise error if engine is not found' do
          expect(klass).to receive(:lookup).with('abc').and_return(nil)
          expect { subject.call }.to raise_error NameError
        end
      end
    end
  end

  describe '#as_json' do
    subject { engine.as_json }
  end
end
