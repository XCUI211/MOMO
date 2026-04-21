// Define global variable: the time the player has stolen (in minutes)
VAR stolen_time = 0

-> beppo_encounter

=== beppo_encounter ===
You straighten your gray suit and take a deep drag of your cigar. The smoke you exhale drains the color from the street.
Ahead of you is Beppo, the street sweeper.
He is sweeping: one step, one deep breath, one sweep. His movements are agonizingly slow. 
You must break his rhythm and make him anxious. How do you open?

* ["Old man, your efficiency is terrible! You'll never hit your lifetime KPIs!"]
    ~ stolen_time -= 10
    [Time -10] Beppo stops, thinks for a full minute, and asks: "What is... a... K... P... I?"
    You waste ten minutes explaining modern corporate management. He doesn't get it, and you just get angry!
    -> beppo_turn_2_slow

* ["What a beautiful rhythm. But if you swept faster, you'd have more time for Momo, right?"]
    ~ stolen_time += 10
    [Time +10] Critical hit! Beppo stops his broom. At the mention of "Momo," his calm eyes flicker.
    "More time... for Momo?" His breathing rhythm breaks.
    -> beppo_turn_2_hooked

* ["Hi! This Dyson V15 super-suction broom can boost your sweeping speed by 300%! I only need your time in exchange!"]
    ~ stolen_time += 5
    [Time +5] Beppo looks at your empty hands (you are literally just painting a picture in the air) and falls into deep confusion. In his bewilderment, he forgets to sweep.
    While his brain is buffering, you sneakily extract 5 minutes!
    -> beppo_turn_2_confused


=== beppo_turn_2_slow ===
He is immune to corporate jargon. You need to steer the conversation back to "saving time," or your cigar will burn out for nothing!
Beppo slowly raises his broom. "This street... is very long. One must never look at the end... Just one step... at a time."

* ["Stop dawdling! Use strategic planning! Take two steps, half a breath, and sweep three times! 300% efficiency!"]
    ~ stolen_time += 20
    [Time +20] Beppo's mind frantically calculates. He tries your "hardcore controls," trips over his own feet, and suffers brain overload.
    -> beppo_turn_3_frustrated

* ["What if the street never ends? You're going to die on this pavement like a useless NPC!"]
    ~ stolen_time -= 10
    [Time -10] Beppo smiles gently. "The next street... is also under my broom."
    His zen-like aura is suffocating. You lose time just listening to him.
    -> beppo_turn_3_unchanged

* ["Move aside! Let me show you how a speedrunner does it!"]
    ~ stolen_time -= 5
    [Time -5] You snatch the broom and sweep like a mad dog for five minutes. Beppo smiles and claps for you.
    You didn't steal time; you just did his chores!
    -> beppo_turn_3_unchanged


=== beppo_turn_2_hooked ===
Excellent. The hook is in.
Beppo sighs, a drop of sweat forming on his forehead. "But... how does one... save time?"

* ["Simple! Skip the meaningless pauses! Don't look at the clouds. Sweep like a relentless machine!"]
    ~ stolen_time += 20
    [Time +20] Beppo grips his broom tighter. He stares dead at the ground, no longer looking at the scenery. The light in his eyes dims.
    -> beppo_turn_3_fast

* ["Deposit your daydreaming time into our 'Time Savings Bank'. We offer compound interest!"]
    ~ stolen_time += 15
    [Time +15] Beppo looks confused. "Time... can be deposited?" You seize the moment and rapid-fire an 80-page liability waiver at him.
    -> beppo_turn_3_fast

* ["Just sweep the trash directly into the sewer grates. Nobody will notice, and it saves two hours a day."]
    ~ stolen_time -= 10
    [Time -10] Beppo looks at you sternly. "Sweeping... is sacred. One cannot... cheat it."
    You touched his professional bottom line. His defenses go up.
    -> beppo_turn_3_unchanged


=== beppo_turn_2_confused ===
Beppo is still staring at your empty hands, trying to visualize the "Dyson V15." You need to capitalize on this mental blue-screen!

* [Snap your fingers aggressively in his face. "Wake up! Every second you spend thinking is a second stolen from your retirement fund!"]
    ~ stolen_time += 10
    [Time +10] The sudden noise jolts him. He drops his broom in a brief panic, leaking a solid chunk of temporal energy.
    -> beppo_turn_3_anxious

* ["While you were daydreaming, your neighbors just saved three hours. You are falling behind, Beppo."]
    ~ stolen_time += 10
    [Time +10] Peer pressure works wonders. Beppo's eyes widen as the fear of missing out takes hold of his usually calm demeanor.
    -> beppo_turn_3_anxious

