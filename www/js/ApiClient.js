export function sendPostRequest(url, payload) {
  const myHeaders = new Headers();
  myHeaders.append("Content-Type", "application/json");

  const requestOptions = {
    method: "POST",
    headers: myHeaders,
    body: JSON.stringify(payload),
    redirect: "follow",
  };

  return fetch(url, requestOptions)
    .then((response) => response.json())
    .catch((error) => {
      console.error("Error during POST request:", error);
      throw error;
    });
}

export function sendGetRequest(url) {

  const requestOptions = {
    method: "GET",
    headers: new Headers({
      Accept: "application/json",
      "Content-Type": "application/json",
    }),
    redirect: "follow",
  };

  return fetch(url, requestOptions)
    .then((response) => response.json())
    .catch((error) => {
      console.error("Error during GET request:", error);
      throw error;
    });
}
