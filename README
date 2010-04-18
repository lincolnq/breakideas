Introducing Break Ideas

I mentioned in a [blog
post](http://techhouse.org/~lincoln/blosxom.cgi/projects/breakideas.html) that
I had this idea for a project called Break Ideas. Well, it's working now,
sorta.  I started working on it because at [BarCamp
Boston](http://barcampboston.org) this weekend, there was a programming contest
where you were supposed to learn a new language and implement something useful
in it. Well, I learned [Arc](http://arclanguage.org) for this project. 

**What is Breakideas?** It's an idea sharing site. I started to spend a
few minutes just letting my mind come up with creative thoughts each day, and I
felt like I was discovering a lot of interesting and occasionally useful
insights about technological and social issues. Eight minutes is the length of
my twice-a-day wrist break, and it seemed like a reasonable length of time
to think -- not so short that I couldn't develop any ideas, but not so long
that it takes a significant chunk out of my day.

**How should I use it?** Go to the site! Take a break! Think! Write a summary!
If you can't think of anything, other people's ideas are provided to give you
inspiration. Pick one of them and develop it further. If you want people to be
able to contact you, put your contact information in your profile.

**What kind of rights do I have to my ideas?** Assume **NONE**! Don't be stupid
and post something valuable and expect anyone to respect your intellectual
property rights.  Don't write anything that you don't want other people to see,
because it's all made public. 

**Future Features:** user pages, fix random post selection algo

**Thoughts on Arc after about 6 hours using it:** 

I feel like I can see into PG's brain! 

Paul Graham, PG for short, is the designer of Arc. He wrote [Hacker
News](http://news.ycombinator.com) in it. As far as I know, News is the only
substantial production app written in Arc.

The language is basically a dialect
of Scheme, but it has a very different feel from the little bit of Scheme that
I've done. There are a TON of little macros and shortcut functions that capture
a pattern that showed up -- one I liked was `iflet` which, given a variable and
a test (as well as a then-body and else-body), binds the variable to the result
of the test, then executes the then-body or else-body depending on the truth of
the test.  It's a useful idiom for when something can be `nil`. The sheer number
of these little shortcuts makes reading other people's (pg's) code hard, because
while I can sometimes guess at their behavior by name, the precise semantics can
be hard to divine. 

Other than the pile of macros, the language is very satisfying to program in. I
was successfully able to read, understand and modify the blog.arc program
(distributed with the arc source) to do what I wanted, and in a fairly short
period of time I had something functional. 

I liked Arc for its simplicity in implementation -- looking
at the source code and making tweaks was extremely feasible, as well as the many
features it provided to reduce friction in web development. 

I had trouble with the heavy usage of macros in the example code
(treating them like functions is a bad idea), as well as the built-in user
authentication system (it
seems quite inflexible). The development environment REPL currently requires 3
commands after pressing Ctrl-C in order to restart the server and pick up your
changes (one in MzScheme to get back to Arc, one to reload the code and one to
start the server). 

Overall I'd recommend it to anyone who wants to do hobby web development, and
doesn't mind working in an environment which always feels like a prototype --
good because it's simple enough to be easy to change, but bad because it doesn't
seem robust.


