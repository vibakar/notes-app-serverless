import React, { useEffect, useState, useCallback } from "react";
import {
  Grid,
  Button,
  Container,
  Card,
  CardActions,
  CardContent,
  IconButton,
  Typography,
  CircularProgress,
} from "@mui/material";
import AddIcon from "@mui/icons-material/Add";
import Alert from '@mui/material/Alert';
import DeleteIcon from "@mui/icons-material/Delete";
import Snackbar from '@mui/material/Snackbar';
import type { AlertColor } from '@mui/material/Alert';
import AddNote from "./AddNote";
import { useNotesApi } from "../hooks/useNotesApi";
import type { Note } from "../hooks/useNotesApi";

interface SnackbarState {
  open: boolean;
  severity: AlertColor;
  message: string;
}

const NotesList: React.FC = () => {
  const [notes, setNotes] = useState<Note[]>([]);
  const [loading, setLoading] = useState(true);
  const [snackbar, setSnackbar] = useState<SnackbarState>({open: false, severity: "success", message: ""})
  const [openModal, setOpenModal] = useState(false);
  const handleOpen = useCallback(() => setOpenModal(true), [setOpenModal]);
  const handleClose = useCallback(() => setOpenModal(false), [setOpenModal]);
  const notesApi = useNotesApi();

  const getAllNotes = React.useCallback(async () => {
    try {
      const data = await notesApi.fetchNotes();
      setNotes(data);
    } catch {
      setSnackbar({
        open: true,
        severity: "error",
        message: "Failed to fetch Notes!"
      });
    } finally {
      setLoading(false);
    }
  }, [notesApi]);

  useEffect(() => {
    getAllNotes();
  }, [getAllNotes]);

  const handleDelete = async (id: string) => {
    try {
      await notesApi.deleteNote(id);
      setNotes((prevNotes) => prevNotes.filter((note) => note.id !== id));
      setSnackbar({
        open: true,
        severity: "success",
        message: "Note deleted successfully"
      });
    } catch {
      setSnackbar({
        open: true,
        severity: "error",
        message: "Failed to delete note"
      });
    }
  };

  const handleCreate = React.useCallback(async (note: { title: string; content: string }) => {
    try {
      await notesApi.createNote(note);
      setSnackbar({
        open: true,
        severity: "success",
        message: "Note added successfully"
      });
      getAllNotes() // Calls the stable function
    } catch {
      setSnackbar({
        open: true,
        severity: "error",
        message: "Failed to create note"
      });
    } finally {
      handleClose();
    }
  }, [notesApi, setSnackbar, handleClose, getAllNotes]);

  const handleSnackbarClose = () => {
    setSnackbar({
      open: false,
      severity: "success",
      message: ""
    });
  };

  if (loading) {
    return (
      <Container sx={{ textAlign: "center", marginTop: 8 }}>
        <CircularProgress />
      </Container>
    );
  }

  return (
    <>
      <Snackbar
        autoHideDuration={5000}
        open={snackbar.open}
        onClose={handleSnackbarClose}
        anchorOrigin={{ vertical: 'top', horizontal: 'right' }}>
          <Alert
            severity={snackbar.severity}
            variant="filled"
            sx={{ width: '100%' }}
          >
            {snackbar.message}
          </Alert>
      </Snackbar>
      {notes.length > 0 ? (
        <Container className="card-container">
          <div className="card-add-container">
            <Button
              component="label"
              variant="contained"
              onClick={handleOpen}
              startIcon={<AddIcon />}
            >
              Create Note
            </Button>
          </div>
          <Grid container spacing={3}>
            {notes.map((note) => (
              <Grid key={note.id}>
                <Card variant="outlined" className="app-card">
                  <CardActions>
                    <IconButton
                      aria-label="delete"
                      onClick={() => handleDelete(note.id)}
                      className="card-delete-button"
                    >
                      <DeleteIcon className="card-delete-icon" />
                    </IconButton>
                  </CardActions>

                  <CardContent>
                    <Typography variant="h6" gutterBottom>
                      {note.title}
                    </Typography>
                    <Typography variant="body2" color="text.secondary">
                      {note.content}
                    </Typography>
                  </CardContent>
                </Card>
              </Grid>
            ))}
          </Grid>
        </Container>
      ) : (
        <Container className="no-notes">
          <Typography variant="h6">Nothing here yet. Add a new note to get started.</Typography>
          <Button
            component="label"
            variant="contained"
            onClick={handleOpen}
            startIcon={<AddIcon />}
          >
            Create Note
          </Button>
        </Container>
      )}
      <AddNote open={openModal} onClose={handleClose} onSubmit={handleCreate} />
    </>
  );
};

export default NotesList;
