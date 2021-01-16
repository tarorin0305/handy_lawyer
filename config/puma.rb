app do |env|
  path = env['REQUEST_PATH']

  if path == '/corporate_law'
    body = '会社法ページ'
  else
    body = 'その他'
  end
  puts body.encoding

  [200, { 'Content-Type' => 'text/plain; charset=UTF-8', 'Content-Length' => body.bytesize.to_s }, [body]]
end