type RuntimeConfig = {
	VITE_API_BASE_URL: string;
	VITE_AUTH0_DOMAIN: string;
	VITE_AUTH0_CLIENT_ID: string;
	VITE_AUTH0_AUDIENCE: string;
	VITE_AUTH0_REDIRECT_URI: string;
};

export const config: RuntimeConfig = {
	// eslint-disable-next-line @typescript-eslint/no-explicit-any
	...((window as any).RUNTIME_CONFIG || {}),
};
