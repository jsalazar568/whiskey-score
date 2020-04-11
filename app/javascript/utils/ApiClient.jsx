function client(endpoint, {data, ...customConfig} = {}) {
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

  const config = {
    method: data ? 'POST' : 'GET',
    ...customConfig,
    headers: {
      'X-CSRF-Token': csrfToken,
      'Content-Type': 'application/json',
      ...customConfig.headers,
    },
  }
  if (data) {
    config.body = JSON.stringify(data)
  }

  return window
    .fetch(endpoint, config)
    .then(async response => {
      const data = await response.json()
      if (response.ok) {
        return data
      } else {
        return Promise.reject(data)
      }
    })
}

export { client };