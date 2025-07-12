import { useCallback } from "react";
import { useState } from "react";
import FetchError from "../errors/FetchError";

/**
 * @param {string | URL | Request} input
 * @param {RequestInit} init
 */
export default function useFetch(input, init) {
  const [loading, setLoading] = useState(false);

  const call = useCallback(async () => {
    setLoading(true);

    const response = await fetch(input, init);

    const responseBody = await response.json();

    setLoading(false);

    if (response.ok) return responseBody;

    throw new FetchError(response, responseBody);
  }, [input, init]);

  return {
    loading,
    call,
  };
}
