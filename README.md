# Challenge: Deliberative Polls

This is my challenge application which implements a (very) simplified deliberative polling process: a user can create a poll, on which he is considered to be the expert (currently only one expert user per poll). The others can respond to it until it is ended by its creator.

The expert user must respond to the poll before ending it. When he ends the poll, he tries to convince each other responder that the answers he has given to the poll are the best. According to the expert's influence, the others will change their mind or not. An history of the results before validation is saved, so the results with and without applying the expert's influence on responders can be compared.

You can directly visit the [Heroku production of the application here](http://deliberativepolls.herokuapp.com).