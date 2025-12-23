import logo from './logo.svg';
import './App.css';

function App() {

  const callApi = async () => {
    try {
      const payload = {
        content: "Hello from React"
      };

      const response = await fetch('/api/put-into-db', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      if (!response.ok) {
        throw new Error(`HTTP error ${response.status}`);
      }

      const data = await response.json();
      console.log('API response:', data);
    } catch (error) {
      console.error('API call failed:', error);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />

        <button onClick={callApi}>
          Insert into DB
        </button>

      </header>
    </div>
  );
}

export default App;
