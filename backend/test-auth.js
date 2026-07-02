fetch('http://localhost:8788/api/auth/sign-up/email', {
  method: 'POST',
  headers: { 
    'Content-Type': 'application/json',
    'Origin': 'http://localhost:5173'
  },
  body: JSON.stringify({
    name: 'Test User',
    email: 'test6@test.com',
    password: 'password123'
  })
}).then(async res => {
  console.log(res.status);
  console.log(await res.text());
}).catch(console.error);
