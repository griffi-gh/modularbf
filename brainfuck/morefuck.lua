return{
  graphics = {
    init = 'l.g={} for i=0,0xff do l.g[i]=false end ',
    op = {
      ['&'] = function(r) return ('l.g[l.a[l.p]]=not(l.g[l.a[l.p]]) '):rep(r)..'y() ' end
    },
    obj = {
      draw = function(self,x,y,s)
        x = x or 1
        y = y or 1
        s = s or 2
        local g = self.env.g
        love.graphics.push()
          love.graphics.setColor(0,0,0)
          love.graphics.rectangle('fill',x,y,16*s,16*s)
          love.graphics.setColor(1,1,1)
          for i=0,0xff do
            local v = g[i]
            if v then
              local px = x+(i%16)*s
              local py = y+(math.floor(i/16))*s
              if s==1 then
                love.graphics.points(px,py)
              else
                love.graphics.rectangle('fill',px,py,s,s)
              end
            end
          end
        love.graphics.pop()
      end
    }
  },
  graphics2 = {
    init = 'l.g,l.gx,l.gy={},0,0 for i=0,255^2 do l.g[i]=0 end ',
    op = {
      ['%'] = function(r) return ('l.g[l.gx+l.gy*256]=l.a[l.p] ') end,
      ['~'] = function(r) return ('l.gx=l.a[l.p] ') end,
      ['|'] = function(r) return ('l.gy=l.a[l.p] ') end 
    },
    obj = {
      draw = function(self,x,y)
        x = x or 1
        y = y or 1
        local l = self.env
        local g = love.graphics
        g.push()
          g.setColor(0,0,0)
          g.rectangle('fill',x,y,254,254)
          for i=0,255^2 do
            local v = l.g[i]
            if v>0 then
              local px = x+(i%0x100)
              local py = y+(math.floor(i/0x100))+1
              g.setColor(v,v,v)
              g.points(px,py)
            end
          end
        g.pop()
      end
    }
  }
}