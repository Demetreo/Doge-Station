/datum/event/radiation_storm
	announceWhen	= 1
	var/safe_zones = list(
		/area/maintenance,
		/area/crew_quarters/sleep,
		/area/security/brig,
		/area/shuttle,
		/area/vox_station,
		/area/syndicate_station
		)


/datum/event/radiation_storm/announce()
	// Don't do anything, we want to pack the announcement with the actual event

/datum/event/radiation_storm/proc/is_safe_zone(var/area/A)
	for(var/szt in safe_zones)
		if(istype(A, szt))
			return 1
	return 0

/datum/event/radiation_storm/start()
	spawn()
		event_announcement.Announce("Elevados n�veis de radia��o detectados perto da esta��o. Evacuue para um dos t�neis blindados de manuten��o.", "Alerta de Anomalias", new_sound = 'sound/AI/radiation.ogg')

		for(var/area/A in world)
			if(!is_station_level(A.z) || is_safe_zone(A))
				continue
			A.radiation_alert()

		make_maint_all_access()

		sleep(600)

		event_announcement.Announce("A esta��o entrou no cinto de radia��o. Mantenha-se em uma �rea protegida at� que passemos pelo cinto de radia��o.", "Alerta de Anomalias")

		for(var/i = 0, i < 10, i++)
			for(var/mob/living/carbon/human/H in living_mob_list)
				var/armor = H.getarmor(type = "rad")
				if((RADIMMUNE in H.species.species_traits) || armor >= 100) // Leave radiation-immune species/fully rad armored players completely unaffected
					continue
				var/turf/T = get_turf(H)
				if(!T)
					continue
				if(!is_station_level(T.z) || is_safe_zone(T.loc))
					continue

				if(istype(H,/mob/living/carbon/human))
					H.apply_effect((rand(15,35)),IRRADIATE,0)
					if(prob(5))
						H.apply_effect((rand(40,70)),IRRADIATE,0)
						if(prob(75))
							randmutb(H) // Applies bad mutation
							domutcheck(H,null,1)
						else
							randmutg(H) // Applies good mutation
							domutcheck(H,null,1)

			sleep(100)

		event_announcement.Announce("A esta��o passou pelo cinto de radia��o. Informe-se para medbay se voc� tiver sintomas incomuns. A manuten��o perder� todo o acesso novamente em breve.", "Alerta de Anomalias")

		for(var/area/A in world)
			if(!is_station_level(A.z) || is_safe_zone(A))
				continue
			A.reset_radiation_alert()

		sleep(600) // Want to give them time to get out of maintenance.

		revoke_maint_all_access()
