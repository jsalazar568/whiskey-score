export function buildURLQueryString(base, params) {
  const searchParams = Object.entries(params).map((pair) => {
      if(Array.isArray(pair[1])) {
        return pair[1].map((value) => `${pair[0]}${encodeURIComponent('[]')}=${value}`).join('&');
      } else if (typeof pair[1] === 'string') {
        pair[1] = encodeURIComponent(pair[1]);
      }
      return pair.join('=');
    }).join('&');
  return `${base}?${searchParams}`;
}