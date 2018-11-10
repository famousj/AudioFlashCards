# Audio Flash Cards

## The Idea

## Value and MVP

First, consider delivering value.  Here's how I see things:

- A randomized set of flash cards.  Just like the paper cards only on my phone
- Flash cards that listen for an answer and let you know if it's right or wrong
  (Alternately, this might be "scaffolded" with some buttons for manual entry)

- Profiles: keep track of settings for the various LeBlanc boys
- Other operations, subtraction, multiplication, etc.

Now that I laid it all out, my MVP is a set of cards showing numbers 0-9 for one number and 0-9 for the other number.  No audio.  No way of knowing if the answers were right.

I think a "Minimum Lovable Product" would have speech recognition.  Put the wrong cards at the back, and just go through all of them until you get them all right.

Space repetition (or SRS) after that.  If I'd want to go through the trouble of putting something on the App Store, I would want it to have this.


##  Brass Tacks

So, now to get this thing written!

Before we consider SRS or speech, we need one flash card.  Then we have a deck of flash cards.

First create stubs for a model-view-presenter.  Then write the view.  (Note: I always forget how long it takes to go from zero to anything, especially where the view is concerned.)

So, now we have a card.  Next, hide the answer.  Wire up some events and reveal the answer if you tap the card.  Then tapping again will get the next card.

Now we need a whole deck of cards, instead of our one generic card.
