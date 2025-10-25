import { withAuthenticationRequired } from '@auth0/auth0-react';
import AppHeader from './AppHeader';
import NotesList from './NotesList'; 

const AppContent = () => (
    <>
      <AppHeader />
      <NotesList />
    </>
);

const ProtectedAppContent = withAuthenticationRequired(AppContent, {
  onRedirecting: () => <div>Loading...</div>,
});

export default ProtectedAppContent;