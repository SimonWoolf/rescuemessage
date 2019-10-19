require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'google/apis/gmail_v1'
require 'rmail'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'

class MessageSender
  Gmail = Google::Apis::GmailV1

  def self.send(to, from, subject, body)
    gmail = Gmail::GmailService.new
    gmail.authorization = gmail_credentials()

    message = RMail::Message.new
    message.header['To'] = to
    message.header['From'] = from
    message.header['Subject'] = subject
    message.body = body

    gmail.send_user_message('me',
                            upload_source: StringIO.new(message.to_s),
                            content_type: 'message/rfc822')
  end

  def self.gmail_credentials()
    if ENV['GMAIL_API_CLIENT_ID'].nil?
      raise "Required google auth env vars not found"
    end

    client_id = Google::Auth::ClientId.new(ENV['GMAIL_API_CLIENT_ID'], ENV['GMAIL_API_CLIENT_SECRET'])
    token_store_path = File.join(ENV['HOME'], '.config', 'google', 'credentials.yaml')
    token_store = Google::Auth::Stores::FileTokenStore.new(:file => token_store_path)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, Gmail::AUTH_SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)

    if credentials.nil?
      url = authorizer.get_authorization_url(base_url: OOB_URI)
      puts "Open the following URL in your browser and authorize the application."
      puts url
      code = gets "Enter the authorization code then press ctrl-d:"
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
    end

    credentials
  end
end
