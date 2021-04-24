--[==[
Copyright ©2020 Porthios of Myzrael
The contents of this addon, excluding third-party resources, are
copyrighted to Porthios with all rights reserved.
This addon is free to use and the authors hereby grants you the following rights:
1. You may make modifications to this addon for private use only, you
   may not publicize any portion of this addon.
2. Do not modify the name of this addon, including the addon folders.
3. This copyright notice shall be included in all copies or substantial
  portions of the Software.
All rights not explicitly addressed in this license are reserved by
the copyright holders.
]==]--


function debug(msg)
  if (DEBUG) then
    if (msg) then
      return print("DEBUG: " .. msg)
    end
  end
end

--single array
function singleKeyFromValue(_array, value)
  for k,v in pairs(_array) do
    if v==value then return k end
  end
  return nil
end
--matrix array
function multiKeyFromValue(_array, value, index)
  if ((index == nil) or (index == 0)) then
    index = 1
  end
  for k,v in pairs(_array) do
    if v[index]==value then return k end
  end
  return nil
end

function reindexArray(input, reval)
  local n=#input
  for i=1,n do
    if reval[input[i]] then
      input[i]=nil
    end
  end
  local j=0
  for i=1,n do
    if input[i]~=nil then
      j=j+1
      input[j]=input[i]
    end
  end
  for i=j+1,n do
    input[i]=nil
  end
end

function reindexArraySafe(array)
  local n=0
  local newArray={}
  for i,v in pairs(array) do
    n=n+1
    newArray[n] = v
  end
  return newArray
end

function split(s, delimiter)
  result = {}
  for match in (s..delimiter):gmatch("(.-)"..delimiter) do
    table.insert(result, match)
  end
  return result
end

function isempty(s)
  return s == nil or s == ''
end

function table.merge(t1, t2)
 for k,v in ipairs(t2) do
    table.insert(t1, v)
 end
  return t1
end

function removeValueFromArray(array, value)
  if (value) then
    remove_key = singleKeyFromValue(array, value)
    array[remove_key] = nil
    reindexArray(array, array)
  end
end

local bytes = {}
function encode(x)
	for k = 1, #bytes do
		bytes[k] = nil
	end

	bytes[#bytes + 1] = x % 255
	x=math.floor(x/255)

	while x > 0 do
		bytes[#bytes + 1] = x % 255
		x=math.floor(x/255)
	end
	if #bytes == 1 and bytes[1] > 0 and bytes[1] < 250 then
		return string_char(bytes[1])
	else
		for i = 1, #bytes do
			bytes[i] = bytes[i] + 1
		end
		return string_char(256 - #bytes, unpack(bytes))
	end
end

function decode(ss, i)
	i = i or 1
	local a = string_byte(ss, i, i)
	if a > 249 then
		local r = 0
		a = 256 - a
		for n = i + a, i + 1, -1 do
			r = r * 255 + string_byte(ss, n, n) - 1
		end
		return r, a + 1
	else
		return a, 1
	end
end
