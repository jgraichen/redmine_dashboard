# encoding: UTF-8
require File.expand_path("../../spec_helper", __FILE__)

describe 'Rdb' do
  let(:base) { '/projects/mlp' }

  it 'should route <base>/rdb to rdb_dashboard#index' do
    expect(:get => "#{base}/rdb").to route_to(
      :controller => 'rdb_dashboard',
      :action => 'index',
      :id => 'mlp'
    )
  end

  it 'should route <base>/dashboard to rdb_dashboard#index' do
    expect(:get => "#{base}/dashboard").to route_to(
      :controller => 'rdb_dashboard',
      :action => 'index',
      :id => 'mlp'
    )
  end

  context 'Taskboard' do
    let(:base) { '/projects/mlp/rdb/taskboard' }

    it 'should route <taskboard> to rdb_taskboard#index' do
      expect(:get => base).to route_to(
        :controller => 'rdb_taskboard',
        :action => 'index',
        :id => 'mlp'
      )
    end

    it 'should route <taskboard>/move to rdb_taskboard#move' do
      expect(:get => "#{base}/move").to route_to(
        :controller => 'rdb_taskboard',
        :action => 'move',
        :id => 'mlp'
      )
    end

    it 'should route <taskboard>/update to rdb_taskboard#update' do
      expect(:get => "#{base}/update").to route_to(
        :controller => 'rdb_taskboard',
        :action => 'update',
        :id => 'mlp'
      )
    end

    it 'should route <taskboard>/filter to rdb_taskboard#filter' do
      expect(:get => "#{base}/filter").to route_to(
        :controller => 'rdb_taskboard',
        :action => 'filter',
        :id => 'mlp'
      )
    end
  end
end
