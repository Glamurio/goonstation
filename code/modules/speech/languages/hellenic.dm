/datum/language/hellenic
    id = LANGUAGE_HELLENIC

/datum/language/hellenic/heard_not_understood(datum/say_message/message, datum/listen_module_tree/listen_tree)
    . = ..()
    APPLY_CALLBACK_TO_MESSAGE_CONTENT(message, CALLBACK(src, PROC_REF(to_hellenic)))

/datum/language/hellenic/proc/to_hellenic(str)
    var/static/list/hellenic_map = list(
        "a" = "α", "b" = "β", "c" = "c", "d" = "δ", "e" = "ε", "f" = "φ", "g" = "γ",
        "h" = "η", "i" = "ι", "j" = "ϳ", "k" = "κ", "l" = "λ", "m" = "μ", "n" = "ν",
        "o" = "ο", "p" = "π", "q" = "θ", "r" = "ρ", "s" = "σ", "t" = "τ", "u" = "υ",
        "v" = "ν", "w" = "ω", "x" = "χ", "y" = "ψ", "z" = "ζ", "?" = "﹖", "!" = "﹗"
    )

    var/output = ""
    for (var/i = 1, i <= length(str), i++)
        var/ch = copytext(str, i, i+1)
        var/lower = lowertext(ch)
        if (hellenic_map[lower])
            output += hellenic_map[lower]
        else
            output += ch

    if (length(output) > MAX_MESSAGE_LEN)
        output = copytext(output, 1, MAX_MESSAGE_LEN)

    return output