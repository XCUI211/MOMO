// Define global variable: the time the player has stolen (in minutes)
VAR stolen_time = 0

Rain taps softly against the pavement outside a small barbershop in the center of town.

Inside, Mr. Figaro stands by the door, waiting. "Life is passing me by... What do I have to show for it?" You hear him mutter to himself. "If I had more time... I could be something else. Someone better." 

'This is great! He's already drowning in self-pity, this should be easy.' You realize happily as you walk up to the barbershop.

"... A customer! What can I do for you? A shave? A haircut?" Mr. Figaro welcomes you, feeling very excited to finally have a customer.

    + [A haircut]
        ~ stolen_time -= 0
        
        "A haircut." You answer plainly.
        You are bald so this confuses Figaro greatly. You end up staring at each other in silence.
        
        "Anyways, I am actually here from the Timesaving Bank, I am agent WDV/284/b." You start conversing awkwardly. 
        
        "You have been wasting your life on meaningless things and the only way to turn your life around is to start saving time, which is precisely what our bank specializes in."
    
        -> trust
    
    + [Neither, I am from the Timesaving Bank]
        ~ stolen_time -= 0
        
        "Neither, I am agent WDV/284/b from the timesaving bank." You introduce yourselft.
    
        Mr. Figaro looks at you confused. "The Timesaving Bank? What is that?"
    
        "You have been wasting your life on meaningless things and the only way to turn your life around is to start saving time, which is precisely what our bank specializes in."
    
        -> trust

=== trust ===

"Hmm... can I trust this stranger?" Mr. Figaro mutters to himself, you see his eyes full of doubt.

    + [Twirl your moustache]
        ~ stolen_time += 10
     
        You twirl your moustache.
    
        'A man with a moustache like that must know what he’s doing with life.' You can almost hear Mr. Figaro thoughts.
        
        -> work
    
    + [Walk around the store]
    ~ stolen_time += 10
    
        You walk around the store.
    
        'Is he judging my store? I should have cleaned a bit more...' Mr. Figaro thinks to himself as you walk around seemingly evaluating the store.
        
        -> work


=== work ===

"So how do I go about saving time?" Mr. Figaro is getting a little impacitent.

"Well what does your day at work look like?" You decide to get to the point and stop wasting time, such irony.

"Well... I um cut hair." 

"Yes, yes, but what else?"

"I guess I talk to them? I create a pleasant space where they can enjoy having their hair done"

"That’s exactly what I was afraid of." You mutter appearing disappointed. "You keep wasting time on meaningless things."

Mr. Figaro starts defending himself, not wainting to disappoint such appearing distinguished gentelman. "Well I can’t exactly avoid talking to my customers-" 

"Of course you can avoid it!"

    + [Stop talking so much, it slow downs business!]
        ~ stolen_time += 10
        
        "Stop talking so much, it slow downs business!"
        
        -> more
        
    + [Mirrors are distractions. Focus on working efficiently, customers will have to stop talking about their looks.]
        ~ stolen_time += 5
        
        "Mirrors are distractions. Focus on working efficiently, customers will have to stop talking about their looks." You emphazise loudly. 
        "Ask them beforehand if they think what they have to say is relevant to your work."
        
        -> efficiency
        
    + [But I guess it's fine. Creating a fine atmosphere gives comfort to the customers.]
        ~ stolen_time -= 0
        
        "But I guess it's fine. Creating a fine atmosphere gives comfort to the customers."
        
        -> failed

=== more ===

"Look at this empty shop. Are you just pretending to be successful?" 

He looks dejected. "But... I do have clients... only a few regulars, I guess..." You hear his voice shrink to whisper. 

"People know you are slow, eventually they will all leave somewhere else." You continue to provoke him.

And it works. "Then..." He starts slowly. "How can I improve and work faster?"

    + [Hire more workers. Imagine doubling your clients. Triple bookings. No empty chairs.]
        ~ stolen_time += 5
        
        "Hire more workers. Imagine doubling your clients. Triple bookings. No empty chairs."
        
        His eyes light up. "No empty chairs... all day full..." Ambition takes over his doubt.
    
        -> success
        
    + [Have more hooded floor hair dryers. You won't have to manually dry hair.]
        ~ stolen_time += 10
        
        "Have more hooded floor hair dryers. You won't have to manually dry hair."
        
        "But... the quality might not be as good." He says a bit doubtfull.
        
        "It still gets the job done. You can then stack appointments. Make them wait, it will prove you’re in demand." You continue convincing him.
        
        "I see..." He mutters to himself. "I can do the job and people will see I am well-sought-after..."
        
        -> success
        
    + [Or maybe quality matters more than quantity.]
        ~ stolen_time -= 5
        
        "Or maybe quality matters more than quantity."
        
        -> failed

=== efficiency ===

Mr. looks unsure. "But how will that help me save time...?" He asks.

"well, by those activities are useless." You say as if it's a matter of fact. "Saving time is all about being efficient, and the more time you save by being efficient, the more you can rest and enjoy afterwards."

Mr. Figaro looks encouraged. "I see! I can become more successful and enjoy more free time after!" He then pauses. "But... how can I be more efficient?"

    + [Take two clients at once. Alternate between them.]
        ~ stolen_time += 5
        
        "Take two clients at once. Alternate between them."
        
        -> success
        
    + [Work faster. Shorten every haircut. Precision is overrated]
        ~ stolen_time += 10
        
        "Work faster. Shorten every haircut. Precision is overrated."
        
        He nods quickly. "Yes... faster cuts... less talking..."
    
        -> success

=== success ===

He's already taken the bait. Continue to lure him in.

    + [Sign this Time Savings Agreement. We'll help you improve your efficiency so you can enjoy your saved time after retirement.]
        ~ stolen_time += 10
        
        "Sign this Time Savings Agreement. We'll help you improve your efficiency so you can enjoy your saved time after retirement."
        
        -> barber_end
        
    + [Sign with us and cut down meaningless activities, it will show your customers your professionalism.]
        ~ stolen_time += 5
        
        "Sign with us and cut down meaningless activities, it will show your customers your professionalism."
        
        -> barber_end

=== failed ===

"Exactly, I don't need to change anything!" he says excited.

You useless fool, you completely ruined it.

-> barber_end

=== barber_end ===
--------------------------------------------------
END OF CONVERSATION:

You stole {stolen_time} minutes from Mr. Figaro!
--------------------------------------------------
You turn and vanish into the gray mist of the city, preparing for your next target.

-> END