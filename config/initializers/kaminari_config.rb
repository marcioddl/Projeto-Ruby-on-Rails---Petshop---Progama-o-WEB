Kaminari.configure do |config|
  config.default_per_page = 5     #5 por pagina
  config.max_per_page = 15        #15 paginas no maximo que aparece
  config.window = 4               # fora a pagina que ta aparecendo mostra 4        1,2,[3],4,5 
  config.outer_window = 1
  config.left = 1
  config.right = 1
end

