-> Bar

VAR time = 0

=== Bar ===

    It is a gentle night in one of the quiet neighbourhoods on the edge of town. The last light to still burn is that of the bar. Wasteful, you think, so many hours could be saved if they closed early. Yes, you must rid the town of this place where people come to <i>waste</i> time with their friends, time that they could be saving at the time-saving bank.
    - (TopBar)
    * (EnterWhileOpen) [Enter now]
    No time to waste. The sooner you enter, the sooner people will start saving time.
    ~ time = time + 882
    -> EnteringTheBar
    * (EnterWhileClosed) [Wait for the bar to close]
    Easier to convince the bartender when he is not distracted by customers, you think.
    ~ time = time - 4014
    -> EnteringTheBar


= EnteringTheBar

    As you enter the bar {EnterWhileClosed: later that night } you are immediately struck by the homely feel of the decor. Everything here is old, but well tended with obvious time and care. Ludicrous, why spend so much time mending broken things when you can just buy them new again?
    {EnterWhileClosed:
    The bar is empty except for the gentleman behind the bar, who is diligently scrubbing the various surfaces till not a spot remains.
    }
    {EnterWhileOpen:
    The bar is empty except for a small group of older men sitting at a table in a corner with glasses clearly emptied quite some time ago. The bartender is mindlessly scrubbing some glassware waiting for the men to leave.
    }
    Wasteful.
    The bartender--that you know to be Nino from your background check--hasn't noticed your entering.
    - (TopEnteringTheBar)
    * [Take a seat at the bar]
        You take a seat at the bar opposite of where Nino is standing.
        "Oh!" Nino exclaims in surprise. "Hello there, we haven't met before, have we?"
        * * [Introduce yourself]
            "We have not." You say curtly. "I am agent WDV/284/b from the timesaving bank, it has come to my attention that you want to open an account with us."
            "The timesaving bank?" Nino answers confused. "I have never heard of such an establishment I am afraid."
            * * * [I am quite sure you have]
                "I am quite sure you have," you answer, "You must have overheard some of your clientele discussing amongst themselves how to best save time. Have you not?"
                Nino takes a moment to think on it. "I suppose I have." He finally admits. "I hadn't realised they were talking about the timesaving bank." He looks at you still a little confused. "Though I am still not quite sure on what it is you offer."
                - - - (Explanations)
                * * * * [Explain the timesaving bank]
                ~ time = time - 3100
                    -> ExplainTimesavingBank -> Explanations
                * * * * [Show how much time Nino wastes]
                ~ time = time + 1375
                -> HowMuchTimeIsWasted
                - - - -
                -> END              


 = ExplainTimesavingBank
 
    "It is quite self-explanatory." You begin. "At the timesaving bank you simply save up all unspent time, which of course you'd be able to cash out later with interest."
    "And how exactly would, well you know..." The bartender begins before stopping and scratching his head.
    * [Let him finish his question]
        "well, I am not sure where to start exactly." Nino continues after a while. "To be honest it sounds like some esoteric nonsense to me." He finally concludes.
        ~ time = time - 441
    * [Interrupt him]
        ~ time = time + 1279
    -
        * * [Do not worry about the details]
            "The precise workings are unimportant. What matters are the results. All you have to do is save time, and we will take care of the rest."
            Nino takes another moment to think about it.
            ~ time = time - 373
                * * * [Press him]
                    "You see, if you did not let those gentlemen linger for so long, and if you spend less time cleaning, think of all the seconds you'd save a day."
                    A flash of anger appears on Nino's face. "Those gentlemen are good people and good friends; it is my pleasure to accommodate them."
                    ~ time = time + 342
                    * * * * [Apoligize]
                        "That was a bad example, but think about it, there are plenty of moments in the day where you waste your hours. If not the gentlemen, there must be other things you could do to save time."
                        Nino seems to accept your apology. Tentatively he answers: "I suppose there are some things I waste time on. I could save some time here and there."
                        ~ time = time + 919
                        ->->
                    * * * * [Press further]
                        "And what does their company provide you? Nothing! Not money, not time, nothing! If you had never let them linger then by my calculations you'd have saved 39420000 seconds with which you could've made something of yourself."
                        "Well, I, I..." Nino begins flustered, clearly distraught by the large number you mentioned. "That is a lot of time, isn't it?
                        ~ time = time + 8555
                        ->->
                * * * [Let him think]
                    After a while Nino slowly nods his head. "You make a good point. Well then, what could I do to save some time?"
                    ~ time = time - 211
                    -> HowToSaveTime

        * * [It is quite simple]
            "It is quite easy, simply forego activities that don't bring you wealth of fame, and make haste with the things that do. Then, all the seconds that you save this way will be deposited directly in the timesaving bank, to be retrieved at a later date by you."
            Nino slowly nods his head. "You make a good point. Well then, what could I do to save some time?"
            ~ time = time + 1432
            -> HowToSaveTime
    - - - -
    
    ->->


= HowMuchTimeIsWasted

    You bring out your notebook and calculate quickly all the seconds Nino wastes during the day. The total is a staggering 1,549,123,900 seconds that could have been saved.
    "That certainly is a lot" Nino says with blank eyes, clearly shocked by the large number.
    * [Here is how you can start saving time]
        -> HowToSaveTime


= HowToSaveTime

    * [Start with simple things]
        "Just start with the simple things. Stop spendings so much time cleaning when closing shop. Don't spend so much time on useless things like small-talk and presentation."
        Nino nods thoughtfully. "Yeah, that makes sense. Let’s start with that."
        ~ time = time + 4560
        -> TimeStolen
    * [Much must change]
        "If you want to save any meaningful amount of time starting from your age, I am afraid you must make drastic changes." You list all the things Nino must do, most important of which is to close shop on time, irrespective of who may be present at the time. {EnterWhileOpen: 
            "You could start by sending those freeloading gentlemen home for instance." You conclude.
            "I could never! They are clients yes, but they are also friends."
            -> SendFriendsHome
            }
        "I do not like it, but I see the sense in it. I will try to follow your examples." Nino admits.
        ~ time = time + 11071
        -> TimeStolen


= SendFriendsHome

    * [Friends do not bring value]
        "And what have those <i> friends </i> of yours brought you? True friends would value your time, and leave on time."
        "I cannot just tell them to leave." Nino tries desperately.
        * * [Yes, you can]
            "Of course you can. If they truly are friends, they'd understand. Just try it, and see how much time you save tonight."
            "All right, I’ll try." And with those word Nino slowly moves to the corner table where the gentlemen are busy with a game of cards.
            You tip your hat as Nino points to you trying to explain to the men why they need to leave, and after a small back and forth they finally head to the door.
            * * * [See how easy it is]
                "See how easy it is," you state matter-of-factly, <>
            * * * [Think of all the time you just saved]
                "Do that every night, and imagine what time you could save," you point out, <>
            - - -
            <> "now apply this to the rest of your life, and your account with us will be overflowing in no time. No time at all."
            ~ time = time + 24417
        * * [Then find some other way]
            "Then think of other ways to get them to leave. The method matters not, only the results. Only the time that you will invariably save."
            ~ time = time + 9235
        - -
        The light in Nino's eyes is somewhat extinguished. Perfect. Those are the eyes of someone ready to save time.
        -> TimeStolen


=== TimeStolen

    You stole {time} seconds from Nino!
    -> END
