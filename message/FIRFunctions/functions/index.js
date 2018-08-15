
//引用模組
const functions = require('firebase-functions');
const admin = require('firebase-admin');

//初始化
try {admin.initializeApp();} catch(e) {}

//Functions控制台顯示名稱、當DB的token被創建則觸發
exports.onCreateLeave = functions.database.ref('token')
  .onCreate(snap => {
    if (!snap.val()) {
      return console.log('No Leave data!');
    }
    const token = snap.val().toString();
    sendMessage(token);    
  });

  function sendMessage(recipient) {
    var messageTitle = "發送通知";
    var messageBody = "恭喜您第一次使用推播成功";
    sendMessageContent(messageTitle, messageBody, recipient);
  }

  function sendMessageContent(messageTitle, messageBody, recipient) {
    if (recipient == null) { return }

    //APNs推播格式
    var message = {
      
      apns: {
        headers: {
          'apns-priority': '10'
        },
        payload: {
          aps: {
            alert: {
              title: messageTitle,
              body: messageBody,
            },
            sound: 'default',
          }
        }
      },
      token: recipient
    };

    //寄送推播後的回應顯示在控制台
    admin.messaging().send(message)
      .then((response) => {
        // Response is a message ID string.
        console.log('Message send: ', recipient, ',ID: ', response);
      })
      .catch((error) => {
        console.log('Error sending message:', error);
      });
  }