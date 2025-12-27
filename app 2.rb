require 'roda'

class App < Roda
  plugin :streaming
  route do |r|

    r.root do
      <<-END
<!doctype html>
<html>
  <head>
    <meta charset="utf8"/>
    <title> Server Push Example</title>
  </head>
  <body>
    Server Push Example
<script type="text/javascript">
var es = new EventSource('/notifications');
es.addEventListener('message', function(e) {
  console.log(e.data);
});
es.addEventListener('error', function(e) { es.close(); });
</script>
  </body>
</html>
END
    end

    r.get 'notifications' do
      response['Content-Type'] = 'text/event-stream'
      stream do |out|
        (1..10).each do |i|
          sleep 1
          out << "id: #{i}\n"
          out << "data: return #{i*i} \n\n"
        end
      end
    end
  end
end
