require 'opal'
require 'opal-jquery'

require 'browser'
require 'browser/console'
require 'browser/socket'

require 'lib/uid'
require 'lib/transmission_data'

require 'lib/socket'
require 'lib/deferred'
require 'lib/async_require'
require 'lib/deferred_pool'
require 'lib/evented'
require 'lib/evented/column_info'

require 'rendering'
require 'handlers'

require 'active_record'

require 'lib/context'
require 'lib/handlebars'

$socket = Socket.new("ws://localhost:8080")
$action = Rendering::Index.new

Evented.on(:socket, :ready) do
  async_require 'models' do
    Evented.run(:models, :required)
  end
end

Evented.on(:models, :required) do
  Evented::ColumnInfo.call
end

Evented.on(:models, :column_info_loaded) do
  $action.run
end

Evented.on(:context, :ready) do
  Document.ready? do
    puts "Render data: #{Context.data.inspect}"
    $action.display
    Evented.run(:app, :ready)
  end
end
