#맨손으로 웹 서버 만들기
#요청의 매개변수 값 해석하기
def http_char c1, c2, default=" "
  code = (c1 + c2).to_i(base=16)
  if code > 0
    code.chr
  else
    default
  end
end

def decode_param s
  def f lst
    unless lst.empty?
      case lst[0]
      when "%"
        (http_char lst[1], lst[2]) + (f lst[3..-1])
      when "+"
        " " + (f lst[1..-1])
      else 
        lst[0] + (f lst[1..-1])
      end
    else
      ""
    end
  end
  f s.split("")
end

#요청의 매개변수 목록 해석하기
def parse_params s
  i1 = s.index('=')
  i2 = s.index('&')
  
  ret = []
  if i1
    ret.push([s[0...i1].upcase.to_sym, (decode_param s[i1+1...((i2)?i2:s.length)])])
    if i2
      ret.push(parse_params s[i2+1..-1])
    end
  end
  ret
end

#요청의 헤더 해석하기
def parse_url s
  url = s[(s.index(" ") + 2)...(s.rindex(" "))]
  x = url.index("?")
  ret = []
  if x
    ret.push(url[0...x])
    ret.push(parse_params url[x+1..-1])
  else
    ret.push(url)
  end
  ret
end

def get_header stream
  s = stream.gets.chomp
  i = s.index(":")
  ret = []
  if i
    h = [s.slice(0, i).upcase.to_sym, s.slice(i+2, s.length)]
  end
  if h
    ret.push(h)
    ret.concat(get_header stream)
  end
  ret
end

#요청의 본문 해석하기
def get_content_params stream, header
  ret = []
  length = header.assoc(:'CONTENT-LENGTH')
  if length
    length = length[1]
  end
  if length
    content = stream.read(length.to_i)
    ret.push(parse_params content)
  end
  ret
end

#마무리 단계: serve 함수

require 'socket'

def serve request_handler
  socket = TCPServer.new 8080
#  $stdout = socket.to_io
  begin
    loop do
      stream = socket.accept
      $stdout = stream.to_io
      url = parse_url stream.gets.chomp
      path = url[0]
      header = get_header stream
      params = [url[0]].concat(get_content_params stream, header)
      request_handler.call path, header, params
    end
  ensure
    socket.close
    $stdout = STDOUT
  end
end

#동적 웹 사이트 만들기
def hello_request_handler path, header, params
  if path == "greeting"
    name = params.assoc(:NAME)
    if not name
      print "<html><form>What is your name?<input name='name' /></form></html>"
    else
      sprintf "<html>Nice to meet you, %s</html>", name[1]
    end
  else
    print "Sorry... I don't know that page."
  end
end
