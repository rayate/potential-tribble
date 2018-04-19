require 'sinatra'

get '/' do
  cipher = " "
  erb :index, :locals => {:cipher =>cipher}
end

post "/" do
  phrase = params['phrase']
  cipher_number = params['number']
  cipher = casear_cipher(phrase,cipher_number)
  erb :index, :locals => {:cipher => cipher}
end

def casear_cipher(phrase,x)
  letters = phrase.downcase.split("")
  alphabet_to_number = {}
  number_to_alphabet = {}
  ("a".."z").each_with_index {|x,y| number_to_alphabet[y]= x}
  ("a".."z").each_with_index {|x,y| alphabet_to_number[x]= y}
  cipher = letters.map do |letter|
    ("a".."z").include?(letter) ? number_to_alphabet[(alphabet_to_number[letter]+x.to_i)%26] : letter
  end
  cipher.join
end
