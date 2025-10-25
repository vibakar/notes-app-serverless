import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { Auth0Provider } from '@auth0/auth0-react';
import "./index.css";
import App from "./App.tsx";
import { config } from "./config.ts";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <Auth0Provider
      domain={config.VITE_AUTH0_DOMAIN}
      clientId={config.VITE_AUTH0_CLIENT_ID}
      authorizationParams={{
        redirect_uri: config.VITE_AUTH0_REDIRECT_URI,
        audience: config.VITE_AUTH0_AUDIENCE
      }}
    >
      <App />
    </Auth0Provider>
  </StrictMode>,
);
