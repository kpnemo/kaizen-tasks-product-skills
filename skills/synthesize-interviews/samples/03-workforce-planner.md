# Interview 03: Workforce planner

| Field | Value |
|---|---|
| Interviewee | Ingrid Halvorsen (invented name) |
| Role | Workforce planner, weekly schedules for about 380 agents on two sites |
| Company | Larkspur Home Warranty (invented), contact center of about 380 agents across two sites, on a CXone-style platform |
| Interviewer | Product research, Kaizen Tasks workshop |
| Date | 2026-08-21 |
| Length | 55 minutes |

All names, companies, systems, and numbers are fictional and were written for the workshop.

---

Interviewer: Thank you for the time, Ingrid. What is your role, and how long have you been doing it?

Ingrid: Workforce planner. Seven years at Larkspur, five in this job. I build the weekly schedules for both sites, Columbus and Tulsa, about three hundred and eighty agents, and I run the forecast they are built on.

Interviewer: Is it just you?

Ingrid: Two planners, me and Tomas, and one real-time analyst in Tulsa who covers half the day. Columbus has no real-time analyst, so intraday in Columbus is me, on top of planning.

Interviewer: What does the real-time analyst do that you do not?

Ingrid: Watches the queue all day and moves people. In Tulsa that is one person's job for half a day. In Columbus it is squeezed between everything else I do, which is why Columbus reacts slower.

Interviewer: What tools do you work in?

Ingrid: The workforce module of the platform for forecasting and scheduling, the routing admin screens for skills, a spreadsheet for shift swaps, email, and the queue dashboard on a screen I never close.

Interviewer: Walk me through the weekly cycle.

Ingrid: Monday I refresh the forecast. Tuesday and Wednesday I build schedules for the week after next. Thursday the schedules publish. Friday is swaps and the mess from the week. Every day, all day, is intraday.

Interviewer: Let's start with the forecast. How is it built?

Ingrid: The model in the workforce module takes twelve weeks of history by fifteen-minute interval, by skill, and projects it forward with seasonality. I adjust it by hand for holidays and for anything I know about. Then it converts to staffing by interval, and the schedules are built to that.

Interviewer: What is "by skill"?

Ingrid: Voice claims, voice billing, chat claims, chat billing, cancellations, and so on. About fourteen skills across the two sites. The mix of contacts by skill is what decides whether I need chat people or voice people at two in the afternoon.

Interviewer: Where does the mix come from?

Ingrid: Two places. Routing tells me which skill a contact landed in. Disposition codes tell me what the contact turned out to be about. I forecast the contact mix from the disposition codes, because routing only knows what the customer pressed, and the customer presses billing to get to a person faster.

Interviewer: How much do you trust the codes?

Ingrid: Less than the supervisors do. If those are wrong, the forecast is wrong from the first step. And I have a reason to think they are inconsistent.

Interviewer: What is the reason?

Ingrid: The mix shifts every time a team gets a new supervisor. Same customers, same queues, and suddenly a team's cancellation share goes from eight percent to fourteen. I do not think it is the customers changing. I think it is what the new supervisor tells the team to click.

Interviewer: Have you raised it?

Ingrid: With the site lead, twice. The supervisors say their codes are clean, and each of them is probably right about their own team. The problem is that clean means something different on each team.

Interviewer: How accurate is the forecast on a normal week?

Ingrid: Within five percent on volume, most weeks. Interval accuracy is worse, but that is normal. The weeks that hurt are not the normal weeks.

Interviewer: What does a five percent miss cost?

Ingrid: On a normal day, nothing you would notice; a few intervals under target. Over a year it is the difference between hitting the service level bonus and not.

Interviewer: Tell me about the weeks that hurt.

Ingrid: Promotions. Marketing sends a promotion on Tuesday and I find out on Wednesday from the queue. The email goes out to two hundred thousand customers, "first month free on an upgrade," and chat volume goes up forty percent for three days.

Interviewer: How big is the miss?

Ingrid: Every "first month free" campaign is a thirty percent miss on chat. Voice is less, maybe fifteen. Cancellations spike too, oddly, because people log in to look at the offer and remember they wanted to cancel.

Interviewer: What happens on the floor when that lands?

Ingrid: Service level on chat drops from eighty percent to fifty for the afternoon. I pull people from voice, which pushes voice wait times up, and then I approve overtime for the evening. Last April that was eleven thousand dollars of overtime for one campaign.

Interviewer: Who notices first?

Ingrid: The customers, then the supervisors, then me. Marketing never. Marketing sees the campaign numbers; they do not see the queue.

Interviewer: Why does the forecast not see it coming?

Ingrid: The forecast model does not know what a promotion is. It knows what last Tuesday looked like. Unless somebody tells it, a promotion day is an outlier it smooths away, and then the next promotion is a surprise all over again.

Interviewer: Could you tell it?

Ingrid: There is a special-events feature. I can mark a day and give it a multiplier. I have to know the day and the multiplier. I know neither until it has happened.

Interviewer: Does marketing have a calendar?

