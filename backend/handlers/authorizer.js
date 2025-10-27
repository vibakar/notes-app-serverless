const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

const client = jwksClient({
  jwksUri: 'https://dev-v7poxudd.us.auth0.com/.well-known/jwks.json'
});

function getKey(header, callback) {
  client.getSigningKey(header.kid, (err, key) => {
    if (err) return callback(err);
    callback(null, key.getPublicKey());
  });
}

exports.handler = async (event) => {
  const token = event.headers?.authorization?.replace('Bearer ', '');
  if (!token) {
    console.log("No token provided");
    return { isAuthorized: false };
  }

  try {
    const decoded = await new Promise((resolve, reject) => {
      jwt.verify(token, getKey, {
        audience: 'https://notes-api-serverless.com',
        issuer: 'https://login.notes-app-serverless.vibakar.com/',
        algorithms: ['RS256']
      }, (err, decoded) => {
        if (err) reject(err);
        else resolve(decoded);
      });
    });
    console.log("Authorization successfull");
    return {
      isAuthorized: true,
      context: {
        sub: String(decoded.sub || "anonymous"),
        email: String(decoded.email || "no-email")
      }
    };
  } catch (err) {
    console.error("JWT verification failed", err);
    return { isAuthorized: false };
  }
};
