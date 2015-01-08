require 'yaml'
require 'pathname'

shared_context 'config' do
  before :all do
    @config_filename = Pathname.new(__FILE__).join('../../test_app/app.yaml').cleanpath
  end
end

shared_context 'package' do
  before :all do
    @app_dir = Pathname.new(__FILE__).join '../../test_app'
    @output_dir = @app_dir.join 'pkg'
  end
end
