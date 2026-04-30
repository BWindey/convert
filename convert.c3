module metric;
import std::io;

struct ConversionEntry {
	String original_singular;
	String original_plural;
	String short_form;
	double to_other;
	String other;
}

const ConversionEntry[] CONVERSIONS = {
	// Distance
	{ "inch", "inches", "in", 2.54, "centimeter" },
	{ "foot", "feet", "ft", 0.3048, "meter" },
	{ "yard", "yards", "yd", 0.9144, "meter" },
	{ "mile", "miles", "mi", 1.609344, "kilometer" },
	// Weight
	{ "pound", "pounds", "lb", 0.45359237, "kilogram" },
	{ "stone", "stone", "st", 6.35029318, "kilogram" },
	{ "ton", "ton", "ton", 1016.0469088, "kilogram" },
};

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
	return amount.to_double()! * conversion.to_other;
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
	if (args.len != 3) {
		io::eprintn("Expected 2 arguments.");
		io::eprintn("Usage: metric <amount> <unit>");
		return 1;
	}

	return convert(args[1], args[2]);
}
