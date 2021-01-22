local bf = {
  rules = {
    base = {
      init = 'local l,y={},coroutine.yield y(l) '
    },
    brainfuck = {
      init = 'l.a={}l.p=0 for i=0,100 do l.a[i]=0 end setmetatable(l.a,{__index=function()return 0 end}) ',
      op = {
        ['+'] = function(r) return ('l.a[l.p]=(l.a[l.p]+%s)%%256 '):format(r) end,
        ['-'] = function(r) return ('l.a[l.p]=(l.a[l.p]-%s)%%256 '):format(r) end,
        ['<'] = function(r) return ('l.p=l.p+%s '):format(r) end,
        ['>'] = function(r) return ('l.p=l.p-%s '):format(r) end,
        ['.'] = function(r) return ('io.write(string.char(l.a[l.p]):rep(%s)) '):format(r) end,
        [','] = function(r) return ('l.a[l.p] = io.read(1) byte() '):rep(r) end,
        ['['] = function(r) return ('while not(l.a[l.p]==0)do '):rep(r) end,
        [']'] = function(r) return ('end '):rep(r) end,
        ['$'] = function(r) return ('y(l.a[l.p]) '):rep(r) end, --break and return current memory var
      }
    }
  }
}

function bf.compile(s,...)
  assert(s)
  s = s..' '
  local r = {bf.rules.base,...}
  local g = ''
  local op = {}
  local ret = {}
  for i,v in ipairs(r) do
    if v.init then
      g = g..v.init
    end
    if v.op then
      for i2,v2 in pairs(v.op) do
        op[i2] = v2
      end
    end
    if v.obj then
      for i2,v2 in pairs(v.obj) do
        ret[i2] = v2
      end
    end
  end
  local re,ch
  for i=1,#s do
    local c = s:sub(i,i)
    if c==ch then
      re = re+1
    else
      if ch and op[ch] then
        g = g..op[ch](re)
      end
      ch,re = c,1
    end
  end
  local fn = assert(loadstring(g))
  local cr = coroutine.create(fn)
  local _,l = coroutine.resume(cr)
  --
  ret.env = l
  function ret:step()
    if coroutine.status(cr)~="dead" then
      return coroutine.resume(cr)
    end
  end
  
  return ret
end

function bf.tick(cr)
  
end

return bf