* [Try to physically snatch his broom while he's distracted.]
    ~ stolen_time -= 10
    [Time -10] He may be slow, but his grip is iron. You end up playing an awkward game of tug-of-war. You look ridiculous and waste precious minutes.
    -> beppo_turn_3_unchanged


=== beppo_turn_3_fast ===
Beppo's movements are much faster now, but stiff and erratic.
He mutters to himself like a maniac: "Faster... must go faster... save time... for the future..."

* ["Exactly! From today on, no more chatting with friends, no more slow meals! Give every saved second to me, and we will keep it safe for you"]
    ~ stolen_time += 30
    [Time +30] A perfect drain! Beppo is now a numb sweeping machine. You inhale a massive cloud of rich, gray time.
    -> beppo_turn_4

* ["Yes! If you sweep fast enough, the friction might even let you time travel, old man!"]
    ~ stolen_time += 20
    [Time +20] Beppo buys your nonsense and spins in a high-speed circle until he vomits. You got time, but it smells like stomach acid.
    -> beppo_turn_4

* ["Never mind... you look miserable. Stop sweeping and go have some tea with Momo."]
    ~ stolen_time -= 20
    [Time -20] You show mercy (WARNING: Severe Grey Man violation!).
    Beppo takes a deep breath, regaining his peace. Your stolen time is purified and leaks away!
    -> beppo_turn_4
    

=== beppo_turn_3_frustrated ===
Beppo is sweating profusely. The joy of sweeping is dead. "Why are you doing this to me?!" he yells.

* ["Because the clock is ticking, Beppo! Every second you cry is a second wasted!"]
    ~ stolen_time += 20
    [Time +20] His frustration turns into sheer panic. He frantically tries to sweep while wiping his tears, generating delicious, chaotic time-sparks.
    -> beppo_turn_4

* ["I am simply optimizing your workflow to align with modern synergistic paradigms."]
    ~ stolen_time -= 10
    [Time -10] You went back to corporate jargon. His frustration turns to extreme boredom. He stops sweeping to massage his temples.
    -> beppo_turn_4

* ["Sign this timesaving contract, and the pain stops forever!"]
    ~ stolen_time += 15
    [Time +15] He looks at your contract like it's a lifeline. He hasn't signed yet, but his willingness to give up is radiating time into your jar.
    -> beppo_turn_4


=== beppo_turn_3_anxious ===
Beppo is jittery. He keeps looking over his shoulder, convinced he is running out of time. 

* ["If you don't hurry, Momo will grow up and you won't have any time left for her!"]
    ~ stolen_time += 30
    [Time +30] A devastating psychological blow! The fear of abandoning Momo shatters his remaining zen. You feast on his overwhelming anxiety.
    -> beppo_turn_4

* ["Look at the shadows! The sun is setting! You've accomplished nothing today!"]
    ~ stolen_time += 15
    [Time +15] He stares at the sun, horrified. He tries to sweep faster but just ends up pushing the same pile of dirt around.
    -> beppo_turn_4

* ["Take it easy, I was just kidding. You have all the time in the world."]
    ~ stolen_time -= 25
    [Time -25] You break character! Giving a victim reassurance is poison to a Man in Grey. Your cigar shrinks rapidly.
    -> beppo_turn_4


=== beppo_turn_3_unchanged ===  
He is completely at peace. Your words slide right off him. This is your last chance to save face before the final push.
    
* ["You are impossible."]
    ~ stolen_time -= 10
    [Time -10] You storm off in frustration. His unshakeable zen drains your own precious lifespan.
    -> beppo_turn_4

* [Charge forward and snap his broom in half over your knee.]
    ~ stolen_time += 10
    [Time +10] You break his tools. He looks slightly sad, but not panicked. You scrape together a tiny bit of time from his mild disappointment.
    -> beppo_turn_4

* [Stare at him in awkward, aggressive silence for ten minutes.]
    ~ stolen_time -= 10
    [Time -10] It doesn't work. He just sweeps around your shoes. You wasted your own time.
    -> beppo_turn_4


=== beppo_turn_4 ===
This is your last chance. You can sense that in the nearby amphitheater, that girl named Momo is listening to someone. Time is running out. You must take down Beppo right now!

* [Snatch his broom! "If you don't sign, this broom becomes the property of the Timesaving Bank!"]
    Beppo doesn't get angry. Instead, he slowly walks to the curb and sits down: "Then... I will... just... wait a bit."
    He is actually starting to enjoy doing nothing! You stole absolutely nothing and suffered the backlash of the laws of Time!
    ~ stolen_time -= 20
    -> beppo_end

* [Hand him a form full of dense gibberish. "This is the Imperial Broom Upgrade and Maintenance Annual Review. You must sign within 5 seconds, or your sweeping license will be revoked!"]
    "Five seconds... is too fast..." Though Beppo finds it strange, under the panic of losing his "license," he subconsciously scribbles his name as fast as he can.
    The Time Contract is sealed! A massive amount of time turns into grey smoke and is sucked into your briefcase!
    ~ stolen_time += 30
    -> beppo_end

* [Blow thick grey smoke right in his face and shout like a broken record: "Time is money! Efficiency is life! Hurry, hurry, hurry!"]
    The dense grey smoke and the high-frequency noise make Beppo feel extremely exhausted. He lets out a massive yawn and actually falls asleep leaning against the wall.
    Facing a sleeping man—especially one having very slow dreams—a Man in Grey is completely powerless.
    ~ stolen_time -= 10
    -> beppo_end
    
    
=== beppo_end ===
--------------------------------------------------
You adjust your grey bowler hat and check the time-savings jar in your hand.

[System Evaluation] Total time stolen from Beppo Roadsweeper: {stolen_time} minutes.

{ stolen_time >= 40:
    [Bountiful Harvest] Unbelievable! You managed to squeeze so much time out of a stubborn old rock like Beppo. Armed with this massive fortune, you have a much better chance of defeating Momo!
}
{ stolen_time > 0 and stolen_time < 40:
    [Barely Acceptable] At least you didn't take a loss. Stealing time from Beppo is harder than climbing to heaven; taking whatever you can get is good enough. Hurry up and find your next victim.
}
{ stolen_time <= 0:
    [Absolute Disgrace] You are a disgrace to all Men in Grey! Not only did you fail to steal time from Beppo, but he actually drained your life force! If you keep this up, you'll fade into nothingness before you even lay eyes on Momo.
}
--------------------------------------------------
You turn and vanish into the gray mist of the city, preparing for your next target: the Barber.
-> END
