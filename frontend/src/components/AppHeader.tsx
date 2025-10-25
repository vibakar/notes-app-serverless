import AppBar from "@mui/material/AppBar";
import Box from "@mui/material/Box";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import IconButton from '@mui/material/IconButton';
import LogoutIcon from '@mui/icons-material/Logout';
import { useAuth0 } from "@auth0/auth0-react";

export default function AppHeader() {
  const { user, logout } = useAuth0();

  return (
    <Box className="fg-1">
      <AppBar position="static">
        <Toolbar className="app-header">
          <Typography variant="h6" component="div" className="fg-1">
            Notes
          </Typography>
          <Typography variant="h6" component="div" className="fg-1">
            {user?.nickname
              ? `Welcome ${user.nickname.charAt(0).toUpperCase() + user.nickname.slice(1)}!`
              : "Welcome Guest!"}

          </Typography>
          <div>
            <IconButton
              onClick={() => logout({ logoutParams: { returnTo: window.location.origin } })}
              color="inherit"
            >
            <LogoutIcon />
            </IconButton>
          </div>
        </Toolbar>
      </AppBar>
    </Box>
  );
}
