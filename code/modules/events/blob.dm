/datum/event/blob
	announceWhen	= 60
	endWhen			= 120
	var/obj/structure/blob/core/Blob

/datum/event/blob/announce()
	event_announcement.Announce("Confirma��o de risco biol�gico a n�vel 5 a bordo da [station_name()]. Todo o pessoal deve conter o surto.", "Alerta de Risco Biol�gico", 'sound/AI/outbreak5.ogg')

/datum/event/blob/start()
	var/turf/T = pick(blobstart)
	if(!T)
		return kill()
	var/list/candidates = pollCandidates("Voc� quer jogar como um blob?", ROLE_BLOB, 1)
	var/mob/C
	if(candidates.len)
		C = pick(candidates)
		Blob = new /obj/structure/blob/core(T, new_overmind=C.client)
		for(var/i in 1 to 5)
			Blob.process()
	else
		return kill()

/datum/event/blob/tick()
	if(!Blob)
		kill()
		return
	if(IsMultiple(activeFor, 3))
		Blob.process()
