Shoes.app do
  flow(width: 300){ 3.times{ |i| button "hello#{i}" } }
  stack(width: 100){ 3.times{ |i| button "hello#{i}" } }
  button 'bye bye1'
  flow(width: 0.5){ 2.times{ flow(width: 0.5){ 2.times{ |j| button "Yayyyy#{j}" } } } }
  flow(width: 0.3){ button 'go go go go go' }
  stack(width: 0.3){ edit_line; 3.times{ para 'hello' } }
  flow(width: 0.3){ image File.join(Shoes::DIR, 'static/shoes-icon.png') }
  button 'bye bye2'
end
