# Convert
This is a small little script I wrote in the
[C3 programming language](https://c3lang.org)
to convert imperial units to metric units.

While this isn't the greatest, it is mine and simple enough for anyone to
read the code and expand/change upon their needs.


## Usage
```sh
./metric <amount> <unit>
```

Example usage:
```sh
./metric 3 feet
0.914 meter

./metric 5 in
12.700 centimeter

./metric 6.24 stone
39.629 kilogram
```


## Building
You will need a
[C3 compiler](https://c3-lang.org/getting-started/prebuilt-binaries/)
in your path:
```sh
c3c compile convert.c3
```


## Supported conversions
Since I'm lazy, I'll just post the source code here, I'm sure you can figure
it out. I'll help by saying that the order in which they are defined is
`singular`, `plural`, `short`, `conversion_rate`, `result_unit`.

```c3
const ConversionEntry[] CONVERSIONS = {
	// Distance
	{ "inch", "inches", "in", ..., "centimeter" },
	{ "foot", "feet", "ft", ..., "meter" },
	{ "yard", "yards", "yd", ..., "meter" },
	{ "mile", "miles", "mi", ..., "kilometer" },
	// Weight
	{ "pound", "pounds", "lb", ..., "kilogram" },
	{ "stone", "stone", "st", ..., "kilogram" },
	{ "ton", "ton", "ton", ..., "kilogram" },
	// Temperature
	{ "fahrenheit", "fahrenheit", "F", ..., "celsius" },
};
```
