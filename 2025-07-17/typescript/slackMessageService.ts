export async function sendSlackMessage(webhookUrl: string, payload: Object): Promise<Response> {
  return await fetch(webhookUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  });
}