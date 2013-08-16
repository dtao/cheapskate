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
`Cheapskate::Client` class. You can inherit from this class and override any of these methods if you
want:

- `create_user(params)`
- `find_user(params)`
- `authenticate_user(user, params)`
- `user_name(user)`
- `store_user_in_session(user, session)`

If you implement your own client, then you must set the `Cheapskate::CONFIG['CLIENT_CLASS']` setting
accordingly.
