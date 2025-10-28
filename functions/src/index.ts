import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as cors from 'cors';
import * as express from 'express';

// Initialize Firebase Admin
admin.initializeApp();

const app = express();
app.use(cors({ origin: true }));

// Auto Grouping Function
export const autoGrouping = functions.firestore
  .document('listings/{listingId}')
  .onCreate(async (snap, context) => {
    const listing = snap.data();
    const listingId = context.params.listingId;

    try {
      // Get similar listings for grouping
      const similarListings = await admin.firestore()
        .collection('listings')
        .where('cropName', '==', listing.cropName)
        .where('cropCategory', '==', listing.cropCategory)
        .where('state', '==', listing.state)
        .where('status', '==', 'active')
        .get();

      if (similarListings.size >= 3) {
        // Create a group
        const groupData = {
          name: `${listing.cropName} Group - ${listing.state}`,
          cropName: listing.cropName,
          cropCategory: listing.cropCategory,
          location: listing.location,
          city: listing.city,
          state: listing.state,
          pincode: listing.pincode,
          totalQuantity: 0,
          quantityUnit: listing.quantityUnit,
          minPrice: 0,
          maxPrice: 0,
          averagePrice: 0,
          priceUnit: listing.priceUnit,
          farmerIds: [],
          listingIds: [],
          farmerCount: 0,
          harvestDate: listing.harvestDate,
          status: 'active',
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          createdBy: listing.farmerId,
        };

        // Calculate group statistics
        let totalQuantity = 0;
        let minPrice = Number.MAX_VALUE;
        let maxPrice = 0;
        const farmerIds: string[] = [];
        const listingIds: string[] = [];

        similarListings.forEach(doc => {
          const data = doc.data();
          totalQuantity += data.quantity;
          minPrice = Math.min(minPrice, data.pricePerUnit);
          maxPrice = Math.max(maxPrice, data.pricePerUnit);
          farmerIds.push(data.farmerId);
          listingIds.push(doc.id);
        });

        groupData.totalQuantity = totalQuantity;
        groupData.minPrice = minPrice;
        groupData.maxPrice = maxPrice;
        groupData.averagePrice = (minPrice + maxPrice) / 2;
        groupData.farmerIds = farmerIds;
        groupData.listingIds = listingIds;
        groupData.farmerCount = farmerIds.length;

        // Create the group
        const groupRef = await admin.firestore()
          .collection('groups')
          .add(groupData);

        // Update all listings with group ID
        const batch = admin.firestore().batch();
        listingIds.forEach(listingId => {
          const listingRef = admin.firestore()
            .collection('listings')
            .doc(listingId);
          batch.update(listingRef, {
            groupId: groupRef.id,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        });
        await batch.commit();

        // Send notifications to farmers
        await sendGroupCreatedNotifications(farmerIds, groupData.name);
      }
    } catch (error) {
      console.error('Error in autoGrouping:', error);
    }
  });

// Mandi Price Update Function
export const mandiPriceCron = functions.pubsub
  .schedule('every 15 minutes')
  .onRun(async (context) => {
    try {
      // Mock mandi price data - replace with actual API call
      const mandiPrices = [
        {
          cropName: 'Rice',
          cropCategory: 'Cereals',
          mandiName: 'Delhi Mandi',
          state: 'Delhi',
          district: 'New Delhi',
          price: 2500,
          priceUnit: 'per_quintal',
          variety: 'Basmati',
          grade: 'A',
          priceTrend: 'up',
          priceChange: 50,
          priceChangePercent: 2.04,
          priceDate: admin.firestore.Timestamp.now(),
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        {
          cropName: 'Wheat',
          cropCategory: 'Cereals',
          mandiName: 'Punjab Mandi',
          state: 'Punjab',
          district: 'Amritsar',
          price: 2200,
          priceUnit: 'per_quintal',
          variety: 'Durum',
          grade: 'A',
          priceTrend: 'down',
          priceChange: -30,
          priceChangePercent: -1.34,
          priceDate: admin.firestore.Timestamp.now(),
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        // Add more crops as needed
      ];

      // Update mandi prices in Firestore
      const batch = admin.firestore().batch();
      mandiPrices.forEach(priceData => {
        const priceRef = admin.firestore()
          .collection('mandiPrices')
          .doc(`${priceData.cropName}_${priceData.mandiName}_${Date.now()}`);
        batch.set(priceRef, priceData);
      });
      await batch.commit();

      console.log('Mandi prices updated successfully');
    } catch (error) {
      console.error('Error updating mandi prices:', error);
    }
  });

// Razorpay Order Creation
export const createRazorpayOrder = functions.https.onCall(async (data, context) => {
  try {
    const { amount, currency, orderId } = data;
    
    // Validate user authentication
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Create order in Firestore
    const orderData = {
      id: orderId,
      retailerId: context.auth.uid,
      amount: amount,
      currency: currency || 'INR',
      status: 'pending',
      paymentStatus: 'pending',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    await admin.firestore()
      .collection('orders')
      .doc(orderId)
      .set(orderData);

    // In a real implementation, you would call Razorpay API here
    // For now, return a mock response
    return {
      success: true,
      orderId: orderId,
      amount: amount,
      currency: currency || 'INR',
      razorpayOrderId: `rzp_order_${Date.now()}`,
    };
  } catch (error) {
    console.error('Error creating Razorpay order:', error);
    throw new functions.https.HttpsError('internal', 'Failed to create order');
  }
});

// Release Payment Function
export const releasePayment = functions.https.onCall(async (data, context) => {
  try {
    const { orderId, verificationId } = data;
    
    // Validate user authentication and role
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
    }

    // Check if user is a hub
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(context.auth.uid)
      .get();
    
    if (!userDoc.exists || userDoc.data()?.role !== 'hub') {
      throw new functions.https.HttpsError('permission-denied', 'Only hubs can release payments');
    }

    // Update order status
    await admin.firestore()
      .collection('orders')
      .doc(orderId)
      .update({
        status: 'delivered',
        paymentStatus: 'released',
        verificationId: verificationId,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Send notification to retailer
    const orderDoc = await admin.firestore()
      .collection('orders')
      .doc(orderId)
      .get();
    
    if (orderDoc.exists) {
      const orderData = orderDoc.data();
      await sendNotification(orderData?.retailerId, {
        title: 'Payment Released',
        body: 'Your payment has been released for order #' + orderId,
        type: 'payment_released',
        data: { orderId },
      });
    }

    return { success: true };
  } catch (error) {
    console.error('Error releasing payment:', error);
    throw new functions.https.HttpsError('internal', 'Failed to release payment');
  }
});

// Send Notification Function
async function sendNotification(userId: string, notification: any) {
  try {
    // Get user's FCM token
    const userDoc = await admin.firestore()
      .collection('users')
      .doc(userId)
      .get();
    
    if (userDoc.exists) {
      const userData = userDoc.data();
      const fcmToken = userData?.fcmToken;
      
      if (fcmToken) {
        const message = {
          token: fcmToken,
          notification: {
            title: notification.title,
            body: notification.body,
          },
          data: {
            type: notification.type,
            ...notification.data,
          },
        };

        await admin.messaging().send(message);
      }
    }

    // Save notification to Firestore
    await admin.firestore()
      .collection('notifications')
      .add({
        userId: userId,
        title: notification.title,
        body: notification.body,
        type: notification.type,
        data: notification.data,
        isRead: false,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
  } catch (error) {
    console.error('Error sending notification:', error);
  }
}

// Send Group Created Notifications
async function sendGroupCreatedNotifications(farmerIds: string[], groupName: string) {
  const notifications = farmerIds.map(farmerId => ({
    userId: farmerId,
    title: 'Group Created',
    body: `You have been added to group: ${groupName}`,
    type: 'group_created',
    data: { groupName },
    isRead: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  }));

  const batch = admin.firestore().batch();
  notifications.forEach(notification => {
    const notificationRef = admin.firestore()
      .collection('notifications')
      .doc();
    batch.set(notificationRef, notification);
  });
  await batch.commit();
}

// Export the Express app for HTTP functions
export const api = functions.https.onRequest(app);
