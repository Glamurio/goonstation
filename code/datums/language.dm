/datum/languages
	var/list/language_cache = list()

	New()
		..()
		for (var/T in typesof(/datum/language))
			var/datum/language/L = new T()
			language_cache[L.id] = L

var/global/datum/languages/languages = new()

/datum/language
	var/id = ""
	proc/get_messages(var/O)
		return list(heard_understood(O), heard_not_understood(O))

	proc/heard_not_understood(var/orig_message)
		return orig_message

	proc/heard_understood(var/orig_message)
		return orig_message

/datum/language/english
	id = "english"

	heard_not_understood(var/orig_message)
		return stars(orig_message)

/datum/language/monkey
	id = "monkey"

	heard_not_understood(var/orig_message)
		return ""

/datum/language/animal
	id = "animal"

	heard_not_understood(var/orig_message)
		return ""

/datum/language/silicon
	id = "silicon"

	heard_not_understood(var/orig_message)
		return "beep beep beep"

/datum/language/martian
	id = "martian"
	var/list/martian_dictionary = list()

	proc/translate(var/message)
		var/list/words = splittext(uppertext(message), " ")
		var/list/newwords = list()
		for (var/w in words)
			if (w == "")
				continue
			var/suf = copytext(w, length(w))
			if (suf in list("!", ".", ",", "?"))
				var/osuf = suf
				while (prob(60) && osuf != ",")
					suf += osuf
				if (length(w) == 1)
					newwords[newwords.len] += suf
					continue
				w = copytext(w, 1, length(w))
			else
				suf = ""
			if (w in martian_dictionary)
				newwords += martian_dictionary[w] + suf
			else
				var/wlen = length(w)
				var/trlen = rand(max(2, wlen - 4), min(9, wlen + 4))
				var/list/trl = list()
				for (var/i = 1, i <= trlen, i++)
					trl += pick("K", "X", "B", "Q", "U", "I", "J", "F", "D", "V", "W", "P", "Z", "R", "M", "Y", "T")
				var/tr = jointext(trl, "")
				martian_dictionary[w] = tr
				newwords += tr + suf
		return jointext(newwords, " ")

	heard_not_understood(var/orig_message)
		return translate(orig_message)

/datum/language/binary
	id = "binary"

	get_messages(var/O)
		var/NU = heard_not_understood(arglist(args))
		return list(html_encode(debinarize(NU)), html_encode(NU))

	heard_not_understood(var/orig_message)
		return binarize(arglist(args))

	heard_understood(var/orig_message)
		return debinarize(binarize(arglist(args)))

	proc/binarize(var/str, var/corr_prob = 0)
		var/ret = ""
		for (var/i = 1, i <= min(length(str), 32), i++)
			var/l = text2ascii(str, i)
			for (var/j = 128, j >= 1, j /= 2)
				var/val = (l & j) ? 1 : 0
				if (prob(corr_prob))
					if (rand(1,2) == 1)
						val = "E" // bit corruption error
					else
						val = val ? 0 : 1 // bit flip error
				ret += "[val]"
		if (length(ret) > 1024)
			ret = copytext(ret, 1, 1025)
		return ret

	proc/debinarize(var/bits)
		var/txt = ""
		var/groups = round(length(bits) / 8)
		for (var/i = 1, i <= groups, i++)
			var/sum = 0
			var/cnt = 1
			for (var/j = 128, j > 0, j /= 2)
				var/d = ascii2text(text2ascii(bits, (i - 1) * 8 + cnt))
				switch (d)
					if ("1")
						sum += j
					if ("E")
						if (prob(50))
							sum += j
				cnt++
			txt += ascii2text(sum)
		return txt

/datum/language/feather
	id = "feather"
	var/static/regex/getWords = new("\\b\\w+\\b", "g")

	proc/translate(var/message)
		. = getWords.Replace(message, /proc/genFeatherWord)

	heard_not_understood(var/orig_message)
		return translate(orig_message)

// making that dumb prototype byond game that went nowhere finally led somewhere good
// if anyone knows how i can make this not global scope, PLEASE HELP ME
/proc/genFeatherWord(var/word)
	. = ""
	var/list/assembled = list()
	var/loopIterations = max(3, length(word))
	for(var/i = 1, i <= loopIterations, i++)
		var/subChar = ""
		var/char = ""
		if(i == 1)
			subChar = "c"
		else if(i == loopIterations)
			subChar = "w"
		else
			subChar = "a"

		if(i <= length(word))
			char = copytext(word, i, i+1)
		else
			char = copytext(word, -1)
		if(isUpper(char))
			subChar = uppertext(subChar)
		assembled += subChar
	. = assembled.Join()

/datum/language/clockwork
	id = "clockwork"
	var/static/list/wingdings_map = getWingDingsMap()

	proc/translate(var/message)
		var/list/newwords = list()
		for (var/i = 1, i <= length(message), i++)
			var/char = copytext(message, i, i + 1)
			var/lower_char = lowertext(char)
			if (lower_char in wingdings_map)
				newwords += wingdings_map[lower_char]
			else
				newwords += char // Retain untranslatable characters
		return jointext(newwords, "")

	heard_not_understood(var/orig_message)
		return translate(orig_message)

/proc/getWingDingsMap()
    return list(
        "a" = "\u2702", // Scissors
        "b" = "\u2705", // Checkmark
        "c" = "\u2708", // Airplane
        "d" = "\u2709", // Envelope
        "e" = "\u270F", // Pencil
        "f" = "\u2713", // Checkmark
        "g" = "\u2714", // Heavy Checkmark
        "h" = "\u2716", // Heavy Multiplication X
        "i" = "\u271D", // Latin Cross
        "j" = "\u2721", // Star of David
        "k" = "\u2728", // Sparkles
        "l" = "\u2736", // Six Pointed Star
        "m" = "\u273D", // Heavy Teardrop Spoked Asterisk
        "n" = "\u2744", // Snowflake
        "o" = "\u2747", // Sparkle
        "p" = "\u274C", // Cross Mark
        "q" = "\u274E", // Negative Squared Cross Mark
        "r" = "\u2756", // Black Diamond Minus White X
        "s" = "\u2764", // Heart
        "t" = "\u2794", // Arrow
        "u" = "\u279E", // Triangle Arrowhead
        "v" = "\u27A1", // Rightwards Arrow
        "w" = "\u27B2", // Curly Loop
        "x" = "\u27B3", // Arrowhead
        "y" = "\u27BF", // Double Curved Arrow
        "z" = "\u2600", // Sun

        // Digits
        "0" = "\u278A", // Circled Digit Zero
        "1" = "\u278B", // Circled Digit One
        "2" = "\u278C", // Circled Digit Two
        "3" = "\u278D", // Circled Digit Three
        "4" = "\u278E", // Circled Digit Four
        "5" = "\u278F", // Circled Digit Five
        "6" = "\u2790", // Circled Digit Six
        "7" = "\u2791", // Circled Digit Seven
        "8" = "\u2792", // Circled Digit Eight
        "9" = "\u2793", // Circled Digit Nine

        // Common punctuation
        "." = "\u2022", // Bullet
        "," = "\u2044", // Fraction Slash
        "!" = "\u2757", // Heavy Exclamation Mark
        "?" = "\u2753", // Black Question Mark
        "@" = "\u272A", // Circled Asterisk
        "#" = "\u273F", // Black Florette
        "$" = "\u260E", // Telephone
        "%" = "\u262F", // Yin Yang
        "&" = "\u2692", // Hammer and Pick
        "*" = "\u2605"  // Black Star
    )
