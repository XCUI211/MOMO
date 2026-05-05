// Define global variable: the time the player has stolen (in minutes)
VAR stolen_time = 0

-> baker_encounter

=== baker_encounter === 

You adjust your gray bowler hat as you enter the warm glow of the bakery. The air smells of fresh bread, slowly fermented, carefully shaped, lovingly baked.

Behind the counter stands Fusi the Baker, decorating fresh out of the oven cupcapes with rainbow colored frosting. her hands move with precision, but her eyes flick nervously toward the clock.

Perfect. She already appears anxious about her time management.

You take a long drag of your cigar. The warmth of the bakery fades a bit. How do you begin?

* [Fuel her time anxiety.]
    ~ stolen_time += 20
   
    "Your baking seems... inefficient. How long did it take you to finish this batch?"
    Fusi stiffens. "Well... good bread takes time... doesn’t it?" You see doubt flicker behind her pride, and then shift to confusion. "But... who are you to begin with?"
    -> baker_turn_2a

* [Question her work capacity.]
    ~ stolen_time += 25
    
    "What a cozy little bakery, all these pastries smell and look amazing. A pity it is so small, imagine a ten more tables and having more space: ten times more customers, ten times more profit."
    Her eyes widen. "Ten times...? But... I would need... more ovens... less rest..." She seems weary, but you see ambition brighten her eyes . 'Great, she's already taking the bait.' 
    "But, who are you and why are you questioning about this? I haven't seen you around before..." Fusi asks.
    -> baker_turn_2b


=== baker_turn_2a ===

"I am agent WDV/284/b from the timesaving bank. We help precious citizens like you save and stop wasting time."
She glances at the clock again. The hook is set. "But... how does one... save time in baking?"
    
    * ["Skip the slow fermentation, add refined and processed ingredients. Faster baking, same profit."]
        ~ stolen_time += 5
        
        "Skip the slow fermentation, add refined and processed ingredients. Faster baking, same profit."
        
        Fusi hesitates... then nods slowly. "Customers wouldn’t notice... would they?"
        Her intergrity begins to rot from within.
        -> baker_turn_3a
    
    * ["Stop chatting with customers. Every conversation is time wasted you could've been baking."]
        ~ stolen_time += 0
        
        "Stop chatting with customers. Every conversation is time wasted you could've been baking."
        
        She looks around the empty shop. "Yes... I do talk too much..."
        Her warmth begins to fade.
        -> baker_turn_3b
    
    * ["Actually... never mind. Good bread takes time. Keep doing what you're doing".]
        ~ stolen_time -= 0
        
        "Actually... never mind. Good bread takes time. Keep doing what you're doing."
        She smiles with relief. "Yes... that’s true."
        Her confidence stabilizes. You just sabotaged yourself.
        -> baker_turn_3c
        


=== baker_turn_2b ===

"I am agent WDV/284/b from the timesaving bank. We help precious citizens like you save and stop wasting time."
    
"I have never heard of such bank." Fusi leans forward, breathing faster. "Ten times the customers... I could be the best baker in the city!"
    
    * ["Exactly. But only if you stop wasting time on perfection."]
        ~ stolen_time += 0
        
        "Exactly. But only if you stop wasting time on perfection."
        
        She clenches her fists. "Perfection? That wastes time... yes..."
        Her standards begin to collapse.
        -> baker_turn_3b
    
    * ["Hire workers. Replace care with speed. Scale is everything."]
        ~ stolen_time += 0
        
        "Hire workers. Replace care with speed. Scale is everything."
        
        She nods rapidly. "Yes... more hands, faster production..." She starts thinking like a machine.
        -> baker_turn_3a
    
    * ["But more customers also means more responsibility. And more stress."]
        ~ stolen_time -= 0
        
        "But more customers also means more responsibility. More stress."
        
        She freezes. "Stress...? I already feel tired..." You accidentally triggered her self-awareness.
        -> baker_turn_3c


=== baker_turn_3a ===
Fusi Begins to work on a new batch. Her hands move faster now, too fast. The dough becomes uneven as she mutters: "Faster, faster, faster. Customers won’t notice... right?"

