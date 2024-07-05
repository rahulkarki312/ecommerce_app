/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.calculateAverageRating = functions.https.onRequest(async (req, res) => {
  const productId = req.query.productId;

  if (!productId) {
    return res.status(400).send("Missing productId parameter");
  }

  try {
    const reviewsRef = admin.database().ref(`/products/${productId}/reviews`);
    const reviewsSnapshot = await reviewsRef.once("value");

    if (!reviewsSnapshot.exists()) {
      return res.status(404).send("No reviews found for the specified product");
    }

    let totalRating = 0;
    let numberOfReviews = 0;

    reviewsSnapshot.forEach((reviewSnapshot) => {
      const reviewData = reviewSnapshot.val();
      if (reviewData.rating) {
        totalRating += reviewData.rating;
        numberOfReviews++;
      }
    });

    const averageRating = totalRating / numberOfReviews;
    const roundedAverageRating = Math.round(averageRating * 2) / 2;

    return res.status(200).send({roundedAverageRating});
  } catch (error) {
    console.error("Error calculating average rating:", error);
    return res.status(500).send("Internal Server Error");
  }
});

