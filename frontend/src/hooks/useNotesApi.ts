import axios from "axios";
import { useAuth0 } from "@auth0/auth0-react";
import { useMemo } from "react";
import { config } from "../config";

export interface Note {
  id: string;
  title: string;
  content: string;
}

// This hook returns the complete, authorized service interface
export const useNotesApi = () => {
  const { getAccessTokenSilently } = useAuth0();
  
  // Use useMemo to ensure service functions are only recreated when dependencies change
  return useMemo(() => {
    
    const axiosInstance = axios.create({
      baseURL: `${config.VITE_API_BASE_URL}/api/v1/notes`,
    });

    const authorizedRequest = async <T>(request: (token: string) => Promise<T>): Promise<T> => {
      const token = await getAccessTokenSilently({
        authorizationParams: {
          audience: `${config.VITE_AUTH0_AUDIENCE}`,
        },
      });
      return request(token);
    };

    return {
      fetchNotes: (): Promise<Note[]> => authorizedRequest(async (token) => {
        const response = await axiosInstance.get<Note[]>("/", {
          headers: { Authorization: `Bearer ${token}` },
        });
        return response.data;
      }),

      deleteNote: (id: string): Promise<void> => authorizedRequest(async (token) => {
        await axiosInstance.delete(`/${id}`, {
          headers: { Authorization: `Bearer ${token}` },
        });
      }),

      createNote: (note: Pick<Note, "title" | "content">): Promise<Note> => authorizedRequest(async (token) => {
        const response = await axiosInstance.post<Note>("/", note, {
          headers: { Authorization: `Bearer ${token}` },
        });
        return response.data;
      }),
    };
  }, [getAccessTokenSilently]);
};