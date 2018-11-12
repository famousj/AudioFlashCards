# Audio Flash Cards

## The Idea

## Value and MVP

First, consider delivering value.  Here's how I see things:

- A randomized set of flash cards.  Just like the paper cards only on my phone
- Flash cards that listen for an answer and let you know if it's right or wrong
  (Alternately, this might be "scaffolded" with some buttons for manual entry)
- Profiles: keep track of settings for families with multiple kids
- Other operations, subtraction, multiplication, etc.

Now that I laid it all out, my MVP is a set of cards showing numbers 0-9 for one number and 0-9 for the other number.  No audio.  No way of knowing if the answers were right.

I think a "Minimum Lovable Product" would have speech recognition.  Put the wrong cards at the back, and just go through all of them until you get them all right.

Space repetition (or SRS) after that.  If I'd want to go through the trouble of putting something on the App Store, I would want it to have this.

##  Brass Tacks

So, now to get this thing written!

- Before we consider SRS or speech, we need one flash card.  Then we have a deck of flash cards.

- First create stubs for a model-view-presenter.  Then write the view.  (Note: I always forget how long it takes to go from zero to anything, especially where the view is concerned.)

- So, now we have a card.  Next, hide the answer.  Wire up some events and reveal the answer if you tap the card.  Then tapping again will get the next card.

- Now we need a whole deck of cards, instead of our one generic card.

- Done.  Actually, this was a bit easier than I'd anticipated, which is good, since I think the audio will be harder than anticipated.

- As I'm digging into the speech recognition, you have to grant permission to listen in. (Sensible enough from a privacy standpoint)  Which means that if the user rejects the request for speech recognition, I need to do something.  Either disable the app until the user fixes it or have some kind of manual answer checking.

- Also, speech recognition exists in the realm of engineering, not math.  The phone listens to the user and basically makes a guess about what is being said.  You don't get anything definitive, you just have to decide "yeah, somebody said the right answer".

Apple recognizes this.  You can get a transcription, or you can get a "hypothesis", which will give you a level of confidence.

- For a first pass, I will give a try for the regular transcription, and display the recognition results to the screen.  This might work with a bit of tinkering (e.g. if Apple thinks someone said "mine", it's probably 9.)

- As a policy, I don't write tests for View code.  As part of this, I try to make sure there's almost zero actual logic in the View.  There doesn't seem to be a good way to do unit tests for the speech recognition.  On the other hand, like th e View code, it's either going to work or it isn't.

- So while the speech recognition code is untested, I'll endeavor to keep it isolated and as simple as possible.  There's an unfortunate amount of copy-paste from Apple's code but on the positive side, that code has been well-vetted.

- I have wired the speech recognition listener up to a view at the bottom of the screen, which will show me what iOS _thinks_ was said.  Now I need to figure out if what was said is actually correct.

- Note: in the `SFTranscriptionSegment` object, there's a timestamp which indicates when, in the audio clip, it has found this item.  This can be used to figure out how long it took to answer the question, which I might need for the SRS bit.

- The speech recognition is in good shape.  I have a few common ways that iOS will misunderstand me.  (One common way is to assume I'm saying "sex" instead of "six".  I didn't add that as a near-homonym, but I don't want to add that as a single commit.  So I think I'll just leave it like that for now.)

The last pass will be to dig through the words that iOS thinks it heard and keep going until I find one that is actually a number.  This will fix the above-mentioned six/sex issue, since those are always either #1 or #2 on the list of options.

- Hand-rolling mocks for the speech recognition classes was a bit of a pain, and it's making me not want to finish that piece.  Since I'd also like it to be tested, and making an array of mock speech transcriptions is going to be a bit messy.





