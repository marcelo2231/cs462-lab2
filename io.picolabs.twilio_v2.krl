ruleset io.picolabs.twilio_v2 {
  meta {
    provides
        send_sms, messages
  }
 
  global {
    send_sms = defaction(to, from, message) {
       base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
       http:post(base_url + "Messages.json", form = {
                "From":from,
                "To":to,
                "Body":message
            })
    }
    messages = function(messageSid, to, from) {
       messageSid = ((messageSid == null || messageSid == "") => "/" | messageSid + "/");
       base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/Messages/#{messageSid}>>;
       query = {};
       query = (to == "") => query | query.put(["To"], to);
       query = (from == "") => query | query.put(["From"], from);
       http:get(base_url, qs = query);
    }
  }
}