Ingrid: They have a slide deck. I asked for it in January and got a version from December. The dates in it moved twice before the campaigns went out. There is no place where "an email goes to two hundred thousand customers on Tuesday at ten" is written down that I can read.

Interviewer: What have you tried?

Ingrid: I asked to be copied on the campaign approval emails. That worked for two months and then the person who copied me changed roles. I asked for a shared calendar; marketing said they would think about it. I built my own list of past promotions and their lift so at least I know the multiplier, if somebody ever tells me the day.

Interviewer: What is in that list?

Ingrid: Fourteen campaigns over two years. Campaign type, send day, send time, lift on chat and voice by day for three days after. It is the most useful spreadsheet I own and nobody else has seen it.

Interviewer: Does anyone in marketing know the queue effect of a campaign?

Ingrid: I sent them the April number once. They were surprised, then apologetic, then the next campaign went out the same way. It is not malice. There is no step in their process where I exist.

Interviewer: What would you want, ideally?

Ingrid: The day and the size of the audience, a week ahead. I can do the rest. Give me "Tuesday, ten in the morning, two hundred thousand, upgrade offer," and I will staff it.

Interviewer: What if the system could see marketing's sends directly?

Ingrid: Then I would want it to propose the multiplier from my fourteen campaigns and let me say yes. I would not want it to change the forecast without me looking, not for the first year.

Interviewer: Let's talk about shift swaps. What is the process?

Ingrid: An agent wants to swap a shift with another agent, or give one away, or pick one up. They email me and their supervisor. The supervisor replies approved or not. I check the rules, record it in the swap spreadsheet, and retype it into the schedule.

Interviewer: How many a week?

Ingrid: Sixty swap emails a week, give or take. More around holidays. I spend Friday afternoons on swaps, and whatever does not fit on Friday spills into Monday, which is forecast day.

Interviewer: What are the rules you check?

Ingrid: Both agents must have the skills for the shift. Neither goes over forty hours. Neither breaks the eleven-hour rest rule between shifts. The shift keeps the same interval coverage, or close. And the supervisor said yes.

Interviewer: How long does one take?

Ingrid: Three to five minutes if the email has everything. Fifteen if I have to reply asking which shift they mean, which is a third of them.

Interviewer: What is missing from the emails?

Ingrid: The date, half the time. "Can I swap my Thursday with Priya," when they both have two Thursdays in the published window. So I reply, they reply, and now it is Monday.

Interviewer: What goes wrong?

Ingrid: A swap that is approved by email and never retyped is an agent on the wrong day. The supervisor said yes, I missed the email or it landed on Monday, the schedule still shows the old shift, and on the day two agents are in and one is not.

Interviewer: How often?

Ingrid: I know of four or five a month across both sites. There are probably more that get sorted out on the floor and never reach me.

Interviewer: What does the agent see?

Ingrid: Their schedule in the app. If I have not retyped the swap, they see the old shift, and half of them trust the email more than the app. The other half trust the app, and that is how you get two agents in for one shift.

Interviewer: Is there a self-service swap feature in the platform?

Ingrid: There is. It was on before the migration two years ago. It was turned off during the migration because the rules were not configured, and nobody has turned it back on. I have asked. It is on a list.

Interviewer: What would it take to turn it on?

Ingrid: Somebody to configure the five rules I just told you, and the supervisors to approve in the app instead of email. The supervisors are fine with that. The configuration needs a vendor ticket, and the ticket needs a sponsor.

Interviewer: What is the swap spreadsheet for, if the schedule is the truth?

Ingrid: History. Who swapped with whom, how often, and who never gets their swap approved. When an agent complains that their supervisor never says yes, the spreadsheet is the only record.

Interviewer: How do agents feel about the process?

Ingrid: They think I am slow. From where they sit, they sent an email on Tuesday and nothing happened until Friday. They are not wrong.

Interviewer: Let's go to intraday. What does a normal afternoon look like?

Ingrid: I watch the queue dashboard. When chat goes red, which is most days around one and again around four, I have to find people. I walk the floor asking supervisors for bodies. In Tulsa the real-time analyst does it by message. Either way it is a person asking a person.

Interviewer: What happens when you ask?

Ingrid: The supervisor looks at their team and decides who they can spare. Dana is good about it; some of them are not. Everybody is protecting their own handle time and their own after-call backlog. I get two people when I need five.

Interviewer: And then?

Ingrid: I move them. Skill by skill, one agent at a time in the admin screen. Open the agent, change the skill assignment, save, next agent. Twelve agents is twelve screens, and the screen takes ten seconds to save.

Interviewer: How long does a reallocation take, start to finish?

Ingrid: Twenty minutes from red queue to the last agent moved. By the time the reallocation is done, the spike is over, and now I have too many people on chat and voice is red. So I move them back. That is my afternoon.

Interviewer: How many times a day?

Ingrid: Three or four moves on a normal day. Ten on a promotion day. Each one is me walking or messaging, then twelve screens.

Interviewer: What happens when you are in a meeting?

