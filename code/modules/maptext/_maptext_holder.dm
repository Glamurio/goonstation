#define MAPTEXT_FADE_IN_DURATION 4
#define MAPTEXT_LINGER_DURATION 36
#define MAPTEXT_FADE_OUT_DURATION 4

#define MAPTEXT_FADE_IN_DISTANCE 6
#define MAPTEXT_FADE_OUT_DISTANCE 8
#define MAPTEXT_SCALE_FACTOR 1.05


/**
 *	Maptext holders are `atom/movable`s that are attached to a parent maptext manager, and are responsible for displaying maptext
 *	images to a single client. When maptext is required to be displayed to a client, the parent maptext manager will instruct the
 *	maptext holder associated with that client to add a line of maptext to itself and add it to the client's images list.
 */
/atom/movable/maptext_holder
	mouse_opacity = 0

	/// The maptext manager that this maptext holder belongs to.
	var/atom/movable/maptext_manager/parent
	/// The client that this maptext holder is displaying maptext to.
	var/client/client
	/// A list of maptext images currently displayed to the client.
	var/list/image/maptext/lines
	/// The amount by which this maptext holder's `pixel_y` value has been increased as a result of new maptext lines.
	var/aggregate_height = 0

/atom/movable/maptext_holder/New(atom/movable/maptext_manager/parent, client/client)
	. = ..()

	src.parent = parent
	src.parent.vis_contents += src
	src.client = client
	src.lines = list()

/atom/movable/maptext_holder/disposing()
	for (var/image/maptext/line as anything in src.lines)
		src.client?.images -= line
		qdel(line)

	src.parent.maptext_holders_by_client -= src.client
	src.parent = null
	src.client = null
	src.lines = null

	. = ..()

/// Adds a line of maptext to this maptext holder, displays it, animates it scrolling in, and queues its removal.
/atom/movable/maptext_holder/proc/add_line(image/maptext/text)
	// Notify the parent maptext manager if this is the first line of maptext added.
	var/line_number = length(src.lines)
	if (!line_number)
		src.parent.notify_nonempty()

	// If the previous maptext line matches the new one, increase the size of the previous maptext line and exit early.
	else if (src.lines[line_number].maptext == text.maptext)
		src.lines[line_number].transform *= MAPTEXT_SCALE_FACTOR
		qdel(text)
		return

	var/text_height = (text.maptext_height / 6) * (1 + round(length(strip_html_tags(text.maptext)) / 40))
	src.aggregate_height += text_height

	// Add the new maptext line.
	text.loc = src
	text.pixel_y -= src.aggregate_height
	src.lines += text
	src.client.images += text

	// Set up the fade-in animation.
	var/target_alpha = text.alpha
	var/target_pixel_y = text.pixel_y
	text.alpha = 0
	text.pixel_y += text_height - MAPTEXT_FADE_IN_DISTANCE

	// Indicates how fast the maptext fades in & out
	var/speed_multiplier = (HAS_ATOM_PROPERTY(src.parent.parent, PROP_ATOM_TIME_SPEED_MULT) ? GET_ATOM_PROPERTY(src.parent.parent, PROP_ATOM_TIME_SPEED_MULT) : 1)
	var/new_duration = speed_multiplier > 0 ? MAPTEXT_FADE_IN_DURATION * speed_multiplier : MAPTEXT_FADE_IN_DURATION / abs(speed_multiplier)
	var/new_linger = speed_multiplier > 0 ? MAPTEXT_LINGER_DURATION * speed_multiplier : MAPTEXT_LINGER_DURATION / abs(speed_multiplier)

	// Push all maptext lines upwards.
	animate(src, pixel_y = src.pixel_y + text_height, time = new_duration, flags = ANIMATION_PARALLEL)
	// Animate the new line's fade-in.
	animate(text, alpha = target_alpha, pixel_y = target_pixel_y, time = new_duration, flags = ANIMATION_PARALLEL)

	// Remove the maptext line after a short delay.
	SPAWN(new_duration + new_linger)
		if (QDELETED(src))
			return

		// Animate the line's fade-out.
		animate(text, alpha = 0, pixel_y = text.pixel_y + MAPTEXT_FADE_OUT_DISTANCE, time = new_duration, flags = ANIMATION_PARALLEL)

		// Delete the line and clean up.
		SPAWN(new_duration + 1)
			if (QDELETED(src))
				return

			src.lines -= text
			src.client?.images -= text
			qdel(text)

			if (!length(src.lines))
				src.pixel_y -= src.aggregate_height
				src.aggregate_height = 0
				src.parent?.notify_empty(src.client)


#undef MAPTEXT_FADE_IN_DURATION
#undef MAPTEXT_LINGER_DURATION
#undef MAPTEXT_FADE_OUT_DURATION
#undef MAPTEXT_FADE_IN_DISTANCE
#undef MAPTEXT_FADE_OUT_DISTANCE
#undef MAPTEXT_SCALE_FACTOR