* ["Good. Now shorten baking times too. Burn less fuel, save more minutes."]
    ~ stolen_time += 5
    "Good. Now shorten baking times too. Burn less fuel, save more minutes."
    
    The bread comes out pale and hollow. Fusi doesn’t even taste it.
    You inhale thick clouds of wasted craftsmanship and poorly made bread.
    -> baker_success

* ["Exactly, why even bake fresh? Sell yesterday’s bread as today’s."]
    ~ stolen_time += 5
    "Exactly, why even bake fresh? Sell yesterday’s bread as today’s."
    
    She hesitates... then shrugs. "Bread is bread..."
    She completely forgets her pride.
    -> baker_success

* ["This looks terrible. Even faster, you’re still behind!"]
    ~ stolen_time += 0
    "This looks terrible. Even faster, you’re still behind!"
    
    Panic sets in. She starts working faster, batch after batch, without caring for the quality of the bread.
    -> baker_success


=== baker_turn_3b ===
Fusi stops smiling entirely and starts working like a machine.

"No time... no talking... only baking..." She wispers to herself.

* ["Perfect. From now on, every saved minute goes to us for safekeeping."]
    ~ stolen_time += 5
    "Perfect. From now on, every saved minute goes to us for safekeeping."
    
    Her humanity fades into a gray routine.
    -> baker_success

* ["Remove all decoration too. Plain bread is faster."]
    ~ stolen_time += 0
    "Remove all decoration too. Plain bread is faster."
    
   She strips away all artistry. The bakery becomes lifeless.
    -> baker_success

* ["You look exhausted from working without rest. Maybe you should take a break."]
    ~ stolen_time -= 0
    "You look exhausted from working without rest. Maybe you should take a break."
    
    She pauses and blinks slowly. "Rest...?" A dangerous thought. Warmth begins to return.
    -> baker_failed


=== baker_turn_3c ===
Fusi wipes her hands slowly. Her breathing steadies. "I like baking the way I do it..."

* ["You’ll go bankrupt with that attitude."]
    ~ stolen_time += 0
    "You’ll go bankrupt with that attitude."
    
    Doubt creeps back in. You sigh in relief. 'You idiot, almost ruined it!'
    -> baker_success

* ["You’re right. Good things take time."]
    ~ stolen_time -= 0
    "You’re right. Good things take time."
    
    Her confidence solidifies. The bakery feels warmer again.
    Your cigar flickers weakly.
    -> baker_failed

* [You knock over a tray of dough. "Don't be stupid! That way you're just gonna be wasting time!"]
    ~ stolen_time -= 0
    You knock over a tray of dough. "Don't be stupid! That way you're just gonna be wasting time!"
    
    She gasps in frustration. .
    -> baker_failed



=== baker_success ===
This is it. The ovens hum. The clock ticks loudly.
You must secure the contract now.

* ["Sign this Time Savings Agreement. We guarantee you maximum efficiency."]
    ~ stolen_time += 5
    "Sign this Time Savings Agreement. We guarantee you maximum efficiency."
    
    In her anxious state, Fusi signs without reading.
    The bakery fills with gray smoke as years of joy are extracted.
    -> baker_end

* ["If you don’t follow our suggestions, your competitors will destroy you. If you sign with us, we can garantee you a lifetime of saved time."]
    ~ stolen_time += 5
    "If you don’t follow our suggestions, your competitors will destroy you. If you sign with us, we can garantee you a lifetime of saved time."
    
    Fear overwhelms her. She doubts if she should sign, but does so eventually.
    -> baker_end



=== baker_failed ===
"Forget all this." Fusi says. "I like things the way they are, I don't care what you say."
    ~ stolen_time -= 5
    -> baker_end



=== baker_end ===
--------------------------------------------------
END OF CONVERSATION:

You stole {stolen_time} minutes from Fusi!
--------------------------------------------------
You turn and vanish into the gray mist of the city, preparing for your next target.
-> END
