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
    ret.push([s[0...i1].upcase.to_sym, (decode_param s[i1+1...((i2)?i2:-1)])])
    if i2
      ret.push(parse_params s[i2+1..-1])
    end
  end
  ret
end

def get_header stream

end
