const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

exports.pushNotifications = functions.firestore.document('/realTimeTweets/{documentID}').onCreate(async(snapshot,context) => {
    if(snapshot.empty){
        console.log("No devices");
        return;
    }
    var payload = {
        notification: {
            title: 'Discuss Now ⚽',
            body: "Head over to know what's happening 🔥",
        }, 
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                view: 'real_time' 
            }
    } 
    try {
        const response = await admin.messaging().sendToTopic("all", payload);
        console.log("Notification sent");
    } catch (err) {
        console.log(err);
    }
});

exports.ISLNotifications = functions.firestore.document('/Forum/ISL/Posts/{documentID}').onCreate(async(snapshot,context) => {
    if(snapshot.empty){
        console.log("No devices");
        return;
    }
    var payload = {
        notification: {
            title: 'ISL Forum ⚽',
            body: "Head over to discuss about the ISL 🔥",
        }, 
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                view: 'ISL_forum' 
            }
    } 
    try {
        const response = await admin.messaging().sendToTopic("all", payload);
        console.log("Notification sent");
    } catch (err) {
        console.log(err);
    }
});

exports.NTNotifications = functions.firestore.document('/Forum/National Team/Posts/{documentID}').onCreate(async(snapshot,context) => {
    if(snapshot.empty){
        console.log("No devices");
        return;
    }
    var payload = {
        notification: {
            title: 'National Team Forum ⚽',
            body: "Head over to discuss about Indian Football 🇮🇳🔥",
        }, 
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                view: 'NT_forum' 
            }
    } 
    try {
        const response = await admin.messaging().sendToTopic("all", payload);
        console.log("Notification sent");
    } catch (err) {
        console.log(err);
    }
});

exports.PollsNotification = functions.firestore.document('/PlayerBattle/{documentID}').onCreate(async(snapshot,context) => {
    if(snapshot.empty){
        console.log("No devices");
        return;
    }
    var payload = {
        notification: {
            title: 'Battle Started ⚔️⚽',
            body: "Head over to vote now 🇮🇳🔥",
        }, 
            data: {
                click_action: 'FLUTTER_NOTIFICATION_CLICK',
                view: 'Poll' 
            }
    } 
    try {
        const response = await admin.messaging().sendToTopic("all", payload);
        console.log("Notification sent");
    } catch (err) {
        console.log(err);
    }
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });