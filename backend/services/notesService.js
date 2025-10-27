let notes = [];

exports.getAllNotes = async () => notes;

exports.getNoteById = async (id) => notes.find((n) => n.id === id);

exports.createNote = async (note) => {
  if (!note.id) {
    note.id = Date.now().toString();
  }

  notes.push(note);
  return note;
};

exports.updateNote = async (id, data) => {
  const index = notes.findIndex((n) => n.id === id);
  if (index === -1) {
    throw new Error(`Note with id ${id} not found`);
  }

  notes[index] = { ...notes[index], ...data };
  return notes[index];
};

exports.deleteNote = async (id) => {
  const index = notes.findIndex((n) => n.id === id);
  if (index === -1) {
    throw new Error(`Note with id ${id} not found`);
  }

  const deleted = notes.splice(index, 1)[0];
  return deleted;
};
