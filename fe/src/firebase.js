import firebase from 'firebase'
import axios from 'axios'

export const initializeFirebase = (options) => {
  console.log('options', options)
  firebase.initializeApp(options);

  const messaging = firebase.messaging();

  messaging.onMessage(async (payload) => {
    if (payload.data && payload.data.auth_req_id && window.confirm("authorize ciba consent")) {
      const params = new URLSearchParams();
      params.set('auth_req_id', payload.data.auth_req_id);
      params.set('consented', 'true');
      await axios.post('http://localhost:20000/consent', params, {
        validateStatus: (status) => status === 200,
      });
    }
    console.log('message received', payload);
  });
};

export const askForPermissionToReceiveNotifications = async () => {
  try {
    const messaging = firebase.messaging();
    const token = await messaging.getToken();
    console.log('firebase token', token);

    const params = new URLSearchParams();
    params.set('token', token);
    params.set('user_id', '133d0f1e-0256-4616-989c-fa569c217355');

    await axios.post('http://localhost:20000/subscribe', params, {
      validateStatus: (status) => status === 200
    });

    return token;
  } catch (error) {
    console.error(error);
  }
};
