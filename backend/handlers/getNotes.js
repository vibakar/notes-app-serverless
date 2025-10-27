const { getAllNotes } = require('../services/notesService');
const { successResponse, errorResponse } = require('../utils/response');

exports.handler = async (event) => {
  try {
    const notes = await getAllNotes();
    return successResponse(notes);
  } catch (err) {
    return errorResponse(err);
  }
};
