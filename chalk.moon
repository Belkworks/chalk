-- chalk.moon
-- SFZILabs 2021

COLORS = {
	'black', 'red', 'green', 'yellow'
	'blue', 'magenta', 'cyan', 'white'
}

import concat from table

cloneDeep = (T) -> -- WARNING: No circular safety!
	if (type T) == 'table'
		{ K, cloneDeep V for K, V in pairs T }
	else T

validColor = (C) ->
	C = C\lower!
	return true for c in *COLORS when C == c
	false

zeroIndexOf = (T, V) ->
	return i - 1 for i, v in pairs T when v == V 

code = (color = 'white', modifier = 'normal', side = 'fg') ->
	color = assert color\lower!, 'chalk: no color provided!'
	assert (validColor color), 'chalk: invalid color! ' .. color

	modifier = switch modifier
		when 'bright', 'light'
			'light'
		when 'normal'
			'normal'
		else error 'invalid modifier ' .. modifier

	sideplus = switch side
		when 'bg' then 10
		when 'fg' then 0
		else error 'invalid side ' .. side

	base = sideplus + switch modifier
		when 'normal' then 30
		when 'light' then 90
		else error 'invalid side ' .. side
	
	final = base + zeroIndexOf COLORS, color
	'\27[' .. final .. 'm'

reset = '\27[0m'

WRITE = rconsoleprint or io.write
CLEAR = rconsoleclear or -> error 'clear not supported!'
TITLE = rconsolename or -> error 'title not supported!'

Default = {
	fg:
		color: 'white'
		modifier: 'normal'
	bg:
		color: 'black'
		modifier: 'normal'

	side: 'fg'
}

multiwrite = (...) ->
	WRITE (concat [tostring v for v in *{...}], ' ')

multiprint = (...) ->
	args = { ... }
	table.insert args, '\n'
	multiwrite unpack args

format = (s, ...) ->
	multiprint s\format ...

Chalk = (Data) ->
	Data = cloneDeep Default unless Data 
	T = {
		write: multiwrite
		print: multiprint
		printf: format
		clear: CLEAR
		title: TITLE
	}

	setmetatable T,
		__call: (...) =>
			fg = code Data.fg.color, Data.fg.modifier, 'fg'
			bg = code Data.bg.color, Data.bg.modifier, 'bg'
			target = fg .. bg
			-- TODO: reduce the amount of codes used (stateful)
			(concat [target .. (tostring v) .. reset for v in *{...}], ' ')

		__index: (K) =>
			if V = rawget T, K
				return V

			assert (type K) == 'string', 'chalk: key must be a string!'
			K = K\lower!

			return Chalk! if K == 'reset'

			Next = with cloneDeep Data
				.side = switch K
					when 'fg', 'text', 'foreground'
						'fg'
					when 'bg', 'background'
						'bg'
					else .side

			with Next[Next.side]
				.color = if validColor K
					K
				else .color

				.modifier = switch K
					when 'bright', 'light', 'normal'
						K
					else .modifier
				
			Chalk Next

Chalk!
