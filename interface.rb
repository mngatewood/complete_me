require 'flammarion'
require './lib/complete_me'
require 'pry'

f = Flammarion::Engraving.new
f.orientation = :horizontal
f.title("CompleteMe")
cm = CompleteMe.new
cm.populate(File.read('/usr/share/dict/words'))
f.style({"background-color"=>"#f4f4f5",
          "font-color"=>"black"})
def build(instance)
  instance.subpane('button')
end
def build2(instance)
  instance.subpane('button2')
end
def dropdown_window(instance)
  instance.pane("Drowndown")
end

def dropdown_window2(instance)
  instance.pane("Dropndown")
end

def word_search_pane(instance)
  instance.subpane("window")
end

def word_search_pane2(instance)
  instance.subpane("window2")
end
f.html("<center> <h1> Complete Me </h1></center>")

word_search_pane(f).html("<center><h2>Word Search</h2></center>")
cm = CompleteMe.new
build(word_search_pane(f)).button("Build Database") do
  cm.populate(File.read("/usr/share/dict/words"))
  word_search_pane(f).subpane("infoo").html("<center><h4>#{cm.count} Records Inserted</h4><center>")
  build(word_search_pane(f)).hide
end

text = f.input("Partial Word")

f.button("Search") do
  dropdown_window(f).close
  dropdown_window(f).html("<center><h3>These are your suggested words</h3><br><h4>Please select the correct word</h4><center>")
  dropdown_window(f).dropdown(cm.suggest(text)) do |item|
    cm.select(text, item["value"])
  end
dropdown_window(f).subpane("delete").html("<center><br><br><br><h4>Select the Word You'd Like To Delete</h4></center>")
dropdown_window(f).dropdown(cm.suggest(text)) do |item|
  #binding.pry
  cm.delete_word(item["value"])
  dropdown_window(f).subpane("delete_conf_word").html("<center><h3>The selected word was deleted</h3></center>")
end

end
f.button('Clear') {dropdown_window(f).close}
# -------------------------------------------------------------------------------
word_search_pane2(f).html("<center><h2>Address Search</h2></center>")
street_cm = CompleteMe.new

build2(word_search_pane2(f)).button("Build Database") do
  street_cm.populate_with_csv('./test/addresses.csv', "FULL_ADDRESS")
  word_search_pane2(f).subpane("Info").html("<center><h4>#{street_cm.count} Records Inserted</h4><center>")
  build2(word_search_pane2(f)).hide
end

street_text = f.input("Partial Address")

f.button("Search") do
  dropdown_window(f).close
  dropdown_window(f).html("<center><h3>These are your suggested Addresses</h3><br><h4>Please select the correct Address</h4><center>")
  dropdown_window(f).dropdown(street_cm.suggest(street_text)) do |item|
    street_cm.select(street_text, item["value"])
  end
  dropdown_window(f).subpane("delete").html("<center><br><br><br><h4>Select the Address You'd Like To Delete</h4></center>")
  dropdown_window(f).dropdown(street_cm.suggest(street_text)) do |item|
  street_cm.delete_word(item["value"])
  dropdown_window(f).subpane("delete_conf_street").html("<center><h3>The selected address was deleted</h3></center>")
  end
end

f.button('Clear') {dropdown_window(f).close}
f.wait_until_closed
