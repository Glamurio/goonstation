TYPEINFO(/atom/movable/abstract_say_source/artifact_fabricator)
	start_speech_outputs = list(SPEECH_OUTPUT_SPOKEN)

/atom/movable/abstract_say_source/artifact_fabricator/proc/update_language(datum/language/lingo)
	src.say_language = lingo.id

/atom/movable/abstract_say_source/artifact_fabricator/proc/process_message(string)
    RETURN_TYPE(/datum/say_message)

    var/datum/say_message/message = src.say(string, flags = SAYFLAG_DO_NOT_OUTPUT)
    if (message)
        message = message.language.heard_not_understood(message)
    return message