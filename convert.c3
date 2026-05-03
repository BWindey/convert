module metric;
import std::io;

alias ConversionFunction = fn double(double original);

macro ConversionFunction @cst(double $rate) @const
	=> fn double(double original) => $rate * original;

struct ConversionEntry {
	String original_singular;
	String original_plural;
	String short_form;
	ConversionFunction conversion_function;
	String other;
}

const ConversionEntry[] CONVERSIONS = {
	// Distance
	{ "inch", "inches", "in", @cst(2.54), "centimeter" },
	{ "foot", "feet", "ft", @cst(0.3048), "meter" },
	{ "yard", "yards", "yd", @cst(0.9144), "meter" },
	{ "mile", "miles", "mi", @cst(1.609344), "kilometer" },
	// Weight
	{ "pound", "pounds", "lb", @cst(0.45359237), "kilogram" },
	{ "stone", "stone", "st", @cst(6.35029318), "kilogram" },
	{ "ton", "ton", "ton", @cst(1016.0469088), "kilogram" },
	// Temperature
	{ "fahrenheit", "fahrenheit", "F", fn double(double f) => (f - 32) / 1.8, "celsius" },
};

fn void usage(bool use_stderr) {
	if (use_stderr) {
		io::eprintn("Usage: metric <amount> <unit>");
	} else {
		io::printn("Usage: metric <amount> <unit>");
	}
}

fn void help() {
	io::print(" Convert imperial units to metric.\n ");
	usage(use_stderr: false);
	io::printn("\n Available units to convert:");
	foreach (&entry : CONVERSIONS) {
		io::printfn(
			"   - % 5s | % 6s | % 3s",
			entry.original_singular,
			entry.original_plural,
			entry.short_form
		);
	}
}

faultdef NOT_FOUND;
fn ConversionEntry? find_conversion_entry(String original) {
	// TODO: find best inexact match
	foreach (ConversionEntry entry : CONVERSIONS) {
		if (original == entry.original_singular) return entry;
		if (original == entry.original_plural) return entry;
		if (original == entry.short_form) return entry;
	}

	return NOT_FOUND~;
}

fn double? calculate_other(String amount, ConversionEntry conversion) {
	return conversion.conversion_function(amount.to_double())!;
}

fn int convert(String amount, String unit) {
	if (try conversion_entry = find_conversion_entry(unit)) {
		if (try converted_amount = calculate_other(amount, conversion_entry)) {
			io::printfn("%.3f %s", converted_amount, conversion_entry.other);
		} else {
			io::eprintfn("Failed to convert '%s' to a floating point value.", amount);
			return 20;
		}
	} else {
		io::eprintfn("Could not find a conversion entry for '%s'.", unit);
		return 10;
	}

	return 0;
}


fn int main(String[] args) {
	foreach (arg : args) {
		if (arg == "-h" || arg == "--help") {
			help();
			return 0;
		}
	}

	if (args.len != 3) {
		io::eprintn("Expected 2 arguments.");
		usage(use_stderr: true);
		return 1;
	}

	return convert(args[1], args[2]);
}
