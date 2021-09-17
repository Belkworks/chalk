local COLORS = {
  'black',
  'red',
  'green',
  'yellow',
  'blue',
  'magenta',
  'cyan',
  'white'
}
local concat
concat = table.concat
local cloneDeep
cloneDeep = function(T)
  if (type(T)) == 'table' then
    local _tbl_0 = { }
    for K, V in pairs(T) do
      _tbl_0[K] = cloneDeep(V)
    end
    return _tbl_0
  else
    return T
  end
end
local validColor
validColor = function(C)
  C = C:lower()
  for _index_0 = 1, #COLORS do
    local c = COLORS[_index_0]
    if C == c then
      return true
    end
  end
  return false
end
local zeroIndexOf
zeroIndexOf = function(T, V)
  for i, v in pairs(T) do
    if v == V then
      return i - 1
    end
  end
end
local code
code = function(color, modifier, side)
  if color == nil then
    color = 'white'
  end
  if modifier == nil then
    modifier = 'normal'
  end
  if side == nil then
    side = 'fg'
  end
  color = assert(color:lower(), 'chalk: no color provided!')
  assert((validColor(color)), 'chalk: invalid color! ' .. color)
  local _exp_0 = modifier
  if 'bright' == _exp_0 or 'light' == _exp_0 then
    modifier = 'light'
  elseif 'normal' == _exp_0 then
    modifier = 'normal'
  else
    modifier = error('invalid modifier ' .. modifier)
  end
  local sideplus
  local _exp_1 = side
  if 'bg' == _exp_1 then
    sideplus = 10
  elseif 'fg' == _exp_1 then
    sideplus = 0
  else
    sideplus = error('invalid side ' .. side)
  end
  local base = sideplus + (function()
    local _exp_2 = modifier
    if 'normal' == _exp_2 then
      return 30
    elseif 'light' == _exp_2 then
      return 90
    else
      return error('invalid side ' .. side)
    end
  end)()
  local final = base + zeroIndexOf(COLORS, color)
  return '\27[' .. final .. 'm'
end
local reset = '\27[0m'
local WRITE = rconsoleprint or io.write
local CLEAR = rconsoleclear or function()
  return error('clear not supported!')
end
local TITLE = rconsolename or function()
  return error('title not supported!')
end
local Default = {
  fg = {
    color = 'white',
    modifier = 'normal'
  },
  bg = {
    color = 'black',
    modifier = 'normal'
  },
  side = 'fg'
}
local multiwrite
multiwrite = function(...)
  return WRITE((concat((function(...)
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = {
      ...
    }
    for _index_0 = 1, #_list_0 do
      local v = _list_0[_index_0]
      _accum_0[_len_0] = tostring(v)
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end)(...), ' ')))
end
local multiprint
multiprint = function(...)
  local args = {
    ...
  }
  table.insert(args, '\n')
  return multiwrite(unpack(args))
end
local Chalk
Chalk = function(Data)
  if not (Data) then
    Data = cloneDeep(Default)
  end
  local T = {
    write = multiwrite,
    print = multiprint,
    clear = CLEAR,
    title = TITLE
  }
  return setmetatable(T, {
    __call = function(self, ...)
      local fg = code(Data.fg.color, Data.fg.modifier, 'fg')
      local bg = code(Data.bg.color, Data.bg.modifier, 'bg')
      local target = fg .. bg
      return (concat((function(...)
        local _accum_0 = { }
        local _len_0 = 1
        local _list_0 = {
          ...
        }
        for _index_0 = 1, #_list_0 do
          local v = _list_0[_index_0]
          _accum_0[_len_0] = target .. (tostring(v)) .. reset
          _len_0 = _len_0 + 1
        end
        return _accum_0
      end)(...), ' '))
    end,
    __index = function(self, K)
      do
        local V = rawget(T, K)
        if V then
          return V
        end
      end
      assert((type(K)) == 'string', 'chalk: key must be a string!')
      K = K:lower()
      if K == 'reset' then
        return Chalk()
      end
      local Next
      do
        local _with_0 = cloneDeep(Data)
        local _exp_0 = K
        if 'fg' == _exp_0 or 'text' == _exp_0 or 'foreground' == _exp_0 then
          _with_0.side = 'fg'
        elseif 'bg' == _exp_0 or 'background' == _exp_0 then
          _with_0.side = 'bg'
        else
          _with_0.side = _with_0.side
        end
        Next = _with_0
      end
      do
        local _with_0 = Next[Next.side]
        if validColor(K) then
          _with_0.color = K
        else
          _with_0.color = _with_0.color
        end
        local _exp_0 = K
        if 'bright' == _exp_0 or 'light' == _exp_0 or 'normal' == _exp_0 then
          _with_0.modifier = K
        else
          _with_0.modifier = _with_0.modifier
        end
      end
      return Chalk(Next)
    end
  })
end
return Chalk()
