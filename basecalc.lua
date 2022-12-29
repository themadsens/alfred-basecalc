#!/usr/bin/env lua

local json = require 'json' .encode
local tofrac = require 'fraction'
math.e = math.exp(1)
math.log10 = function(v) return math.log(v, 10) end

local th = utf8.char(0x2009)
function group(str, len, sep)
  local t={}
  while #str > 0 do
    table.insert(t, str:sub(-len))
    str = str:sub(1, -len-1)
  end
  return table.concat(reverse(t), sep)
end

function reverse(arr)
   local i, j = 1, #arr

   while i < j do
      arr[i], arr[j] = arr[j], arr[i]
      i = i + 1
      j = j - 1
   end
   return arr
end

function bits(num)
  local t={}
  while num ~= 0 do
    bit = num & 1
    table.insert(t, bit)
    num = num >> 1
  end
  return table.concat(reverse(t))
end

local conv = arg[1]:gsub('%f[%x]0b[0-1]+', function(s) return tonumber(s:sub(3), 2) end)
                   :gsub('%f[%x]0o[0-7]+', function(s) return tonumber(s:sub(3), 8) end) 
local res, err = load("return "..conv, "expr", "t", math)
if not res then
   return print(json{items={{icon = {path = "err.png"}, title = "Error", subtitle = err:sub(20)}}})
end

local res, val = pcall(res)
if not res then
   return print(json{items={{icon = {path = "err.png"}, title = "Error", subtitle = val }}})
end
if type(val) ~= 'number' then
   return print(json{items={{icon = {path = "err.png"}, title = "Not a number: "..type(val), subtitle = tostring(val)}}})
end
if math.type(val) == 'float' then
   local str, fmt
   if math.abs(val) < 1e-6 or math.abs(val) > 1e19 then
      str = ("%.16g"):format(val)
   else
      str = ("%.16f"):format(val)
      local int, sep, dec = str:match('(%d*)([.,])(0?%d-)0*$')
      dec = dec:gsub('00000000000+%d?%d$', '')
      str = int..sep..dec
      fmt = group(int, 3, th)..sep..dec
   end
   local nom, den, err = tofrac(val)
   return print(json{items={
      {icon = {path = "10.png"}, title = fmt or str, arg = str},
      {icon = {path = "fr.png"}, title = nom.." / "..den, arg = nom.."/"..den}
   }})
end

local str10 = ("%d"):format(val)
local str16 = ("%x"):format(val)
local str8  = ("%o"):format(val)
local str2  = bits(val)
print(json {items={
   {icon = {path = "10.png"}, title=group(str10, 3, th), arg=str10},
   {icon = {path = "16.png"}, title=group(str16, 4, th), arg="0x"..str16},
   {icon = {path =  "8.png"}, title=      str8,          arg="0o"..str8},
   {icon = {path =  "2.png"}, title=group(str2,  4, th), arg="0b"..str2},
}})
