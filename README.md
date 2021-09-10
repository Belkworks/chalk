# Chalk
*A terminal styler in MoonScript.*

**Importing with [Neon](https://github.com/Belkworks/NEON)**:
```lua
Chalk = NEON:github('belkworks', 'chalk')
```

## API

### Coloring text

Index **Chalk** with a supported *color*, *modifier*, or *side*.  
This returns a function that, when called, will return a string of all arguments concatenated with the desired color.
```lua
Chalk.red('hello') -- 'hello' with ANSI red
```

You can mix and match multiple options to achieve complex styles!
```lua
Chalk.light.blue.bg.yellow('wow')
-- 'wow' with light blue text and a yellow background
```

You can save and reuse Chalk functions multiple times.
```lua
lightred = Chalk.light.red
lightred('hello') -- 'hello' with ANSI light red
lightred('world') -- 'world' with ANSI light red
```

By default, Chalk is styling the foreground properties.

### Extra Functions
**print**: `chalk.print(...) -> nil`  
Writes all arguments passed to the console, with a trailing newline.
```lua
Chalk.print(Chalk.blue('hey'))
```

**write**: `chalk.write(...) -> nil`  
Writes all arguments passed to the console.
```lua
Chalk.write(Chalk.yellow('howdy'))
```

**clear**: `chalk.clear() -> nil`  
Clears the console (only supported in Synapse)
```lua
Chalk.clear()
```

### Supported Colors
- `black`
- `red`
- `green`
- `yellow`
- `blue`
- `magenta`
- `cyan`
- `white`

### Supported Modifiers
- `light`, `bright` - Brighten color
- `normal` - Normal color

### Supported Sides
- `fg`, `foreground`, `text` - Text color
- `bg`, `background` - Background color