Ingrid: Nobody moves anyone. Chat stays red until I am back. Tomas can do it, but he is building schedules and does not watch the dashboard. There is no second person in Columbus.

Interviewer: Is there a rules-based reallocation in the platform?

Ingrid: There is a way to give agents secondary skills so the router can spill over. Supervisors do not like it, because an agent with a chat secondary skill gets pulled into chat by the router without anyone asking, and the supervisor's numbers move. So most agents have one skill, and I move them by hand.

Interviewer: Is the supervisors' objection reasonable?

Ingrid: Partly. Their numbers do move, and they get measured on them. But the alternative is me walking the floor. If the router could take two people from each team instead of five from one, they would mind less. It cannot; it takes whoever is free.

Interviewer: What do you look at when you decide who to move?

Ingrid: Who has both skills, who is not mid-call, whose team is least behind on after-call work, and who I moved last time, so it is not always the same two people. That is four screens before I have moved anyone.

Interviewer: Do you ever move the wrong person?

Ingrid: Every week. Somebody who was mid-cancellation and got a chat dropped on them, or somebody I moved twice in one day. I find out when the supervisor messages me.

Interviewer: What would you want instead?

Ingrid: Tell me "chat will be red in fifteen minutes," and give me a list of six people who could move with the least damage, and one button. I would still press the button myself.

Interviewer: Why fifteen minutes?

Ingrid: Because I can see the queue now. What I cannot see is the queue in fifteen minutes, and by the time I can see it, it is too late to do anything but overtime.

Interviewer: Could you trust a prediction like that?

Ingrid: I would compare it to what happened for a month. If it called the spike right three times out of four, I would move people on it. I already move people on my own guess, and my guess is not three out of four.

Interviewer: Supervisors have asked for different wrap-up windows by contact reason. What is your view?

Ingrid: I would take it if the codes were reliable enough to tell me the reason. Right now a per-reason wrap-up window means a per-reason forecast, and I do not trust the reason. Fix the codes first, then I will forecast wrap-up by reason gladly.

Interviewer: Does the after-call backlog show up in your numbers?

Ingrid: As agents in wrap-up state who are not available. If a team has forty open wrap-ups at three, that is forty intervals of somebody not answering. I see the state; I do not see what is in the backlog or whether it matters.

Interviewer: Do you and the supervisors look at the same numbers?

Ingrid: No. They see their team's dashboard; I see the site's. When I say chat is red and Dana says her team is fine, we are both right, and that is the argument every afternoon.

Interviewer: What do supervisors not understand about planning?

Ingrid: That the schedule they got was the best one for the whole building, not for their team. And that every swap they approve by email is a change I have to make by hand.

Interviewer: What do you not understand about the floor?

Ingrid: Why a call about a claim takes six minutes on one team and nine on another. I see the numbers. I do not see the windows.

Interviewer: If you could fix one thing first, which one?

Ingrid: The promotion misses. One bad campaign costs more than a year of swap emails. The swap fix is a configuration ticket; the promotion fix needs somebody in marketing to tell me a date.

Interviewer: And the second?

Ingrid: Intraday. Not because it is the biggest cost, because it is my whole afternoon, every day.

Interviewer: What would make you worry about automation here?

Ingrid: A system that moves people without telling the supervisor. The first time an agent disappears from a team's numbers without warning, every supervisor turns the feature off. Anything that moves people has to tell the supervisor first and let them say no once.

Interviewer: How would you measure success?

Ingrid: Service level on promotion days within ten points of a normal day. Swaps retyped by hand at zero. Reallocation from red queue to agents moved under five minutes. I have the baseline for all three.

Interviewer: Do you share those numbers with anyone?

Ingrid: A weekly deck to the site leads. Volume, service level, adherence, overtime. Nobody asks about the swap count or the reallocation time because nobody knows they exist.

Interviewer: What would you add to that deck if someone asked?

Ingrid: Promotion-day misses as a line item with the overtime cost next to it. Once somebody sees eleven thousand dollars next to "nobody told planning," the calendar conversation gets easier.

Interviewer: What is the most manual thing you do that should not be?

Ingrid: Retyping. Swaps into the schedule, skill changes into the admin screen, promotion dates into the special-events screen. Three different screens, all of them me typing something that already exists somewhere else.

Interviewer: If planning and supervisors had one shared view, what would be on it?

Ingrid: The queue now and in fifteen minutes, who could move, who is in wrap-up and on what, and whether there is a promotion today. One screen, both of us looking at the same thing. Right now we argue from different dashboards.

Interviewer: Have the agents ever been asked about any of this?

Ingrid: Not by me. I should. If Marcus on Dana's team is clicking a code because it was the first thing the customer said, I would rather know that than keep pretending the mix is real.

Interviewer: Anything I should have asked?

Ingrid: Ask marketing when their next send is. If they can tell you, tell me.

Interviewer: I will. Thank you, Ingrid.

Ingrid: Thank you. My afternoon starts in ten minutes; chat goes red at one.
