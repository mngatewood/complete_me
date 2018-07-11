require 'flammarion'
require './lib/complete_me'
require 'pry'

f = Flammarion::Engraving.new
f.orientation = :horizontal
cm = CompleteMe.new
cm.populate(File.read('/usr/share/dict/words'))

def dropdown_window(instance)
  instance.pane("Drowndown")
end


f.html("<center> <h1> Complete Me </center> </h1>")

text = f.input("Partial Word")
f.button("Search") do
  dropdown_window(f).close
  dropdown_window(f).html("<h3>These are your suggested words</h3><br><p>Please select the correct word</p>")
  dropdown_window(f).dropdown(cm.suggest(text)) do |item|
    cm.select(text, item["value"])
  end
end
f.button('Clear') {dropdown_window(f).close}

f.wait_until_closed
