const { createNote } = require('../services/notesService');
const { successResponse, errorResponse } = require('../utils/response');

exports.handler = async (event) => {
  try {
    const data = JSON.parse(event.body);
    const newNote = await createNote(data);
    return successResponse(newNote, 201);
  } catch (err) {
    return errorResponse(err);
  }
};
