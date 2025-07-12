import React, { createContext, useState, useContext } from "react";
import { useMemo } from "react";

// Create a context with default value 'light'
const ThemeContext = createContext();

export function ThemeProvider({ children }) {
  const isDarkMode = useMemo(() => {
    return window?.matchMedia("(prefers-color-scheme: dark)").matches;
  }, []);

  const theme = useMemo(() => (isDarkMode ? "dark" : "light"), [isDarkMode]);

  return (
    <ThemeContext.Provider value={theme}>{children}</ThemeContext.Provider>
  );
}

export function useTheme() {
  return useContext(ThemeContext);
}
