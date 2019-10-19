require_relative './messagesender'

FROM = 'simon.woolf@gmail.com'
RECIPIENTS = ENV['WILLPOWER_EMAILS_CSV']
SUBJECT = 'Request for low-willpower intervention'

BODY = %Q{
Hi!

If you're receiving this email, I'm having a critically low willpower procrastination-loop issue. You are under absolutely no obligation to do anything! But if you would enjoy helping, could you please:
1. reply to this email with 'On it' to tell any others cc'd that they don't need to do anything too,
2. set a timer for 15 minutes (as since I'll be a lot more likely to actually run this script if I know it won't result in me being called immediately),
3. when that timer goes off, call me (or text is ok too if you're not somewhere you can talk out loud) and:
  a. ask me what I'm putting off and why,
  b. ask me to make and tell you (there and then) a plan for what I'm going to do next,
  c. give me a time to text you to tell you whether I succeeded.

Thanks 😊

Simon
}

msg = MessageSender::send(RECIPIENTS, FROM, SUBJECT, BODY)
puts "Message sent 👍 #{msg.inspect}"
