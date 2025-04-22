this.pov_hexemut_drunk_event <- this.inherit("scripts/events/event", {
	m = {
		vattghernHexe = null
	},
	function create()
	{
		this.m.ID = "event.pov_hexemut_drunk";
		this.m.Title = "During camp...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/pov_drunk.png[/img]{You\'re used to your men drinking, but not like this. One moment, the camp is as it should be, the next, half your company is sprawled over crates, bedrolls, and each other - blackout drunk. Their snores and drunken murmurs fill the night, empty bottles scattered around like the remnants of a lost battle. The strange thing? You don\’t remember anyone bringing out the drink.\n\n You step over a groaning sellsword and find %vattghern% sitting upright, the only one seemingly unaffected. They swirl a half-empty bottle in their hand, watching the firelight dance inside the glass. %SPEECH_ON% Strange, isn\'t it? No one saw the first pour, yet no one could resist the last. %SPEECH_OFF%} You glance at the bottles. No brewer\’s mark, no sign of their origin. The scent is oddly sweet, but not unpleasant. Whatever it was, it wasn\’t normal. The fire crackles, the only sound in the stillness. You exhale, rubbing your temple. This won\’t be the last time something like this happens.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And now we have to recover...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				/*_event.m.vattghernHexe.worsenMood(0.5, "Admiration comes at a price");
				//_event.m.vattghernHexe.addInjury(this.Const.Injury.BluntBody);
				_event.m.vattghernHexe.addHeavyInjury();
				// ADD MOOD AND INJURY THING HERE

				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.vattghernHexe.getName() + " suffers serious wounds"
				});
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.vattghernHexe.getMoodState()],
					text = _event.m.vattghernHexe.getName() + this.Const.MoodStateEvent[_event.m.vattghernHexe.getMoodState()]
				});*/

				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					if (!bro.getSkills().hasSkill("effects.pov_hexe_mutagen"))
					{
						if (this.Math.rand(1, 100) <= 20)
						{
							bro.improveMood(0.5, "Had a good time in camp. (Does not remember why)");

							if (bro.getMoodState() > this.Const.MoodState.Neutral)
							{
								this.List.push({
									id = 10,
									icon = this.Const.MoodStateIcon[bro.getMoodState()],
									text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
								});
							}
						}

						if (this.Math.rand(1, 100) <= 60)
						{

							local injury = bro.getSkills().add(this.new("scripts/skills/effects_world/drunk_effect"));;
							this.List.push({
								id = 10,
								icon = "skills/status_effect_61.png",
								text = bro.getName() + " became drunk! "
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local vattghern_candidates = [];
		local partySize = brothers.len();

		// Set a minimum party size for this to happen (I dont want to)
		/*if (brothers.len() < 10)
		{
			return;
		}*/
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("effects.pov_hexe_mutagen"))
			{
				vattghern_candidates.push(bro);
			}
		}

		if (vattghern_candidates.len() == 0)
		{
			return;
		}

		this.m.vattghernHexe = vattghern_candidates[this.Math.rand(0, vattghern_candidates.len() - 1)];
		this.m.Score = this.Math.round(5 + (partySize / 2));
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"vattghern",
			this.m.vattghernHexe.getName()
		]);
	}

	function onClear()
	{
		this.m.vattghernHexe = null;
	}

});

