# Cheapskate

Seamlessly jump to a separate domain for HTTPS login and then back.

## Note

The below information is a work in progress. Don't use this yet; it isn't ready.

## Usage

OK, here's how this works. First, obviously, you add cheapskate to your Gemfile:

    gem 'cheapskate'

The gem provides its own Rails engine, which adds the following to your app:

### Routes

    POST /login
    GET  /logged_in

    POST /register
    GET  /registered

### Models

- `SingleUseLogin`
- `SingleUseNotice`

### Customization

Both the **/logged_in** and **/registered** routes redirect back to `Cheapskate::CONFIG['ROOT_PATH']`,
which defaults to `"/"`.

Internally much of the logic where the gem hooks into your application is found in the
`Cheapskate::Client` module. You can include this module and override any of these methods if you
want:

- `create_user(params)` - will create user from `params[:user]` with keys `:name` and `:email` (and
  password w/ confirmation) by default
- `find_user(params)` - will look up user by `params[:email]` by default
- `authenticate_user(user, params)`
- `user_name(user)`
- `store_user_in_session(user, session)` - will set `session[:user_id] = user.id` by default
- `alert_notice(controller, message)` - uses `flash[:notice]` by default
- `alert_error(controller, message)` - uses `flash[:notice]` by default

If you implement your own client (by defining a class that includes `Cheapskate::Client`),
Cheapskate will automatically use your implementation.
