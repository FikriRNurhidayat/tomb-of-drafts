import { useEffect } from "react";
import { useState } from "react";

export default function useQuery() {
  const [queryParams, setQueryParams] = useState(new URLSearchParams());

  useEffect(() => {
    setQueryParams(new URLSearchParams(window.location.search));
  }, [window.location.search]);

  return queryParams;
}
