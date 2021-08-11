# go-ciba-demo

A working implementation of the `go-ciba` [library](https://github.com/adisazhar123/go-ciba).

## Steps to get this running

1. Copy your Firebase service account key to `app/service_account_key.json`. You can generate the key in [Firebase console](https://console.firebase.google.com).
2. Set your Firebase server key in environment variable `FCM_SERVER_KEY` in `docker-compose.yaml`. The server key can be retrieved from **Firebase console > Project settings > Cloud messaging**.
3. Set your Firebase credentials in `REACT_APP_API_KEY`, `REACT_APP_AUTH_DOMAIN`, `REACT_APP_PROJECT_ID`, `REACT_APP_STORAGE_BUCKET`, `REACT_APP_MESSAGING_SENDER_ID`, and `REACT_APP_APP_ID`. Can be retrieved from **Firebase console > Project settings > General**. 
4. Run `docker-compose up`.
5. Navigate to `localhost:3000`, this web app will act as consent receiver and giver. You probably will use a mobile app in a real world scenario.
6. Import `app/go-ciba.postman_collection.json` to Postman.
7. Execute the followning APIs in order.
    - Auth => This will initiate an authentication request.
    - Give Consent => This will allow the user to give a consent (allow or disallow). can be done via Postman or the web app. If using Postman, copy the `auth_req_id` retrieved from Auth
    - Get Token => This will allow the client app to get an access and id token. copy the `auth_req_id` from Auth
    - Fetch Protected Resource => This is a protected endpoint. Only access tokens with scope `timestamp.read` is allowed in. Copy the access token from the token endpoint
 