exports.successResponse = (data, statusCode = 200) => ({
  statusCode,
  body: JSON.stringify(data),
});

exports.errorResponse = (err, statusCode = 500) => ({
  statusCode,
  body: JSON.stringify({ error: err.message || 'Server Error' }),
});
