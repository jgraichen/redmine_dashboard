
require File.expand_path('../../../test_helper', __FILE__)

class RoutingDashboardTest < ActionController::IntegrationTest
  def test_rdb_index
    assert_routing(
        { :method => 'get', :path => "/projects/mlp/rdb" },
        { :controller => 'rdb_dashboard', :action => 'index', :id => 'mlp' }
      )
  end

  def test_rdb_dashboard
    assert_recognizes(
        { :controller => 'rdb_dashboard', :action => 'index', :id => 'mlp' },
        { :method => 'get', :path => "/projects/mlp/dashboard" }
      )
  end

  def test_taskboard_index
    assert_routing(
        { :method => 'get', :path => "/projects/mlp/rdb/taskboard" },
        { :controller => 'rdb_taskboard', :action => 'index', :id => 'mlp' }
      )
  end

  def test_taskboard_update
    assert_routing(
        { :method => 'get', :path => "/projects/mlp/rdb/taskboard/update" },
        { :controller => 'rdb_taskboard', :action => 'update', :id => 'mlp' }
      )
  end

  def test_taskboard_filter
    assert_routing(
        { :method => 'get', :path => "/projects/mlp/rdb/taskboard/filter" },
        { :controller => 'rdb_taskboard', :action => 'filter', :id => 'mlp' }
      )
  end

  def test_taskboard_move
    assert_routing(
        { :method => 'get', :path => "/projects/mlp/rdb/taskboard/move" },
        { :controller => 'rdb_taskboard', :action => 'move', :id => 'mlp' }
      )
  end
end
